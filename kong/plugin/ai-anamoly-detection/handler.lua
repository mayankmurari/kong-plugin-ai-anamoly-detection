local tokens = require "kong.plugins.ai-anamoly-detection.tokens"
-- local socket = require "socket"
local cjson_safe = require "cjson.safe"
-- local kong = kong
local kong_meta = require "kong.meta"
-- local timer_at = ngx.timer.at

local AIAnamolyDetection = {
    VERSION = kong_meta.version,
    PRIORITY = 811
}

function AIAnamolyDetection:access(conf)

    local request_data = {
        path = kong.request.get_path(),
        headers = kong.request.get_headers(),
        body = kong.request.get_raw_body(),
        method = kong.request.get_method(),
        ip = kong.client.get_ip(),
    }

    -- Analyze the request data with the ChatGPT API for anomaly detection
    local anomaly_detected = tokens.check_for_anomalies(conf, request_data)

    local error_response = {
        Forbidden = "Anomaly detected in the request"
    }

    -- Block the request if an anomaly is detected
    if anomaly_detected and conf.anomaly_detection_action == "deny" then
        kong.response.exit(403, cjson_safe.encode(error_response))
    end
end

return AIAnamolyDetection