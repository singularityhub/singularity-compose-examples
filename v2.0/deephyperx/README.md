# DeepHyperX

An example of running [DeepHyperX](https://github.com/nshaud/DeepHyperX).
You of course need [singularity-compose](https://singularityhub.github.io/singularity-compose/#/) 
installed first. **Important** this is a minimal example for demo purposes only. If you use this for real,
you should ensure that you have cerificates with https, etc.

```bash
$ singularity-compose build
```

or just bring it up (and the build will happen):

```bash
$ singularity-compose --debug up -d
```

THe startscript will start code-server on `http://localhost:9999`. To shell
into the container and interact with the python environment inside, you can
do:

```bash
$ singularity-compose shell deephyperx
cd /workspace/deephyperx/
python main.py --model SVM --dataset IndianPines --training_sample 0.3
...
Accuracy : 52.641%
---
F1 scores :
	Undefined: nan
	Alfalfa: 0.000
	Corn-notill: 0.407
	Corn-mintill: 0.000
	Corn: 0.000
	Grass-pasture: 0.006
	Grass-trees: 0.708
	Grass-pasture-mowed: 0.000
	Hay-windrowed: 0.870
	Oats: 0.000
	Soybean-notill: 0.000
	Soybean-mintill: 0.584
	Soybean-clean: 0.000
	Wheat: 0.372
	Woods: 0.840
	Buildings-Grass-Trees-Drives: 0.050
	Stone-Steel-Towers: 0.908
---
Kappa: 0.425
```

See [here](https://github.com/nshaud/DeepHyperX) for more example use cases.
I'm not sure the utility of the interface (or if it works) and the best place to
ask about this is the repository [here](https://github.com/nshaud/DeepHyperX/issues).
Since that datasets are in the container, you should edit the [Singularity](Singularity)
recipe if you want to install more or change the install otherwise.
When you are done:

```bash
$ singularity-compose stop
Stopping (instance:alp)
```
