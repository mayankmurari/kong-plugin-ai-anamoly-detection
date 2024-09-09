local tokens = require "kong.plugins.ai-anomaly-detection.tokens"
local cjson_safe = require "cjson.safe"
local kong_meta = require "kong.meta"

local AIAnomalyDetection = {
    VERSION = kong_meta.version,
    PRIORITY = 900
}

function AIAnomalyDetection:access(conf)

    local function include_parameters(parameter, included_parameters)
        for _, param in ipairs(included_parameters) do
            if param == parameter then
                return true
            end
        end
        return false
    end

    local request_data = {}

    if include_parameters("path", conf.included_parameters) then
        request_data["path"] = kong.request.get_path()
    end
    if include_parameters("headers", conf.included_parameters) then
        request_data["headers"] = kong.request.get_headers()
    end
    if include_parameters("body", conf.included_parameters) then
        request_data["body"] = kong.request.get_raw_body()
    end
    if include_parameters("method", conf.included_parameters) then
        request_data["method"] = kong.request.get_method()
    end
    if include_parameters("ip", conf.included_parameters) then
        request_data["ip"] = kong.client.get_ip()
    end

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

return AIAnomalyDetection