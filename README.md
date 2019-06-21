# Singularity Compose Examples

This is a repository of examples for 
[Singularity Compose](https://singularityhub.github.io/singularity-compose). For the "simple"
example that is used during testing, see [singularity-compose-simple](https://github.com/singularityhub/singularity-compose-simple). Otherwise, all examples are provided here.

## Examples

 - [mongodb-pull](mongodb-pull) a basic mongodb example that runs mongodb as a pull, and requires the user to start the service.
 - [mongodb-build](mongodb-build) the same example with a smaller database, that builds using sudo, fakeroot, or remote (depending on how you set it up).

## External Examples

The following examples are provided in other repositories, and linked here. If you
have an example to add to the list, please [share](https://www.github.com/singularityhub/singularity-compose-examples/issues)!

 - [django-nginx-upload](https://www.github.com/singularityhub/singularity-compose-example) deploys two containers (nginx, app) to run a Django application with the nginx upload module.
 - [singularity-compose-simple](https://www.github.com/singularityhub/singularity-compose-simple): A single container example with the same django-nginx-upload, also used in testing.
