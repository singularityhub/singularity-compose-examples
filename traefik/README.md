# Singularity Compose Traefik

This is an example that uses [singularity-compose](https://www.github.com/singularityhub/singularity-compose)
to bring up a [traefik instance](https://doc.traefik.io/traefik/getting-started/quick-start/).


## Singularity Compose

First, make sure you have it installed.

```bash
$ pip install singularity-compose --user
```

Clone the repository

```bash
$ git clone https://www.github.com/singularityhub/singularity-compose-examples
$ cd singularity-compose-examples/traefik
```

Build the containers:

```bash
$ singularity-compose build
```

Once you've built, you should see the container `reverse-proxy.sif` in the reverse-proxy folder.

```bash
$ ls reverse-proxy
reverse-proxy.sif Singularity
```

You can bring up the container as an instance. 

#TODO stopped here, need to figure out how to run traefik in container.

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
