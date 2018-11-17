# Status
This is still pretty alpha. I have not yet tested everything. I am still in the process of getting the galera cluster up with consul. This works with one galera node, and I am in the process of testing it with more nodes. After this is tested, I will move on to add root password rotation with vault. Hereafter I will experiment with hazelcast.

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

* _#host_ip_ - set this to the local IP address of the host machine when configuring Hazelcast

Hope you like it.

# How to build
You need:

1. docker
2. ```make```

Go to the root directory (where this readme file is located), and run ```make```, this will:

1. build the MariaDB image
2. run ```docker-compose```

When running docker-compose I have set some ```sleep``` in between making the first node, and the all other nodes for the galera cluster. This has to be done because the primary node has to be up and running, AND accepting nodes, before an initial sync to the children can be done. If this is not done, there will be some funky mistakes.

# MariaDB image
If you google "docker mariadb galera" you get a ton of different ways of doing this, but I have settled with the following:

1. before the galera cluster is spun up, i create a consul cluster
2. every time a database-node is created, consul is consulted (:)) and if there a number is returned, if this is the first node spun up, it is going to be master for the rest

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