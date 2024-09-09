local typedefs = require "kong.db.schema.typedefs"

return {
  name = "ai-anomaly-detection",
  fields = {
    {protocols = typedefs.protocols},
    {
      config = {
        type = "record",
        fields = {
          {
            openai_url = {
              type = "string",
              required = true
            }
          },
          {
            openai_model = {
              type = "string",
              required = false,
              default = "gpt-3.5-turbo"
            }
          },
          {
            openai_key= {
              type = "string",
              required = true
            }
          },
          {
            max_tokens= {
              type = "number",
              required = false,
              default = 100
            }
          },
          { anomaly_detection_action = {
            type = "string",
            default = "allow",
            one_of = { "allow", "deny" },
            required = false
            }
          },
          { severity_threshold = {
            type = "number",
            required = false,
            default = 10
            }
          },
          { included_parameters = { 
            type = "array", 
              elements = { 
                type = "string", 
                  one_of = { "path", "headers", "body", "method", "ip" } 
                }, 
              required = true
            } 
          },
          {
            connect_timeout = {
              type = "number",
              default = 3000
            }
          },
          {
            send_timeout = {
              type = "number",
              default = 10000
            }
          },
          {
            read_timeout = {
              type = "number",
              default = 30000
            }
          },
          {
            keepalive = {
              type = "number",
              default = 60000
            }
          },
          {
            ssl_verify = {
              type = "boolean",
              default = false
            }
          },
        },
      },
    },
  }
}