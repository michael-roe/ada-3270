#
# This is an example of how to use the streaming interface
# to LLMs.
#

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

headers = {
  "Authorization": f"Bearer {api_key}",
  "Content-Type": "application/json"}

history = []

query = "What is the capital of France?"

history.append({"role": "user", "content": query})

payload = {"model": model,
  "messages": history,
  "temperature": 0.6,
  "stream": True
}

response = requests.post(url, headers=headers, json=payload, stream=True)

done = False
role = ""
content=""
reasoning_content=""

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

print()
print("role = ", end="")
print(role)
print()
print("reasoning_content")
print(reasoning_content)
print()
print("content")
print(content)

