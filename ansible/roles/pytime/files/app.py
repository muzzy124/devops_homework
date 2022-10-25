import os
import json
import datetime
import socket
import redis

from flask import Flask
app = Flask(__name__)

@app.route("/")
def root():
  now = str(datetime.datetime.now())
  hostname = socket.gethostname()
  return("Datetime now is {0} from {1}".format(now, hostname))

@app.route("/redis/")
def redis_function():
  redis_server = os.getenv("REDIS_SERVER", "localhost")
  redis_password = "redis_password"

  r = redis.Redis(host=redis_server, password=redis_password, port=6379, db=0)
  kek_value = r.get("kek").decode("utf-8")

  return("Redis connecting to {0}, value of kek is {1}".format(redis_server, kek_value))

if __name__ == "__main__":
  app.run()