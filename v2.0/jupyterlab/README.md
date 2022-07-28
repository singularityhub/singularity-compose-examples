# Jupyter

The example here shows how to specify a run command as a background process so
that a second container can run. While it's recommended to have this handled as part of your
start script, for some that isn't an option.

```bash
$ singularity-compose up -d
```
```bash
$ singularity-compose ps
INSTANCES  NAME         PID     IP              IMAGE
1       jupyter1	3815106	10.22.0.2	jupyter.sif
2        second1	3815911	10.22.0.3	second.sif
```
```bash
$ singularity-compose stop
```


Note that since the jupyter notebook is run in the background, it's output will flood the screen.
You'll need to press enter to return to your terminal. The stop command should kill both.
It requires Singularity Compose version 0.1.17 or later. 

## Manual Example

The following below is generated by Singularity compose - I've extracted it to
make a simple example.

### resolv.conf

```
# This is resolv.conf generated by singularity-compose. It is provided
# to provide Google nameservers. If you don't want to have it generated
# and bound by default, use the up --no-resolv argument.

nameserver 8.8.8.8
nameserver 8.8.4.4
```

### etc.hosts

```
10.22.0.3	second1
10.22.0.2	jupyter1
127.0.0.1	localhost

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```

Here is the jupyter container

```bash
$ singularity pull --name jupyter.sif docker://umids/jupyterlab
```

And start the container (runs fine)

```bash
$ sudo singularity instance start --bind $PWD/work:/usr/local/share/jupyter/lab/settings --bind $PWD/resolv.conf:/etc/resolv.conf --bind $PWD/etc.hosts:/etc/hosts --net --network-args "portmap=8888:8888/tcp" --network-args "IP=10.22.0.2" --hostname jupyter1 --writable-tmpfs jupyter.sif jupyter1 
```
```bash
INFO:    instance started successfully
```

But this user wants a runscript to run (that also can run in the backgroud)

```bash
$ sudo singularity run instance://jupyter1 
```

So we'd want the above to run, but as a background process!