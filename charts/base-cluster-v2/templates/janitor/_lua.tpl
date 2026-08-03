{{/*
Lua helpers shared by every janitor Cleaner rule. Included into each rule's
`evaluate` block, because k8s-cleaner evaluates every resourceSelector in its
own Lua state — there is no place for a chart-wide prelude.

The timestamp parsing mirrors the upstream k8s-cleaner time-based examples
(examples-unused-resources/time_based_delete): os.time on a table built from the
RFC3339 string, compared against os.time. The controller container runs in UTC,
so both sides share one base.
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
      return os.time({
        year = tonumber(y), month = tonumber(mon), day = tonumber(d),
        hour = tonumber(h), min = tonumber(mi), sec = tonumber(s)
      })
    end
  )
  return tonumber(converted)
end

-- true only when the epoch is known AND older than the threshold. Unknown
-- timestamps deliberately return false: never delete what cannot be dated.
-- hours = 0 disables the check (any known timestamp is then "old enough").
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
-- the fallback to startTime and finally creationTimestamp.
function podTerminalEpoch(obj)
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
