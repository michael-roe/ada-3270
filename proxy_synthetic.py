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

for j in range (0, 5):
  line = f.readline().strip()
  opt = json.loads(line)
  print ("Option:", opt)
  f.write("\"OK\"\n")
  f.flush()

history = []

while True:
  line = f.readline().strip()
  query = json.loads(line)

  history.append({"role": "user", "content": query})

  payload = {"model": model,
    "messages": history
  }

  response = requests.post(url, headers=headers, json=payload)

  reply = response.json()

  print(reply)
  print()

  if "error" in reply:
    f.write(json.dumps(reply["error"]))
    f.write("\n")
    f.flush()
  else:
    role = reply["choices"][0]["message"]["role"]
    message = reply["choices"][0]["message"]["content"]

    print("Role:", role)
    print("Received:", message)

    history.append({"role": role, "content": message})

    print(json.dumps(message))
    f.write(json.dumps(message))
    f.write("\n")
    f.flush()
