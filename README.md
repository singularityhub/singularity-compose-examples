# Singularity Compose MongoDB

This is an example that uses [singularity-compose](https://www.github.com/singularityhub/singularity-compose)
to bring up a mongodb instance that can be used in an HPC environment
(without sudo) to export a large database. This is a first proof of concept
for using the software in this environment without sudo. Since
we cannot run a build with a recipe, this means that we manually need to
start the service when we shell into the container. A user with sudo
could define the command in a recipe with a startscript instead:

```bash
Bootstrap:docker
From:mongo

%startscript
mongod
```

And then use a context in the [singularity-compose.yml](singularity-compose.yml)
instead of an image:

```
version: "1.0"
instances:

  mongodb:
    build:
      context: ./mongodb
    volumes:
      - ./mongodb/data:/data
    post:
      command: ["/bin/bash", "./mongodb/run_post.sh"]
```

And of course we couldn't build with a recipe on HPC, so we will
need to start the service when we shell inside. This entire procedure can
also be done without `singularity-compose`, and you can read the [Singularity Only](#singularity-only)
section for how to do this.

## Singularity Compose

First, make sure you have it installed.

```bash
$ pip install singularity-compose --user
```

Clone the repository

```bash
$ git clone https://www.github.com/singularityhub/singularity-compose-mongodb
$ cd singularity-compose-mongodb
```

Build the containers (comes down to a pull, and a post command to download the
database export).

```bash
$ singularity-compose build
```

Once you've built, you can bring up the container as an instance.

```bash
$ singularity-compose up
```

Shell inside the instance

```bash
$ singularity-compose shell mongodb
```

Start the mongo daemon in the background

```bash
mongod &
```

cd into the "dump/test" folder that was exported (venmo.bson is here) and is
now bound to the container:

```bash
$ cd dump/test
```

And restore the data

```bash
mongorestore --collection venmo --db test venmo.bson
```

## Singularity Only

For the "Singularity Only" version, you can follow instruction in the [venmo_mongo.sh](venmo_mongo.sh)
script.
