# Ping

This is the simpest example for Singularity Compose to generate two containers
with an alpine base, and then shell into one to ping the other.
You'd first want to build the containers:

```bash
$ singularity-compose build
```

Note that since this example uses fakeroot for networking, you likely would need
to update your configuration for your user as follows:

```bash
$ sudo singularity config fakeroot --add $USER
```

The above command would add _your_ username. You'll also need to update the fakeroot
network configuration at `/usr/local/etc/singularity/network/40_fakeroot.conflist`
(or replace with the prefix where you installed Singularity):

```json
{
    "cniVersion": "0.4.0",
    "name": "fakeroot",
    "plugins": [
        {
            "type": "bridge",
            "bridge": "sbr0",
            "isGateway": true,
            "ipMasq": true,
            "ipam": {
                "type": "host-local",
                "subnet": "10.22.0.0/16",
                "routes": [
                    { "dst": "0.0.0.0/0" }
                ]
            }
        },
        {
            "type": "firewall"
        },
        {
            "type": "portmap",
            "capabilities": {"portMappings": true},
            "snat": true
        }
    ]
}
``` 

See [here](https://sylabs.io/guides/3.7/user-guide/cli/singularity_config_fakeroot.html) for
more details. Otherwise, you can remove the "start" sections and the client
will ask you for sudo. Once this is done, bring them up (debug is used to show
commands):

```bash
$ singularity-compose --debug up -d
Creating alp1
DEBUG singularity instance start --bind /home/vanessa/Desktop/Code/singularity-compose-examples/v2.0/ping/resolv.conf:/etc/resolv.conf --bind /home/vanessa/Desktop/Code/singularity-compose-examples/v2.0/ping/etc.hosts:/etc/hosts --fakeroot --net --network-args "portmap=1025:1025/tcp" --network-args "IP=10.22.0.2" --hostname alp1 --writable-tmpfs /home/vanessa/Desktop/Code/singularity-compose-examples/v2.0/ping/alp1/alp1.sif alp1 
WARNING: Disabling --writable-tmpfs as it can't be used in conjunction with underlay

DEBUG singularity exec --env-file=myvars.env instance://alp1 printenv SUPERHERO
PANCAKEMAN

Creating alp2
DEBUG singularity instance start --bind /home/vanessa/Desktop/Code/singularity-compose-examples/v2.0/ping/resolv.conf:/etc/resolv.conf --bind /home/vanessa/Desktop/Code/singularity-compose-examples/v2.0/ping/etc.hosts:/etc/hosts --fakeroot --net --network-args "portmap=1026:1026/tcp" --network-args "IP=10.22.0.3" --hostname alp2 --writable-tmpfs /home/vanessa/Desktop/Code/singularity-compose-examples/v2.0/ping/alp2/alp2.sif alp2 
WARNING: Disabling --writable-tmpfs as it can't be used in conjunction with underlay

DEBUG singularity run  instance://alp2 
This shows the alp2 example being run after creation
```

In the above, we see that the exec works because it's printing the environment variable we provided.
The second instance (alp2) has a runscript provided, so the empty run section is a signal to use it.
We can also add args to run and options. We can now test the instances. They should be able to interact with one another.

```bash
$ singularity exec instance://alp2 ping -c 2 `singularity instance list | grep alp1 | grep -o '10.* '`
PING 10.22.0.2 (10.22.0.2): 56 data bytes
64 bytes from 10.22.0.2: seq=0 ttl=64 time=0.064 ms
64 bytes from 10.22.0.2: seq=1 ttl=64 time=0.127 ms

--- 10.22.0.2 ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max = 0.064/0.095/0.127 ms
```

The containers should also be able to see one another, this is why we generated a hosts
and resolv.conf file in the present working directory. Let's try that:

```bash
$ singularity-compose shell alp1
Singularity> ping alp2
PING alp2 (10.22.0.3): 56 data bytes
64 bytes from 10.22.0.3: seq=0 ttl=64 time=0.155 ms
64 bytes from 10.22.0.3: seq=1 ttl=64 time=0.143 ms
64 bytes from 10.22.0.3: seq=2 ttl=64 time=0.139 ms
^C
--- alp2 ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max = 0.139/0.145/0.155 ms
Singularity> cat /etc/hosts
10.22.0.3	alp2
10.22.0.2	alp1
127.0.0.1	localhost

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```

Then exit, and bring instances down (stop was added in 0.1.0)

```bash
$ singularity-compose stop
Stopping (instance:alp2)
Stopping (instance:alp1)
```
