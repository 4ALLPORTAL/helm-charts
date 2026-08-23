{{/*
Lua helpers shared by every janitor Cleaner rule. Included into each rule's
`evaluate` block, because k8s-cleaner evaluates every resourceSelector in its
own Lua state — there is no place for a chart-wide prelude.

The timestamp parsing deliberately does NOT follow the upstream k8s-cleaner
time-based examples (examples-unused-resources/time_based_delete). Those feed the
parsed fields to os.time, which interprets its table argument as LOCAL time —
Lua has no UTC counterpart. Comparing that against os.time() therefore skews
every age by the container's UTC offset plus the DST hour: measured at the 24h
threshold, a UTC+2 container deletes at 22h and a UTC-4 one at 28h. That the
image happens to run in UTC today is not something this chart can rely on, so
epochs are computed arithmetically instead (utcEpoch below) and compared against
os.time(), which is UTC by definition.
*/}}
{{/*
Notification block shared by every Cleaner. Without a CleanerReport notification
the controller records nothing outside its own log — no Report CR, so a dryRun
(action: Scan) cannot be inspected and a real delete leaves no audit trail.
*/}}
{{- define "base-cluster.janitor.notifications" -}}
{{- if .Values.janitor.report.enabled -}}
notifications:
  - name: cleaner-report
    type: CleanerReport
{{- end }}
{{- end -}}

{{- define "base-cluster.janitor.luaHelpers" -}}
-- Seconds between 1970-01-01 and a UTC civil date, computed without os.time so
-- the result never depends on the container's timezone. days-from-civil per
-- Howard Hinnant's algorithm: shift the year to start in March, so the leap day
-- lands at the end of the 400-year era and the month-length table becomes a
-- linear formula.
function utcEpoch(y, mon, d, h, mi, s)
  local shifted = y
  if mon <= 2 then
    shifted = shifted - 1
  end
  local era = math.floor(shifted / 400)
  local yearOfEra = shifted - era * 400                      -- [0, 399]
  local marchZeroMonth = (mon + 9) % 12                       -- March = 0
  local dayOfYear = math.floor((153 * marchZeroMonth + 2) / 5) + d - 1
  local dayOfEra = yearOfEra * 365 + math.floor(yearOfEra / 4)
    - math.floor(yearOfEra / 100) + dayOfYear
  local days = era * 146097 + dayOfEra - 719468               -- 719468 = 1970-01-01
  return days * 86400 + h * 3600 + mi * 60 + s
end

-- Parse an RFC3339 timestamp ("2026-07-31T09:35:56Z") into epoch seconds.
-- Returns nil when the value is absent or not in that exact shape.
function toEpoch(timestampStr)
  if timestampStr == nil then
    return nil
  end
  local converted = string.gsub(
    timestampStr,
    '(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)Z',
    function(y, mon, d, h, mi, s)
      return utcEpoch(
        tonumber(y), tonumber(mon), tonumber(d),
        tonumber(h), tonumber(mi), tonumber(s)
      )
    end
  )
  return tonumber(converted)
end

-- true only when the epoch is known AND older than the threshold. Unknown
-- timestamps deliberately return false: never delete what cannot be dated.
-- hours = 0 disables the check (any known timestamp is then "old enough").
-- os.time() with no argument is UTC epoch seconds, matching utcEpoch above.
function olderThan(epoch, hours)
  if epoch == nil then
    return false
  end
  return os.difftime(os.time(), epoch) >= hours * 3600
end

-- Latest container termination time in a container status list, nil if none.
function latestTerminationEpoch(statuses)
  if statuses == nil then
    return nil
  end
  local latest = nil
  for _, cs in ipairs(statuses) do
    if cs.state ~= nil and cs.state.terminated ~= nil then
      local finished = toEpoch(cs.state.terminated.finishedAt)
      if finished ~= nil and (latest == nil or finished > latest) then
        latest = finished
      end
    end
  end
  return latest
end

-- true when some other object owns this one. A Job created by a CronJob, or by
-- an operator like rook's CephCluster, carries an ownerReference (both set
-- controller: true) and already has a controller responsible for its lifecycle:
-- CronJobs prune via successfulJobsHistoryLimit, operators recreate on
-- reconcile. Reaping those adds churn without cleaning up a leak, so rules that
-- target leftovers skip them. Any ownerReference counts, not just
-- controller: true — a non-controller reference still means Kubernetes GC will
-- remove this object once the owner goes.
function hasOwner(obj)
  local refs = obj.metadata.ownerReferences
  return refs ~= nil and #refs > 0
end

-- When a pod became terminal. Prefers the last container termination, so a pod
-- that has existed for days but only just failed is still protected by the age
-- threshold. Evicted pods frequently report no container state at all, hence
-- the fallback to startTime and finally creationTimestamp. A pod without any
-- status at all cannot be dated from its containers, so it falls straight
-- through to creationTimestamp: both current callers already check obj.status,
-- but a future rule must not be able to crash the whole evaluation here.
function podTerminalEpoch(obj)
  if obj.status == nil then
    return toEpoch(obj.metadata.creationTimestamp)
  end
  local latest = latestTerminationEpoch(obj.status.containerStatuses)
  local initLatest = latestTerminationEpoch(obj.status.initContainerStatuses)
  if initLatest ~= nil and (latest == nil or initLatest > latest) then
    latest = initLatest
  end
  if latest == nil then
    latest = toEpoch(obj.status.startTime)
  end
  if latest == nil then
    latest = toEpoch(obj.metadata.creationTimestamp)
  end
  return latest
end
{{- end -}}
