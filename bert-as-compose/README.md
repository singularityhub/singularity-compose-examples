# Bert as a Service, Compose

This is an example that uses [singularity-compose](https://www.github.com/singularityhub/singularity-compose)
to bring up instances to run [bert as a service](https://github.com/hanxiao/bert-as-service).

![bert.png](bert.png)

## Singularity Compose

First, make sure you have it installed.

```bash
$ pip install singularity-compose --user
```

Clone the repository

```bash
$ git clone https://www.github.com/singularityhub/singularity-compose-examples
$ cd singularity-compose-examples/bert-as-a-service
```

## Build Containers

If you are working on a machine without gpu, you don't need to edit the configuration.
However, if you want to test the gpu server, change the name of the recipe for "server"
from "Singularity" to "Singularity.gpu." The only difference is the base container used
for tensorflow, and removing the `--cpu` flag from starting the server.

When you are ready, build the containers:

```bash
$ singularity-compose build
```

Once you've built, you should see the container `server.sif` in the server folder,
and client.sif in the client folder. If you were to want to rebuild a container
at some future point, you can just ask to build one:

```bash
$ singularity-compose build client
```

### Download Model

Next, we need to download a [pre-trained bert model](https://github.com/hanxiao/bert-as-service#1-download-a-pre-trained-bert-model). For example, here I can download the first in the list, and extract and rename
to a folder called "model":

```bash
$ wget https://storage.googleapis.com/bert_models/2018_10_18/uncased_L-12_H-768_A-12.zip
$ unzip uncased_L-12_H-768_A-12.zip
$ mv uncased_L-12_H-768_A-12 model
```

If you look in the [singularity-compose.yml](singularity-compose.yml), the "model" folder will be bound to the server container at `/model`.


```yaml
    volumes:
      - ./model:/model
```

You are free to change the singularity-compose.yml to use a specific path for a model, if you
want to maintain the original folder name.

### Start Container Instances

Next, you can bring up the containers as instances.

```bash
$ singularity-compose up
```

Check to see it running!

```bash
$ singularity-compose ps
INSTANCES  NAME PID     IMAGE
1        client	24033	client.sif
2        server	23844	server.sif
```

You can check that the server started by looking at the logs:

```bash
$ singularity-compose logs server 
...
I:VENTILATOR:[__i:__i: 67]:freeze, optimize and export graph, could take a while...
I:GRAPHOPT:[gra:opt: 52]:model config: /model/bert_config.json
I:GRAPHOPT:[gra:opt: 55]:checkpoint: /model/bert_model.ckpt
I:GRAPHOPT:[gra:opt: 59]:build graph...
I:GRAPHOPT:[gra:opt:128]:load parameters from checkpoint...
I:GRAPHOPT:[gra:opt:132]:optimize...
I:GRAPHOPT:[gra:opt:140]:freeze...
I:GRAPHOPT:[gra:opt:145]:write graph to a tmp file: /tmp/tmpi6i_5wsv
I:VENTILATOR:[__i:__i: 75]:optimized graph is stored at: /tmp/tmpi6i_5wsv
I:VENTILATOR:[__i:_ru:129]:bind all sockets
I:VENTILATOR:[__i:_ru:133]:open 8 ventilator-worker sockets
I:VENTILATOR:[__i:_ru:136]:start the sink
I:SINK:[__i:_ru:306]:ready
I:VENTILATOR:[__i:_ge:222]:get devices
I:VENTILATOR:[__i:_ge:255]:device map: 
		worker  0 -> cpu
I:WORKER-0:[__i:_ru:530]:use device cpu, load graph from /tmp/tmpi6i_5wsv
I:WORKER-0:[__i:gen:558]:ready and listening!
I:VENTILATOR:[__i:_ru:164]:all set, ready to serve request!
```

Great! Now let's shell into the client and interact with our server.

## Shell Inside Client

```bash
$ singularity-compose shell client
```

Let's use ipython so it's a nicer interface to work in. 

```bash
$ ipython
```

And then in ipython, let's import the BertClient. Note that we have
to specify the server to be the name of the other instance

```bash
from bert_serving.client import BertClient
bc = BertClient('server')
```

If your client hangs on this command, it's because of a networking bug with
Singularity 3.2.x (I don't remember the exact version). If you install
from master, it will find the server quickly. If you aren't able to do this,
then you can actually install bert-server-client on the host, and interact from
there. Here is an example - I use anaconda3 so I installed dependencies
with conda first.

```bash
$ conda install numpy pyzmq ipython
$ pip install bert-serving-client
```

And then you can continue with the commands again, outside of the container.
But this time, you can leave out the name of the server (it defaults to localhost)


```bash
from bert_serving.client import BertClient
bc = BertClient()
```

Either way, once you've loaded the bert client, try it out to encode some
sentences!

```bash
> bc.encode(['First do it', 'then do it right', 'then do it better'])
array([[ 0.13186473,  0.32404107, -0.827044  , ..., -0.37119547,
        -0.39250168, -0.31721845],
       [ 0.24873517, -0.12334395, -0.38933852, ..., -0.44756225,
        -0.5591354 , -0.11345169],
       [ 0.2862736 , -0.1858017 , -0.30906805, ..., -0.2959366 ,
        -0.39310506,  0.07640224]], dtype=float32)
```

Woohoo!

So from here you likely will want to choose a pre-trained model of interest,
and then write your own scripts. I would personally start with the [tutorial](https://github.com/hanxiao/bert-as-service#book-tutorial) to figure out next steps.

## Cleaning Up

When you are finished, you can bring everything down:

```bash
$ singularity-compose down
Stopping (instance:server)
Stopping (instance:client)
```
