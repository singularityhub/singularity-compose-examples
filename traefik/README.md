# Singularity Compose Traefik

This is an example that uses [singularity-compose](https://www.github.com/singularityhub/singularity-compose)
to bring up a [traefik instance](https://doc.traefik.io/traefik/getting-started/quick-start/).
This example is under development, and will be continued if someone shows interest.


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

# TODO stopped here, need to figure out how to run traefik in container.

```bash
$ singularity-compose up
```

Check to see it running!

```bash
$ singularity-compose ps
```

And then open your browser to localhost to see "It works!"

And then bring everything down:

```bash
$ singularity-compose down
Stopping (instance:httpd)
```
