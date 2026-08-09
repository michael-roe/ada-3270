import os
import sys
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
    "messages": history,
    "temperature": 0.6,
    "stream": True
  }

  response = requests.post(url, headers=headers, json=payload, stream=True)

  done = False
  role = ""
  content = ""
  reasoning_content = ""

  for line in response.iter_lines():
    print("#", end="")
    sys.stdout.flush()
    line = line.decode("utf-8")
    if line.startswith("data: "):
      data = line[6:]
      if data == "[DONE]":
        break
      chunk = json.loads(data)
      choices = chunk.get("choices",[]);
      if choices:
        delta = choices[0].get("delta",{});
        if "role" in delta:
          role = delta["role"]
        if "reasoning_content" in delta:
          reasoning_delta = delta["reasoning_content"]
          if not reasoning_delta is None:
            reasoning_content = reasoning_content + reasoning_delta
        if "content" in delta:
          content_delta = delta["content"]
          if not content_delta is None:
            content = content + content_delta

  print("Role:", role)
  print("Received:", content)

  history.append({"role": role, "content": content})

  f.write(json.dumps(content))
  f.write("\n")
  f.flush()
