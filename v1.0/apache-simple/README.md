# Singularity Compose Apache

This is an example that uses [singularity-compose](https://www.github.com/singularityhub/singularity-compose)
to bring up an apache (httpd container) instance.

The entire procedure here can also be done without `singularity-compose`, 
and you can read the [Singularity Only](#singularity-only) section for how to do this.

## Singularity Compose

First, make sure you have it installed.

```bash
$ pip install singularity-compose --user
```

Clone the repository

```bash
$ git clone https://www.github.com/singularityhub/singularity-compose-examples
$ cd singularity-compose-examples/apache-simple
```

Build the containers:

```bash
$ singularity-compose build
```

Once you've built, you should see the container `httpd.sif` in the httpd folder.

```bash
$ ls httpd
httpd.sif Singularity
```

You can bring up the container as an instance. 

```bash
$ singularity-compose up
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 10.22.0.2. Set the 'ServerName' directive globally to suppress this message
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 10.22.0.2. Set the 'ServerName' directive globally to suppress this message
[Thu Jul 11 19:02:24.270781 2019] [mpm_event:notice] [pid 16:tid 139961046078656] AH00489: Apache/2.4.37 (Unix) configured -- resuming normal operations
[Thu Jul 11 19:02:24.272209 2019] [core:notice] [pid 16:tid 139961046078656] AH00094: Command line: 'httpd -D FOREGROUND'
```

Check to see it running!

```bash
$ singularity-compose ps
INSTANCES  NAME PID     IMAGE
1         httpd	20149	httpd.sif
```

And then open your browser to localhost to see "It works!"

And then bring everything down:

```bash
$ singularity-compose down
Stopping (instance:httpd)
```

## Singularity Only

## Apache with Singularity

Start with this recipe

```
Bootstrap: docker
From:httpd:2.4.37
%startscript
httpd-foreground
```

Build the container:

```bash
$ sudo singularity build apache.sif Singularity
```
Next, make a logs directory to bind to the host:

```bash
$ mkdir -p logs
```

And start the instance and bind the folder for logs.

```bash
sudo singularity instance start --bind /tmp/logs:/usr/local/apache2/logs --net --network-args "portmap=80:80/tcp" apache.sif apache
```

And clean up when you finish

```bash
$ sudo singularity instance stop apache
```
