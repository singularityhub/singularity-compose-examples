# Singularity Compose MongoDB (pull)

This is an example that uses [singularity-compose](https://www.github.com/singularityhub/singularity-compose)
to bring up a mongodb instance that can be used in an HPC environment
(without sudo) to export a large database. For this example, we rely on an
environment without sudo where we must pull a container and start
mongod when we shell inside. If you are looking for a build (rootless with
`--fakeroot` or remote with `--remote`) then please see the [mongodb-build](mongodb-build)
example.

The entire procedure here can also be done without `singularity-compose`, 
and you can read the [Singularity Only](#singularity-only) section for how to do this.

## Customization

If you want to use the instance for your own MongoDB, you can simply
remove the post command (or update it to download and extract the
database you want to use!)

```
version: "1.0"
instances:

  mongodb:
    image: docker://mongo
    volumes:
      - ./mongodb/data:/data
```

This simple example shows how singularity-compose can serve as a good method
to reproduce an image + volumes + (any other start commands that you would like).
If there is a command missing, please 
[open an issue](https://www.github.com/singularityhub/singularity-compose/issues).


## Singularity Compose

First, make sure you have it installed.

```bash
$ pip install singularity-compose --user
```

Clone the repository

```bash
$ git clone https://www.github.com/singularityhub/singularity-compose-examples
$ cd singularity-compose-examples/mongodb-pull
```

Build the containers (comes down to a pull, and a post command to download the
database export).

```bash
$ singularity-compose build
```

Once you've built, you should see the container `mongodb.sif` in the mongodb folder.

```bash
$ ls mongodb/
data  mongodb.sif  run_post.sh
```

You  can bring up the container as an instance. 

```bash
$ singularity-compose up
Creating mongodb
```

Check to see it running!

```bash
$ singularity-compose ps
INSTANCES  NAME PID     IMAGE
1       mongodb	106128	mongodb.sif
```

At this point, it's going to also download the raw data (wget) and extract it. This can take some time, but
when it's done, you'll see a "dump" directory with the data within:

```bash
$ ls mongodb/
data  dump  mongodb.sif  run_post.sh  venmo.tar.xz
```

Shell inside the instance

```bash
$ singularity-compose shell mongodb
Singularity mongodb.sif:/scratch/users/vsochat/venmo/singularity-compose-mongodb> 
```

Start the mongo daemon in the background

```bash
mongod &
```

cd into the "dump/test" folder that was exported (venmo.bson is here) and is
now bound to the container:

```bash
$ cd mongodb/dump/test
```

And restore the data

```bash
mongorestore --collection venmo --db test venmo.bson
```

This restore takes a long time, as the database has ~7 million records.
At this point, you can query the database by starting a mongo shell:

```bash
$ mongo
```

Display the database we are using

```
> db
test
```

Get the collection

```
venmo = db.getCollection('venmo')
test.venmo
```

Confirm we have all the records

```
> venmo.count()
7076585
```

You can use "findOne" to see all the fields provided for each datum (personal information
removed):

```json
> venmo.findOne()
{
	"_id" : ObjectId("5bb7bdce1bed297da9fcb11f"),
	"mentions" : {
		"count" : 0,
		"data" : [ ]
	},
...
	"note" : "🍺",
	"app" : {
		"site_url" : null,
		"id" : 1,
		"description" : "Venmo for iPhone",
		"image_url" : "https://venmo.s3.amazonaws.com/oauth/no-image-100x100.png",
		"name" : "Venmo for iPhone"
	},
	"date_updated" : ISODate("2018-07-26T18:47:05Z"),
	"transfer" : null
}
> 
```

## Singularity Only

For the "Singularity Only" version, you can follow instruction in the [venmo_mongo.sh](venmo_mongo.sh)
script.
