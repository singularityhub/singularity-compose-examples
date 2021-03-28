# Start Args

This recipe shows an example with start args. you can build the container first:

```bash
$ singularity-compose build
```

or just bring it up (and the build will happen):

```bash
$ singularity-compose --debug up -d
```

Note that we are binding the present working directory to /data, and then
touching a file at /data/file1.txt to see it. If you try to touch a file
and don't bind a directory (and don't have writable in the container) it's
not goin to work. You can shell into the container:

```bash
$ singularity-compose shell alp
```

Then exit, and bring instances down (stop was added in 0.1.0)

```bash
$ singularity-compose stop
Stopping (instance:alp)
```
