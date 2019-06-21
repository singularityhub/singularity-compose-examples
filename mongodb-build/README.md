# Singularity Compose MongoDB (build)

This is an example that uses [singularity-compose](https://www.github.com/singularityhub/singularity-compose)
to bring up a mongodb instance that requires a container build. This will require
sudo, however you can get around this by customizing the 
[singularity-compose.yml](singularity-compose.yml) to add the `--fakeroot` flag:

```
version: "1.0"
instances:

  mongodb:
    build:
      context: ./mongodb
      options:
        - fakeroot
    volumes:
      - ./mongodb/data:/data
    post:
      command: ["/bin/bash", "./mongodb/run_post.sh"]
```

or the remote flag:

```
version: "1.0"
instances:

  mongodb:
    build:
      context: ./mongodb
      options:
        - remote
    volumes:
      - ./mongodb/data:/data
    post:
      command: ["/bin/bash", "./mongodb/run_post.sh"]
```

## Singularity Compose

First, make sure you have it installed.

```bash
$ pip install singularity-compose --user
```

Clone the repository

```bash
$ git clone https://www.github.com/singularityhub/singularity-compose-examples
$ cd singularity-compose-examples/mongodb-build
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

At this point, it's going to also download the raw data (wget), a [restaurants.json](https://raw.githubusercontent.com/ozlerhakan/mongodb-json-files/master/datasets/restaurant.json) file. If you are interested in other datasets to import, 
[there is a nice set here](https://github.com/ozlerhakan/mongodb-json-files).

Shell inside the instance, mongod will already be started.

```bash
$ singularity-compose shell mongodb
Singularity mongodb.sif:~/singularity-compose-examples/mongodb-build> pidof mongod
16
```

cd into the "mongodb" folder so that we can import the database (and here you can
choose to import a different database, if you like)

```bash
$ cd mongodb/
```

And import the data

```bash
mongoimport --collection restaurant --db test --file restaurant.json
```

Note: if you have a bson file, you'll need to use `mongorestore`:

```bash
mongorestore --collection restaurant --db test restaurant.bson
```

And you can also imagine having this step happen in the [post_run.sh](mongodb/post_run.sh)
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
col = db.getCollection('restaurant')
test.restaurant
```

Confirm we have all the records

```
> col.count()
2548
```

You can use "findOne" to see all the fields provided for each datum:

```json
> col.findOne()
{
	"_id" : ObjectId("55f14312c7447c3da7051b29"),
	"URL" : "http://www.just-eat.co.uk/restaurants-atthairestaurant/menu",
	"address" : "30 Greyhound Road Hammersmith",
	"address line 2" : "London",
	"name" : "@ Thai Restaurant",
	"outcode" : "W6",
	"postcode" : "8NX",
	"rating" : 4.5,
	"type_of_food" : "Thai"
}
```

And finally, query for something specific of interest. Here are all the 5 star
restaurants:

```json
> col.find({"rating": 5.0})
{ "_id" : ObjectId("55f14312c7447c3da7051b26"), "URL" : "http://www.just-eat.co.uk/restaurants-cn-chinese-cardiff/menu", "address" : "228 City Road", "address line 2" : "Cardiff", "name" : ".CN Chinese", "outcode" : "CF24", "postcode" : "3JH", "rating" : 5, "type_of_food" : "Chinese" }
{ "_id" : ObjectId("55f14312c7447c3da7051b31"), "URL" : "http://www.just-eat.co.uk/restaurants-100-degrees-chinese-restaurant-pontypridd/menu", "address" : "67 Park Street", "address line 2" : "Treforest", "name" : "100 Degrees Chinese Restaurant", "outcode" : "CF37", "postcode" : "1SN", "rating" : 5, "type_of_food" : "Chinese" }
{ "_id" : ObjectId("55f14312c7447c3da7051b32"), "URL" : "http://www.just-eat.co.uk/restaurants-100menu-wn1/menu", "address" : "50 Wallgate", "address line 2" : "Wigan", "name" : "100 Menu", "outcode" : "WN1", "postcode" : "1JU", "rating" : 5, "type_of_food" : "Chinese" }
...
```

or ratings 4.5 and up:

```bash
> col.find({"rating": {"$gt": 4.5}})
```

Find Restaurants with "Pizza" in the name

```bash
$ col.find({"name": {"$regex": "Pizza"}})
```

And beyond! Read more about querying [here](https://docs.mongodb.com/manual/reference/operator/query/).
