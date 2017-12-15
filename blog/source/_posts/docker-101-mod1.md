---
title: Introduction to Docker Images and Containers
tag:
 - [docker]
 - [docker-cli]
 - [docker images]
 - [docker 101]
category:
  - [tutorials]
date: 2017-12-14 17:28:29
show: false
---

[Module 0](https://docs.docker.com/engine/installation/) | [Module 1](/docker-101-mod1) | [Module 2](/docker-101-mod2) | [Module 3](/docker-101-mod3)
:---: | :---: | :---: | :---:

# Module 1: Running Docker Containers

{% post_link slug "Introduction to Docker" %}


Once you have Docker installed locally, you can verify your installation by simply typing 

```
docker --version
```

to see an output similar to: 

```
Docker version 17.06.0-ce, build 02c1d87
```
  > If you get a permissions errors on your local docker machine, type `sudo docker --version` to complete the task. The current user must be in [sudoers or docker group](https://docs.docker.com/engine/installation/linux/linux-postinstall/) to execute docker commands. 

<!-- more --> 

## Docker Images 

All Docker containers are based off [Docker images](https://docs.docker.com/engine/userguide/storagedriver/imagesandcontainers/). Docker images are built up from a series of layers. Each layer represents an instruction or resulting block storage changes to the container's filesystem. Each layer except the very last one is read-only, so once an image is made, any changes to data in a running container are made on a separate R/W layer. Think of it as application layering where the first image layer is always a blank minimalistic starting block from [scratch](https://hub.docker.com/_/scratch/) and changes are done by installing dependencies or applications that you desire to package with your docker image. See the visual below to illustrate the concept of image layering: 

  {% asset_img docker-images.png Docker Image %}

You can store docker images in several places: 

  * [1. Docker Hub](https://hub.docker.com/explore/)
  * [2. Other Public Repositories](https://quay.io/tour/)
  * [3. Locally on your machine](http://blog.thoward37.me/articles/where-are-docker-images-stored/)
  * [4. Private Docker registries](https://docs.docker.com/registry/deploying/#storage-customization)
  * [5. In a tar archive](https://docs.docker.com/engine/reference/commandline/save/)

 In this tutorial we will mainly be concerning ourselves with **#1** where we are pulling images from Docker Hub.

---

## Exercise 1 : Pulling Docker Images

Before any container is run, a copy of the docker image is always stored locally on the host. In this exercise we will pull a docker image from docker hub onto the docker host. 

### Step 1 : Pull an Image from Docker Hub

To pull an image down locally onto a host, run the following command: 

```
docker pull mayankt/webserver:a
```

Here is a break down of the command as follows: 

Command |  | Details
--- | --- | ---
`docker pull` | | This docker command that tells docker engine to pull an image down from somewhere
`mayankt/webserver:a` | | This is the image name. By default, if a full FQDN is not specified, it is assumed you are pulling the image from docker hub. In this case, you will be pulling an image from my repository [mayankt](https://hub.docker.com/r/mayankt/webserver/) with an image titled `webserver` with the tag of `a`. [Tagging](https://www.techrepublic.com/article/how-to-use-docker-tags-to-add-version-control-to-images/) images can help with versioning of your docker images and many other CI/CD use cases as well. 

 Once you run the command you should see an output similar to this: 

```bash
Pulling from mayankt/webserver
3ac0c2aa6889: Pull complete 
ec2ec713dc4f: Pull complete 
ea0a5af9851c: Pull complete 
555bf6439b47: Pull complete 
71080d75d6eb: Pull complete 
c787ac6d0b0a: Pull complete 
1a9841bc3a47: Pull complete 
1a7ce5d6010a: Pull complete 
eec46f0642a8: Pull complete 
d2d3a856c0da: Pull complete 
f128b2a739b4: Pull complete 
1341f98ff817: Pull complete 
```

Which indicates that the image is being pulled from docker hub locally onto your docker host. 

### Step 2 : List Local Docker Images

Type the following command to see a list of all images stored locally on your host.

```bash
docker images
```

Your output should resemble : 

```bash
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
mayankt/webserver   a                   18f05d0cd921        2 months ago        27.9MB
```

This output shows a 27.9 MB large docker image stored locally that can be run into instances of docker containers. All the `f128b2a739b4: Pull complete` outputs from the `docker pull` command above are the layers being pulled from Docker Hub of which constitute the `mayankt/webserver:a` docker image.

### Review

A simple `docker pull < image-name > ` commands shows how you can pull a docker image from the cloud directly. It's not used until you run a container with it which we will do in the [next Exercise](../Exercise-2).

 {% asset_img docker-pull.gif Docker pull from Docker Hub %}

---

## Exercise 2 : Running a Docker Container

Lets convert a docker image into a running instance of a docker container to host a simple website.

### Step 1 : Run a Docker Container

We will issue [`docker run`](https://docs.docker.com/engine/reference/run/) commands to run containers. Type the following command to host a website on the docker host on port `10000`.  

```bash
docker run -dt --restart=always --name=cpx-blog -p 10000:80 mayankt/cpx-blog
```

Here is the breakdown of the command from above:

Command | | Details
--- | | ---
`docker run -dt` | | This will run the container detached in the background. Later we will see [how we can attach to this container's terminal](https://stackoverflow.com/questions/30172605/how-to-get-into-a-docker-container), but for now we will have the container running detached in the background as a daemon.
`--restart=always` | | This will restart the container automatically if it crashes or if and when docker/host restart.
`--name=cpx-blog` | | This gives the container a name for more intuitive reference in later docker commands. Without a name parameter, the container will be randomly assigned a name and can be referenced to via the random name or the hash id of the container.
`-p 10000:80` | | This will expose port `10000` on the host and map it to port `80` on the container for access to the hosted website.
`mayankt/cpx-blog` | | This identifies the `latest` tagged image by default because no explicit tag is specified. It will be pulled from dockerhub to use when running the container. **Note:** It is not necessary to pull a desired image before executing a `docker run` command. If the image does not exist locally, it will be automatically pulled from the designated registry (Docker Hub in our case).

Once you have entered the command, you will notice an output similar to below:

```bash
Unable to find image 'mayankt/cpx-blog:latest' locally
latest: Pulling from mayankt/cpx-blog
3ac0c2aa6889: Already exists
ec2ec713dc4f: Already exists
ea0a5af9851c: Already exists
555bf6439b47: Already exists
71080d75d6eb: Already exists
c787ac6d0b0a: Already exists
1a9841bc3a47: Already exists
336c032aec9b: Pull complete
bc3b4209c6c5: Pull complete
3a5d33d6e1e0: Pull complete
7e846adb4c7d: Pull complete
Digest: sha256:141100857249a391261edf7335ffea1ca20478a15d3ac08c821561e7a8998ef9
Status: Downloaded newer image for mayankt/cpx-blog:latest
222bcc5747008a5c05f79d3a717f9132c8aa66234939677d3ebbcc5d883b5b5c
```
   > Notice some of the layers already exist locally from our previous webserver-a pull because both images use mutual base images that can be recycled and save on local space. Only deltas or layers that make cpx-blog unique from webserver-a are pulled that are not stored locally. Also the output provided in the last line `222bcc5747008a5c05f79d3a717f9132c8aa66234939677d3ebbcc5d883b5b5c` is the long unique id of the running container that can be referenced in future docker commands alternative to `cpx-blog`.

### Step 2 : List all Running Containers

To see all of your running containers type the following command:

```bash
docker ps
```

That will yield an output similar to below.

```bash
CONTAINER ID        IMAGE               COMMAND                CREATED              STATUS              PORTS                            NAMES
222bcc574700        mayankt/cpx-blog    "/bin/sh -c 'nginx'"   About a minute ago   Up About a minute   443/tcp, 0.0.0.0:10000->80/tcp   cpx-blog
```

This shows that the container named cpx-blog is running based on the image mayankt/cpx-blog with an external 10000 port exposed on the local host for remote access. Navigate to [`htt://localhost:10000`](http://localhost:1000) to see the website.

To stop your running container, type the following command:

```bash
docker stop cpx-blog
```

Now to see all of your running and **non running** containers, type the following command:

````bash
docker ps -a
```

That will yield an output similar to below.

```bash
CONTAINER ID        IMAGE                 COMMAND                CREATED             STATUS                       PORTS               NAMES
f407d06318f0        mayankt/cpx-blog   "/bin/sh -c 'nginx'"   10 minutes ago      Exited (137) 3 seconds ago                       cpx-blog
```

### Step 3 : Enter Container's Shell

If you container is not running already, start the container with the following command:

```bash
docker start cpx-blog
```

Then type the following command to enter the terminal shell of the container:

```bash
docker exec -it cpx-blog /bin/sh
```

The breakdown of the command as follows:

Command | | Details
--- | | ---
`docker exec -it` | | This will execute a command on the container with an interactive terminal (`-it`). We could execute commands in the background with a `-dt` if we wanted to, but we wouldn't see the outcome and the command we're running in this example is invoking a shell. If we wanted to run a script and not interact with it, we could have used the `-dt` flag.  
`cpx-blog` | | This denotes to which running container to execute the command against. In our case, it's the cpx-blog container.
`/bin/sh` | | This is the command itself that we want to execute in the container. In this example we are invoking the shell for terminal access into our container. In other examples we could execute specific scripts or bash files as well (i.e. `/var/scripts/init-db.sh` or any other file locally stored within the container).

After executing the command, you should have entered into the shell prompt of the container itself. Lets manipulate some files inside the container and see them reflected onto the website.

Within the container shell, enter the following:

```
vi /var/wwww/index.html
```

  > `vi` invokes a CLI text editor. It is functionally the same thing as notepad or sublime text, but geared for CLI interfaces not GUI interfaces. `vi` utility helps edit files in the terminal.

Once you have opened the `index.html` file, scroll down and change the text between :

```
<h1 class="brand-title">NetScaler NITRO Blogs</h1>
```

...to anything you desire, such as :

```
<h1 class="brand-title">LEARN DOCKER!</h1>
```

  > Edit text by entering the `i` key and then navigating the cursor to delete text you want to remove then typing in text you want to replace it with. Once completed, hit the `esc` key then `shift` + `:` key. Type `wq` to write and quit. You can then hit `ctrl` + `l` to clear the screen if you desire.

Once back into the container's CLI, simply type `exit` to logout and return back to the host's terminal.

Once the `index.html` is updated, refresh your browser or navigate back to [`http://localhost:10000`](http://localhost:10000) to observer changes to your site.

### Review

This concludes how to run a container with `docker run` command, how to attach to a container's terminal via the `docker exec -it` command, and how to manipulate data within a running container.

 {% asset_img docker-run.gif Running Docker Container %}