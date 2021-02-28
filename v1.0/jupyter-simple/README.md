# Jupyter Notebook

This is an example that uses [singularity-compose](https://www.github.com/singularityhub/singularity-compose) 
to bring up a jupyter notebook instance.
We use `continuumio/miniconda3` as a base image. We bind [jupyter/notebooks](jupyter/notebooks)
to `/opt/notebooks` for our notebook directory. You can change this path
in the [singularity-compose.yml](singularity-compose.yml) file if needed.

## Singularity Compose

First, make sure you have it installed.

```bash
$ pip install singularity-compose --user
```

Clone the repository with this example

```bash
$ git clone https://www.github.com/singularityhub/singularity-compose-examples
$ cd singularity-compose-examples/jupyter-simple
```

### Build

Build the containers. You will need sudo to build from a recipe.

```bash
$ singularity-compose build
```

Once you've built, you should see the container `jupyter.sif` in it's respective folder:

```bash
$ ls jupyter/
jupyter.sif  notebooks  Singularity
```

### Up

You can bring up the container as an instances. Since we expose port 8888, this requires
sudo (unless you have fakeroot that is working correctly).

```bash
$ singularity-compose up
Creating jupyter
```

Check to see them running:

```bash
$ singularity-compose ps
```

You are going to need to use `singularity-compose logs` to get your output and error streams:

```
...
[I 16:32:20.139 NotebookApp] Writing notebook server cookie secret to /root/.local/share/jupyter/runtime/notebook_cookie_secret
[W 16:32:20.403 NotebookApp] WARNING: The notebook server is listening on all IP addresses and not using encryption. This is not recommended.
[I 16:32:20.436 NotebookApp] JupyterLab extension loaded from /opt/conda/lib/python3.7/site-packages/jupyterlab
[I 16:32:20.436 NotebookApp] JupyterLab application directory is /opt/conda/share/jupyter/lab
[I 16:32:20.438 NotebookApp] Serving notebooks from local directory: /opt/notebooks
[I 16:32:20.438 NotebookApp] The Jupyter Notebook is running at:
[I 16:32:20.438 NotebookApp] http://vanessa-ThinkPad-T490s:8888/?token=2df03ba6a710d262ff5236459f891d7be2d8674aa587626f
[I 16:32:20.438 NotebookApp]  or http://127.0.0.1:8888/?token=2df03ba6a710d262ff5236459f891d7be2d8674aa587626f
[I 16:32:20.438 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[C 16:32:20.441 NotebookApp] 
    
    To access the notebook, open this file in a browser:
        file:///root/.local/share/jupyter/runtime/nbserver-16-open.html
    Or copy and paste one of these URLs:
        http://vanessa-ThinkPad-T490s:8888/?token=2df03ba6a710d262ff5236459f891d7be2d8674aa587626f
     or http://127.0.0.1:8888/?token=2df03ba6a710d262ff5236459f891d7be2d8674aa587626f
```

And then of course open your browser to the url (the last in the list) given in the logs to see your notebook.

![img/notebook.png](img/notebook.png)

We don't see files because the notebook directory is empty! 
Remember that your files are being saved on your local machine under [jupyter/notebooks](jupyter/notebooks)
and you can customize this path to save elsewhere.

### Shell

If you need to look inside the container or debug, you can use shell:

```bash
$ singularity-compose shell jupyter
> cat /etc/hosts
10.22.0.2	jupyter
127.0.0.1	localhost

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```

## Down
And of course when you finish, don't forget to bring the instances down.

```bash
$ singularity-compose down
Stopping (instance:jupyter)
```
