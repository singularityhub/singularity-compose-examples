## Spec Version 1.0 Examples

You can read the version 1.0 spec [here](https://singularityhub.github.io/singularity-compose/#/spec/spec-1.0).
Basically, it provides simple arguments for volumes, ports, and building vs. pulling and image. It is supported
for the singularity-compose client less than version 0.1.0.

 - [apache-simple](apache-simple): A simple example running an apache webserver.
 - [jupyter-simple](jupyter-simple): A jupyter notebook run via a Singularity container.
 - [mongodb-pull](mongodb-pull) a basic mongodb example that runs mongodb as a pull, and requires the user to start the service.
 - [mongodb-build](mongodb-build) the same example with a smaller database, that builds using sudo, fakeroot, or remote (depending on how you set it up).
 - [bert-as-compose](bert-as-compose) using an NLP model developed by Google with Singularity.
 - [django-nginx-upload](django-nginx-upload): A nginx web server with django and postgres to upload files directly via nginx

## External Examples

The following examples are provided in other repositories, and linked here. If you
have an example to add to the list, please [share](https://www.github.com/singularityhub/singularity-compose-examples/issues)!

 - [django-nginx-upload](https://www.github.com/singularityhub/singularity-compose-example) deploys two containers (nginx, app) to run a Django application with the nginx upload module.
 - [singularity-compose-simple](https://www.github.com/singularityhub/singularity-compose-simple): A single container example with the same django-nginx-upload, also used in testing.
