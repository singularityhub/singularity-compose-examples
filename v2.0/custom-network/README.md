## Custom Network

This is a simple test with custom networking. The original repository is [here](https://github.com/scicco/singularity-compose-test)
and description for setup also [here](https://github.com/singularityhub/singularity-compose/issues/60#issuecomment-1224006385).
**Note** that this example was provided and assumes a sudo user (the scripts below will ask for sudo).

## Setup

For singularity-compose or manual, you need to set up networking.

```bash
$ sudo cp 50_static.conflist /usr/local/etc/singularity/network/50_static-redis.conflist
```

## Singularity Compose

```bash
$ which singularity-compose 
/home/vanessa/Desktop/Code/singularity-compose/env/bin/singularity-compose
```
And then I just used the full path.
```bash
$ sudo /home/vanessa/Desktop/Code/singularity-compose/env/bin/singularity-compose --debug up
```

You need sudo to list instances.

```bash
$ sudo /home/vanessa/Desktop/Code/singularity-compose/env/bin/singularity-compose ps
INSTANCES  NAME         PID     IP              IMAGE
1         redis1	3001770	10.22.0.2	redis.sif
```

Now you can do the [checks for that redis is working](#how-to-check-that-redis-is-working).

## Manual Usage

### How to build

to rebuild from scratch (and note this is run with sudo) run:

```bash
./rebuild.sh
```

### check running instance

```bash
$ sudo singularity instance list
```
```bash
INSTANCE NAME    PID        IP           IMAGE
redis            2830143    10.22.0.2    /home/vanessa/Desktop/Code/singularity-compose-examples/v2.0/custom-network/redis.sif
```

### How to check that redis is working

Connect to Redis ( insert password: `ThisIsNotAStrongPassword!` )

```bash
$ sudo singularity shell instance://redis

# Or from singularity-compose
$ sudo singularity shell instance://redis1

$ redis-cli --askpass
```

write a key

```
127.0.0.1:6379> set foo bar
OK

127.0.0.1:6379> keys *
1) "foo"

127.0.0.1:6379> exit
```

And clean up:

```bash
echo "[1/6] stopping existing instance"
sudo singularity instance stop redis
```
