## About

* Elixir/Phoenix's base docker image, consists of following
   - elixir 1.8.1
   - mix archive phx.new 1.4.1
   - node 10
   - erlang 21

## Commands

```
$ docker login --username=efgriver
Password:
Login Succeeded
$ cat ~/.docker/config.json # check docker.io/v1 exists in auths array.
$ docker build -t efgriver/elic-docker:latest .
$ docker push efgriver/elic-docker:latest
The push refers to repository [docker.io/efgriver/elic-docker]
221a2d7fd89e: Pushed
d062b94b004f: Pushed
d019f5e23ea1: Pushed
d21106da9b76: Pushed
589418962ab0: Pushed
72441408acfb: Pushed
0f3df68da1f5: Pushed
941052909d76: Pushed
f2a39358f637: Pushed
5af7b1158622: Pushed
33d065859508: Pushed
13d5529fd232: Pushed
latest: digest: sha256:8eec9cd9d0b624330f2445fc0d14ef0a218ae1bbca445968e9876b88f2c3df9a size: 2844
```
