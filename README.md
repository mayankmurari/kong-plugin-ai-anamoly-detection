# AI Anamoly detection - Kong Plugin

# Getting Started

This plugin integrates OpenAI’s GPT models to detect anomalies in API requests managed by Kong. It analyzes incoming requests for suspicious patterns, such as SQL injections or abnormal headers, and blocks any request that is deemed malicious.

Analyzes request metadata (headers, body, IP, etc.) for anomalies.<br />
Uses via the OpenAI API to flag potentially malicious requestst<br />
Blocks requests if anomalies are detected.<br />


| Parameter      | Type |Required|Description |
| ----------- | ----------- |----------- |----------------------- |
| openai_url      | String       |True | Defines the open ai token endpoint, provide the complete end point Ex : "[https://api.twitter.com/oauth/authorize](https://api.openai.com/v1/chat/completion)"
| openai_model   | String        |True | Defines the openai model
| openai_key   | String        | True | Defines the openai key
| max_tokens   | Number        |False | Max tokens
| anomaly_detection_action   | String        |False | Defines the action on anamoly detection. Either to allow request or deny it.
| connect_timeout   | number        |False | Connect timeout for Open AI Host
| send_timeout   | number        |False | Send timeout for Open AI Host
| read_timeout   | number        |False | Read timeout for Open AI Host

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


Contributers
---

| Name               | Email           
| -------------      |:-------------
| Mayank Murari      | mayank.murari@gmail.com 



 
