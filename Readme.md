This is a test docker-compose written to facilitate the following:

1. Get an environment up and running where we have a
    * cluster of MariaDB
    * cluster of Consul storages and a Vault
    * cluster of Hazelcast datagrids

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

When running docker-compose I have set some ```sleep``` in between making the server, and the child nodes for the MariaDB. This has to be done because the primary node has to be up and running, AND accepting nodes, before an initial sync to the children can be done. If this is not done, there can happen some funky mistakes :)

# MariaDB image
Because the MariaDB default image does not support clustering out of the box, so I have added a custom entry point that checks if the ```NODE_MODE``` environment variable is set. If it is set, and the /var/lib/mysql/mysql folder is not empty (or does not exists), it creates the mysql folder in the /var/lib/mysql. This has to happen or else the server tries to recreate the database, and this will fail because the data has been copied. For a vanilla setup the error will be something on the line "cant grant all on root user@%". See thw whole script named _mariadb-entrypoint_ in the "MariaDB build/Scripts/" directory.

# WSL and docker
Remember to map the /mnt/[your_drive] to /[your_drive] so that the docker VM and WSL can work together when mounting volumes! This can be done by editing (if not edited before then just create the file) /etc/wsl.conf adding

```conf
[automount]
root = /
```

Remember to restart WSL. After restart do a ```ls -la /``` and you can now see that what was before mounted on /mnt/c is now mounted on /c. Check out https://blogs.msdn.microsoft.com/commandline/2018/02/07/automatically-configuring-wsl/ for more on this subject.