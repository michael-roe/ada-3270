import os
import sys
import socket
import json
import requests
import time


api_key=os.environ.get("SYNTHETIC_API_KEY")
# api_key=os.environ.get("NOVITA_API_KEY")

#
# URL of the server running the LLM
#

url = "https://api.synthetic.new/v1/chat/completions"
# url = "https://api.novita.ai/openai/v1/chat/completions"

#
# Which LLM to use
#

model = "hf:Qwen/Qwen3.6-27B"
# model = "deepseek/deepseek-r1-0528"

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

log_name = time.strftime("%Y%m%d%H%M.log")
log_file = open(log_name, "w");

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

  log_file.write(json.dumps({"role": "user", "content": query}))
  log_file.write("\n")
  log_file.flush()

  history.append({"role": "user", "content": query})

  payload = {"model": model,
    "messages": history,
    "temperature": 0.6,
    "stream": True
  }
  # For Novita: "separate_reasoning": True

  response = requests.post(url, headers=headers, json=payload, stream=True)

  if response.status_code != requests.codes.ok:
    error_msg = response.json()
    print(error_msg["error"])
    f.write(json.dumps(error_msg["error"]))
    f.write("\n")
    f.flush()

  else:

    done = False
    role = ""
    content = ""
    reasoning_content = ""
  
    for line in response.iter_lines():
      # print("#", end="")
      # sys.stdout.flush()
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
              if "\n" in reasoning_delta:
                print("#", end="")
                sys.stdout.flush()
          if "content" in delta:
            content_delta = delta["content"]
            if not content_delta is None:
              content = content + content_delta
              if "\n" in content_delta:
                print("#", end="")
                sys.stdout.flush()
      elif line.startswith("event: "):
        data = line[7:]
        print("event: ", end="")
        print(data)
  
    print("Role:", role)
    print("Received:", content)
  
    history.append({"role": role, "content": content})
  
    log_file.write(json.dumps({"role": role, "content": content,
      "reasoning_content": reasoning_content}))
    log_file.write("\n")
    log_file.flush()
  
    f.write(json.dumps(content))
    f.write("\n")
    f.flush()
