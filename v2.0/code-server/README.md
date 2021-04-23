# Linuxserver Code Server

An example of running [VS code on a remote server](https://hub.docker.com/r/linuxserver/code-server).
**Important** this is a minimal example for demo purposes only. If you use this for real,
you should ensure that you have cerificates with https, etc. You can read the link above,
or shell into the container to see the `code-server --help` for more details.

```bash
$ singularity-compose build
```

or just bring it up (and the build will happen):

```bash
$ singularity-compose --debug up -d
```

THe startscript will start code-server on `http://0.0.0.0:8443`. You can find
your password at `~/.config/code-server/config.yaml`. If you start using root
(without fakeroot) then you need to look at `/root/.config/code-server/config.yaml`. 
When you are done:

```bash
$ singularity-compose stop
Stopping (instance:alp)
```
