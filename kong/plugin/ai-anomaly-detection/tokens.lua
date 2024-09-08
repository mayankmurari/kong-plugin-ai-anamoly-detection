local http = require "resty.http"
-- local socket = require "socket"
local cjson_safe = require "cjson.safe"
local kong = kong


local function check_for_anomalies(conf, request_data)
    
    local headers = {
        ["Content-Type"] = "application/json",
        ["Authorization"] = "Bearer " .. conf.openai_key
    }

    local gpt_payload = {
        model = conf.openai_model,
        messages = {
            {role = "system", content = "You are an AI that detects anomalies in API requests. If any anomalies are found append keyword anomaly found in response along with the type of anamoly. Ignore user agent. Don't put strict check. Provide a severity_score as well."},
            {role = "user", content = "Analyze the following API request for anomalies: " .. cjson_safe.encode(request_data)}
        },
        max_tokens = conf.max_tokens
    }
    
    local client = http.new()
    client:set_timeouts(conf.connect_timeout, conf.send_timeout, conf.read_timeout)
    local res, err =
        client:request_uri(
        conf.openai_url,
        {
            method = "POST",
            body = cjson_safe.encode(gpt_payload),
            headers = headers,
            keepalive_timeout = conf.keepalive,
            ssl_verify = false
        }
    )

    if not res then
        kong.log.err("Failed to connect to ChatGPT: ", err)
        return false
    end
    if err then
        kong.log.err("Failed to connect, error - " .. err)
        return false
    elseif res and res.status ~= 200 then
        kong.log.err("Failed to connect, error - " .. res.status)
        return false
    end
    

    local response_data = cjson_safe.decode(res.body)
    
    -- local analysis_text = response_data.choices[1].message.content
    local analysis_text = response_data.choices[1].message.content:lower()
    local severity_score = tonumber(analysis_text:match("severity score: (%d+)")) or 0

    -- kong.log("severity_score: ", severity_score)

    -- Check if the response contains the string "anomaly found"
    local anomaly_status = analysis_text:match("anomaly found: (.*)")

    -- If "None" is found, no anomaly. Otherwise, return true for a detected anomaly
    if anomaly_status and anomaly_status == "none" then
        kong.log.err("anomaly_status: " .. anomaly_status)
        return false
    elseif anomaly_status and anomaly_status ~= "none" and (severity_score >= conf.severity_threshold) then
        kong.log.err("anomaly_status: " .. anomaly_status .. " severity_score: " .. severity_score)    
        return true
    end

    -- Assuming the AI returns a message indicating if an anomaly is found
    -- return analysis_text:lower():find("anomaly") ~= nil
end

return {
    check_for_anomalies = check_for_anomalies
}