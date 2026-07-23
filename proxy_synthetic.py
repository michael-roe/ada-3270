import os
import socket
import json
import requests


api_key=os.environ.get("SYNTHETIC_API_KEY")

#
# URL of the server running the LLM
#

url = "https://api.synthetic.new/v1/chat/completions"

#
# Which LLM to use
#

model = "hf:Qwen/Qwen3.6-27B"

#
# Local port number of the process that connects to the terminal
#

port = 17010

headers = {
  "Authorization": f"Bearer {api_key}",
  "Content-Type": "application/json"}

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(("127.0.0.1", port))
f = s.makefile("rw", encoding="utf-8", newline="\r\n")

line = f.readline().strip()
opt = json.loads(line)
print ("Option:", opt)
f.write("\"OK\"\n")
f.flush()

while True:
  line = f.readline().strip()
  query = json.loads(line)

  payload = {"model": model,
    "messages":
    [
      {
      "role": "user",
      "content": query
      }
    ]
  }

  response = requests.post(url, headers=headers, json=payload)

  reply = response.json()

  message = reply["choices"][0]["message"]["content"]
  print("Received:", message)
  print(json.dumps(message))
  f.write(json.dumps(message))
  f.write("\n")
  f.flush()
