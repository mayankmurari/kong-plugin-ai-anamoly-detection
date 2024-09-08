# AI Anamoly Detection - Kong Plugin

# Getting Started

This plugin integrates OpenAI’s GPT models to detect anomalies in API requests managed by Kong. It analyzes incoming requests for suspicious patterns, such as SQL injections or abnormal headers, and blocks any request that is deemed malicious.

* Analyzes request metadata (headers, body, IP, etc.) for anomalies.
* Uses via the OpenAI API to flag potentially malicious requestst
* Blocks requests if anomalies are detected.
* Sets Severity Score and sets threshold for throtteling request. 


| Parameter      | Type |Required|Description |
| ----------- | ----------- |----------- |----------------------- |
| openai_url      | String       |True | Set open ai token endpoint, provide the complete end point Ex : "[https://api.twitter.com/oauth/authorize](https://api.openai.com/v1/chat/completion)"
| openai_model   | String        |True | Set the openai model
| openai_key   | String        | True | Set the openai key
| max_tokens   | Number        |False | Set Max tokens
| anomaly_detection_action   | String        |False | Defines the action on anamoly detection. Either to allow request or deny it.
| severity_threshold   | String        |False | Threshold for classifying requests as anomalies.. Either to allow request or deny it.
| connect_timeout   | number        |False | Connect timeout for Open AI Host
| send_timeout   | number        |False | Send timeout for Open AI Host
| read_timeout   | number        |False | Read timeout for Open AI Host
| keepalive   | number        |False | keepalive timeout for Open AI Host
| ssl_verify   | boolean        |False | Enforce SSL Verification

Steps to use this plugin
---

Create a service

```
curl -i -X POST \
 --url http://localhost:8001/services/ \
 --data 'name=http-bin' \
 --data 'url=https://httpbin.org'
 ```
 
 Create a Route
 
 ```
 curl -i -X POST \
 --url http://localhost:8001/services/http-bin/routes \
 --data 'hosts[]=example.com' 
 ```

---
 **1) Add plugin to service - Log the anamoly and allow the request.**
 
 ```
 curl -X POST http://localhost:8001/services/http-bin/plugins \
--data "name=ai-anamoly-detection" \
--data "config.openai_url={{openai_url}}" \
--data "config.anomaly_detection_action=allow " \
--data "config.openai_key={{openai_key}}"  
```

In this case plugin will analyse the request for any anamolies using using open API. Any anamolies detected will be logged.

Test API

```
curl -v -H "Host: example.com" 'http://localhost:8000/anything' \
--header 'Content-Type: application/json' \
--data '{
  "Hello": "World"
}'
```
```
curl -v -H "Host: example.com" 'http://localhost:8000/anything' \
--header 'Content-Type: application/json' \
--data '{
  "command": "ls; rm -rf /"
}'
```
---
 **2) Add plugin to service - Log the anamoly and deny the request.**
  ```
 curl -X POST http://localhost:8001/services/http-bin/plugins \
--data "name=ai-anamoly-detection" \
--data "config.openai_url={{openai_url}}" \
--data "config.anomaly_detection_action=deny " \
--data "config.openai_key={{openai_key}}"  
```

In this case plugin will analyse the request for any anamolies using using open API.If any anamolies are detected will be traffic will be throtelled based on sevirity threshold.

Test API

```
curl -v -H "Host: example.com" 'http://localhost:8000/anything' \
--header 'Content-Type: application/json' \
--data '{
  "Hello": "World"
}'
```
```
curl -v -H "Host: example.com" 'http://localhost:8000/anything' \
--header 'Content-Type: application/json' \
--data '{
  "command": "ls; rm -rf /"
}'
```
---


Contributers
---

| Name               | Email           
| -------------      |:-------------
| Mayank Murari      | mayank.murari@gmail.com 



 
