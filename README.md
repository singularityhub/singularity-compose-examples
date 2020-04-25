# Singularity Compose Examples

This is a repository of examples for 
[Singularity Compose](https://singularityhub.github.io/singularity-compose). For the "simple"
example that is used during testing, see [singularity-compose-simple](https://github.com/singularityhub/singularity-compose-simple). Otherwise, all examples are provided here.

## Examples

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
