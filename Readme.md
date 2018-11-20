# Status
This is still pretty alpha. For now I have a working Galera cluster, that works together with consul, and root rotation, som two user password rotations.

This is a development setup, and on the short sight this is not intended for production. In the long run this is going to be production ready code.

This is a test docker-compose written to facilitate the following:

1. Get an environment up and running where we have a
    * cluster of MariaDB
    * cluster of Consul storages and a Vault
    * cluster of a Hazelcast datagrid

This is done mostly by vanilla images from docker hub, except the MariaDB image, that I had to create myself (actually I have only added a minimal custom entry-point script to create a folder if the NODE_MODE environment variable is set to CHILD).

Theoretically I could have spared not setting up clusters for Hazelcast, MariaDB and Vault, but I want to see how this was done for all of these technologies, so I in time can use this docker-compose as a foundation to create k8s deployments, that can scale the clusters up.

I know that consul recommends having a 3-5 cluster setup, and this compose file only have two, but this is development, and my focus have been on creating the clusters, and not maintaining a perfectly production setup (therefore I dont have backup of databases either, and vault and hazelcast is running in development mode).

Feel free to clone this repo and use as a basis for further development.

# Values to fill out before running docker-compose up

Remember to change the local IP to your local IP for the Hazelcast cluster.

Hope you like it.

# How to build
You need:

1. docker
2. ```make```

Go to the root directory (where this readme file is located), and run ```make```, this will:

1. build the MariaDB image
2. run `up-all on the makefile from the Compose files directory

The "up-all" runs a series of make targets, with sleeps injected, to give time to certain nodes (database) to come up. When all is up, you shouldnt be able to run "make status". This will give you an error. See the Vault section of this file to see how to rotate some roles, to get a password so you can connect to the MariaDB cluster.

# Vault
When calling ```make add-rotation``` a final script is created, and copied to the vault image. After that two roles is created:

1. read-role
2. update-role

There is also created a root rotation on the root password, which completly renders the intial one time root password useless. Remember that the root token is snatched from the vault logs, and and injected in the final script. This script does not get deleted from the host PC, but is deleted from the docker container. This is meant to be this way because this is a dev setup, and we want to see the output of the built script. If you dont like have it laying around, delete it.

To rotate a password you can connect to the vault container:

```bash
docker exec `docker ps -q --filter "name=vault-server-0"` -it /bin/sh
```
After this you can copy the vault login command from the vault/scripts/bootstrap-dev.final.sh script

```bash
vault login <root-token>
```

and rotate the update-role or the read-role

```bash
vault read database/creds/read-role
```

or (for the update-role)

```bash
vault read database/creds/update-role
```

The password and username is returned and can then be used in the make status target from the Makefile in the Compose files directory. Replace the username and password, and call ```make status again```. This should then report back "Cluster size: 3". If it doesnt do that, there is something wrong with the setup.

# MariaDB image
If you google "docker mariadb galera" you get a ton of different ways of doing this, but I have settled with the following:

1. before the galera cluster is spun up, i create a consul cluster
2. every time a database-node is created, consul is consulted (:)) and if this is the first node spun up, it is going to be master for the rest

There is a lot of pitfalls here:

1. the creation of the cluster has to be controlled
2. consul can go down in the creation of the cluster

In the long run I am going to deploy this to a k8s statefulset that ensures me that all nodes is spun up one after the other, so I am sure that the galera nodes are not spun up rapidly. Before creating the galera cluster, k8s has to have the consul cluster ready. Both these choices is by design, with k8s in mind.

I still dont know what will happen if the galera cluster is rebooted. This is an investigation of its own and it is on the top of my todo list.

I still need to address:

1. backup
2. unsubscribing
3. what will happen if consul becomes unavailable

Feel welcome to contact me with thoughts on this. I am known as ap5 on #csharp on Freenode.

# WSL and docker
Remember to map the /mnt/[your_drive] to /[your_drive] so that the docker VM and WSL can work together when mounting volumes! This can be done by editing (if not edited before then just create the file) /etc/wsl.conf adding

```conf
[automount]
root = /
```

Remember to restart WSL. After restart do a ```ls -la /``` and you can now see that what was before mounted on /mnt/c is now mounted on /c. Check out https://blogs.msdn.microsoft.com/commandline/2018/02/07/automatically-configuring-wsl/ for more on this subject.

# Test
I am currently running some manual test on both Linux and WSL on Windows.