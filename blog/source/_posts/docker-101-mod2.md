---
title: Introduction to Docker Files
tag:
 - [docker]
 - [docker-cli]
 - [docker images]
 - [docker 101]
 - [dockerfile]
 - [storage]
 - [volume mount]
category:
  - [tutorials]
date: 2017-12-14 17:28:29
show: false
---

[Module 0](https://docs.docker.com/engine/installation/) | [Module 1](/docker-101-mod1) | [Module 2](/docker-101-mod2) | [Module 3](/docker-101-mod3)
:---: | :---: | :---: | :---:

# Module 2: Create an Image via Dockerfiles

Given that all Docker containers are based off specific [Docker images](https://docs.docker.com/engine/userguide/storagedriver/imagesandcontainers/), in this module we will explore one of many ways to create Docker Images that define your custom docker containers. The following list a few ways to create customer images docker images:

1. [Save a running container into an image](https://docs.docker.com/engine/reference/commandline/save/)

    * In this method, users initially run a docker container based on a desired base image. Then after changes are made by `docker exec -it` or other means on the running container, the live container is ultimately saved into a `.tar` archive in its desired state that can be later [loaded](https://docs.docker.com/engine/reference/commandline/load/) to run multiple new instances of the custom image.

<!-- more --> 
2. Defining a [Dockerfile](https://www.digitalocean.com/community/tutorials/docker-explained-using-dockerfiles-to-automate-building-of-images)

    * This method is the most robust and more commonly use method to define and create docker images. A Dockerfile is essentially a recipe of commands to execute on a defined base image that constitute the desired state of a custom docker image. Consider the traditional workflow to configure a webserver which requires executing of scripts, updating local packages, pulling of code from various repositories, installing dependencies, etc. before the webserver is in its desired state. A Dockerfile can define those steps towards a desired state thus allowing changes to be made independently on external packages, code repositories, etc. and the Dockerfile will simply execute those commands and operations when you desire to build your custom container image.

## Dockerfiles

The advantage of a Dockerfile over just storing the binary image (or a snapshot/template in other virtualization systems) is that the automatic builds will ensure you have the latest version of code, packages, and external resources available in your docker container. This is a good thing from a security perspective, as you want to ensure you’re not installing any vulnerable software. This is also a good thing from an operational perspective because it allows you to rapidly build out isolated environments based on defined recipe that can pull from external resources like git to compile and build microservices.

Below is an example of a simple <a href="/_code/docker-101/Dockerfile" download="Dockerfile">Dockerfile</a>   


```
FROM fnichol/uhttpd
MAINTAINER Mayank Tahilramani and Brian Tannous
COPY ./cpx-blog /www
EXPOSE 80
ENTRYPOINT /usr/sbin/run_uhttpd -f -p 80 -h /www
CMD [""]
```
Breakdown of details below:

```
FROM fnichol/uhttpd
```

This denotes the base image to use. In this case, it's an image from Docker Hub of user [`fnichol`](https://github.com/fnichol/docker-uhttpd) who has already made a bare bone minimalistic docker image with the service [httpd](https://httpd.apache.org/docs/2.4/programs/httpd.html) pre-installed which allows us to hosts websites. All we have to do is provide our HTML code and relevant data. From this image, we will make changes and define our custom image based on subsequent commands in our Dockerfile.

```
MAINTAINER Mayank Tahilramani and Brian Tannous
```

 This is just meta data for the image on who the maintainer/creator of the image and Dockerfile are.

```
COPY ./cpx-blog /www
```

This command simply copies everything `cpx-blog` directory that is local to the Dockerfile into the `/www` directory that is local to the container. Within the container there must already be a `/www` directory (as specified by the [base image](https://github.com/fnichol/docker-uhttpd) to put content in. In this case, any html code or data that will be served by httpd must reside in the `/www` directory within the container.

```
EXPOSE 80
```

This command simply states that port 80 will be open on the container as expected to host a website.

```
ENTRYPOINT /usr/sbin/run_uhttpd -f -p 80 -h /www
```

This command dictates what to execute when the container starts. Note that the container's lifespan is directly dependent on the service it runs on start, in our case the httpd (found at `/usr/sbin/run_uhttpd`) is executed. The entrypoint script basically starts the webservice `httpd` hosting content in `/www`. If for whatever reason the uhttpd service itself fails, hangs, or stops, the running container will stop running as well.

```
CMD [""]
```

This command is similar to `ENTRYPOINT` where traditionally you would define the default command to execute when the container starts. In this case, our ENTRYPOINT script is handling that for us so CMD can be left empty.
   * `CMD` is a mandatory declaration in a Dockerfile.
   * Check out this resource to learn more about difference in use cases between [`CMD` vs `ENTERYPOINT`](https://www.ctl.io/developers/blog/post/dockerfile-entrypoint-vs-cmd/)

---

## Exercise 1 : Write a Dockerfile

In this exercise we will create a new docker image locally from a Dockerfile as discussed in [Module 2](../) overview. We will also make edits to the Dockerfile to customize the image to our preference.

### Step 1 : Clone Git Repository

In the `/data` directory on your host, clone the following git repository:

```bash
# Change the working directory to /data on the docker host
cd /data

# Clone a copy of the github project locally
sudo git clone https://github.com/Citrix-TechSpecialist/GoLang-cpx.git

# List the contents in the /data directory to see the GoLang-cpx project directory
ls -l
```

in the `/GoLang-cpx` directory there is a `Dockerfile`. Lets view the contents with the `cat` command.

```
# Change working directory into the GoLang-cpx project
cd GoLang-cpx

# View what all is in the GoLang-cpx directory
ls -l

# View the Dockerfile contents
cat Dockerfile
```

Once you `cat` the file, you will notice the following content in the [Dockerfile](_code/docker-101/Dockerfile):

```
FROM fnichol/uhttpd
MAINTAINER Mayank Tahilramani and Brian Tannous
COPY ./cpx-blog /www
EXPOSE 80
ENTRYPOINT /usr/sbin/run_uhttpd -f -p 80 -h /www
CMD [""]
```
The content above is pretty much the same we observed in the [Module-2](../) overview. We will now build this container using the [`docker build`](https://docs.docker.com/engine/reference/commandline/build/) command.

### Step 2 : Build Docker Image

Type the following command to build your docker image:

```bash
docker build -t cpx-blog .
```

Here is the breakdown of the command above:

Command | Details
--- | ---
`docker build` | This basically tells the docker engine to build an image.
`-t` | This gives the image a name and optionally a tag in the `name:tag` format.
`cpx-blog` | This will be the name of the created docker image.
`.` | tells docker engine to look for a file named *Dockerfile* (by default) in the current directory.

> Optionally if you named your `Dockerfile` something different like `sandbox.dockerfile` you can append the `-f sandbox.dockerfile` flag after `build` statement.

You will see the following output:

```bash
Sending build context to Docker daemon  1.773MB
Step 1/6 : FROM fnichol/uhttpd
latest: Pulling from fnichol/uhttpd
a3ed95caeb02: Pull complete
1775fca35fb6: Pull complete
718e21306e6b: Pull complete
889bfeab2d4e: Pull complete
8ac43f1732b7: Pull complete
cefd08b5f834: Pull complete
a32be2ed7953: Pull complete
1c78be7a5ec7: Pull complete
74984e6e6d1c: Pull complete
Digest: sha256:28e6f95cf33ae1336525034e2b9d58ddf3cc63a2cdd9edebc8765321d96da9e0
Status: Downloaded newer image for fnichol/uhttpd:latest
 ---> df0db1779d4d
Step 2/6 : MAINTAINER Mayank Tahilramani and Brian Tannous
 ---> Running in 459db6d6a053
 ---> d51effaba5ae
Removing intermediate container 459db6d6a053
Step 3/6 : COPY ./cpx-blog /www
 ---> b1510a20020d
Removing intermediate container b075c62a629b
Step 4/6 : EXPOSE 80
 ---> Running in 84f5263cb817
 ---> f1f4672c9d5b
Removing intermediate container 84f5263cb817
Step 5/6 : ENTRYPOINT /usr/sbin/run_uhttpd -f -p 80 -h /www
 ---> Running in 8e2b276c3aa9
 ---> 552dfe1be7a7
Removing intermediate container 8e2b276c3aa9
Step 6/6 : CMD
 ---> Running in 7c5da4990bea
 ---> 0c78968bbe81
Removing intermediate container 7c5da4990bea
Successfully built 0c78968bbe81
Successfully tagged cpx-blog:latest
```

You can also see the images on the local host with the following command:

```
docker images
```

...which shows:

```bash
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
cpx-blog            latest              0c78968bbe81        46 seconds ago      5.66MB
fnichol/uhttpd      latest              df0db1779d4d        3 years ago         4.87MB
```
Docker pulled the base image `fnichol/uhttpd` from Docker Hub as well as created the layer on top with the changes we added defined in our Dockerfile to create the `cpx-blog` image. This concludes the creation of the image. Next we will create *ONE* more image that is an updated version of the `cpx-blog` image before we run our containers in [Exercise-2](../Exercise-2).

### Step 3 : Tag a New Docker Image

Lets make updates to our `Dockerfile` in `/data/GoLang-cpx`. Open the file up in `nano` with the following command. `nano` is nothing more than a simple text editor for CLI. It can be considered an equivalent to [Sublime Text](https://www.sublimetext.com/) or [Notepad++](https://notepad-plus-plus.org/).

```bash
# In the /data/GoLang-cpx directory enter the following command:
sudo nano Dockerfile
```

Update the file with your cursor and keyboard to reflect the following:

```
FROM fnichol/uhttpd
MAINTAINER Mayank Tahilramani and Brian Tannous
COPY ./cpx-blog /www
WORKDIR /www
RUN echo "find /www -type f -exec sed -i \"s/All rights reserved./Hosted by container: ${HOSTNAME}/g\" {} \\;" > /tmp/update.sh && chmod +x /tmp/update.sh
EXPOSE 80
ENTRYPOINT /tmp/update.sh && /usr/sbin/run_uhttpd -f -p 80 -h /www
CMD [""]
```
    >To exit `nano` after you are done editing, enter the keys `ctrl` + `x` then `y` and `enter` to save and quit.

Here are the details on the updated command lines added above:

```
WORKDIR /www
```

  This changes the working directory of the docker build engine when executing `RUN` commands in the next line. Note that you cannot simply change directories by a single `RUN` command for example `cd /www` because each time you execute a `RUN` command, docker spawns a new container and therefore the default working directory become `/`. See more context [here](https://stackoverflow.com/questions/17891981/docker-run-cd-does-not-work-as-expected)


```
RUN echo "find /www -type f -exec sed -i \"s/All rights reserved./Hosted by container: ${HOSTNAME}/g\" {} \\;" > /tmp/update.sh && chmod +x /tmp/update.sh
```
  This command simply creates a script `/tmp/update.sh` which finds all files in the `/www` directory and replaces strings in them which match the pattern "*All rights reserved.*" with the string "*Hosted by container: ${HOSTNAME}*" where `${HOSTNAME}` is a built in environmental variable in the running container that holds the container's unique host name. By default the hostname of any container is it's short uuid. This script will essentially replace the footer of all web pages which state "All rights reserved" with which container is specifically hosting the website.

   >Note that this command creates a script `/tmp/update.sh` but does not execute it. This command needs to be executed in a final running container state, not during an intermediate step when building the final image. Hence this script created here is executed in the `ENTRYPOINT` step below.

```
ENTRYPOINT /tmp/update.sh && /usr/sbin/run_uhttpd -f -p 80 -h /www
```
 This command dictates what to execute when the container starts. Note that the [container's lifespan](https://medium.com/@lherrera/life-and-death-of-a-container-146dfc62f808) is directly dependent on the service it runs on start, in our case first the `/tmp/update.sh` script executes to update footers on all html pages, then the httpd (found at `/usr/sbin/run_uhttpd`) is executed. The entrypoint script basically starts the webservice hosting content in `/www`. If for whatever reason the uhttpd service itself fails, hangs, or stops, the running container will stop as well.

With the updated changes in our Dockerfile, we have introduced a new script into the container `/tmp/update.sh` which updated some HTML text on our website and is executed upon running the container as defined by our `ENTRYPOINT` statement.

Now lets build our new image:

```bash
# In the /data/GoLang-cpx directory enter the following command:
docker build -t cpx-blog:v2 .
```

View your images via the `docker images` command to see a new tagged version of the `cpx-blog` image was created.

```bash
WORKDIR /www
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
cpx-blog            v2                  7f4074f9eecf        9 seconds ago       5.66MB
cpx-blog            latest              0c78968bbe81        25 minutes ago      5.66MB
fnichol/uhttpd      latest              df0db1779d4d        3 years ago         4.87MB
```
### Review

In ***Step 1*** and ***Step 2*** we created 2 docker images of the same CPX-blog website. The first image was created using a Dockerfile form the [GoLang-cpx](https://github.com/Citrix-TechSpecialist/GoLang-cpx/) repository. The second image was created from a custom Dockerfile which added a script to update the footer of the website with the container's hostname. Below is a overview of the steps above.

  {% asset_img docker-build.gif docker build %}

---

## Exercise 2 : Run a Docker Container

In this exercise we will create a two docker containers from two new images we created in the [previous exercise](../Exercise-1). We will also create a third container that uses volume mounts to share persistent data with the docker host. 

### Step 1 : `sudo docker run`

Lets run our first container based off the image we created from the [GoLang-cpx](https://github.com/Citrix-TechSpecialist/GoLang-cpx/) repository. Enter the following command to run your docker container: 

```
docker run -dt --name=cpx-blog-1 -p 10000:80 cpx-blog
```
 
 Here is the breakdown of the command: 

Command | | Details 
--- | --- | ---
`docker run -dt` | | This will run the container detached with a terminal in the background. Later we will see how we can attach to this container's CLI, but for now we will have the container running detached in the background as a daemon. 
`--name=cpx-blog-1` | | This gives the container a name for more intuitive reference in later docker commands. Without a name parameter, the container will be randomly assigned a name and can be referenced to via the random name or the hash id of the container. 
`-p 10000:80` | |  This will expose port `10000` on the host and map it to port `80` on the container for access to the hosted website.
`cpx-blog` | | This identifies the image we want to use by the docker engine to base our container off of. It will not bother pulling from Dockerhub because the image is already stored locally given you have completed [exercise 1](../Exercise-1).

You should receive an output of a long UID as a reference to the running container similar to `
ed2348b56eda197a90313c8876ab4e6601b52406ba1c6740ccccd6e996565f60`

You can view the running container by entering in the `docker ps` command: 

```
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                   NAMES
ed2348b56eda        cpx-blog            "/bin/sh -c '/usr/..."   About a minute ago   Up About a minute   0.0.0.0:10000->80/tcp   cpx-blog-1
```

Now lets view the website hosted by our docker container. If you are following along on your local machine, go to url [http://localhost:10000](http://localhost:10000).

On the website, scroll down to the very bottom to notice the footer of this page stating: `2016. All rights reserved.` Make a note of this, because we are now going to run our new container that will have updated footer information. 

  {% asset_img cpx-blog-1-footer.png cpx-blog-1 site's footer %}

Lastly, lets remove this container so we can recycle the host port `10000` for our new container. 

```
docker rm -f cpx-blog-1
```

### Step 2 : Run an Updated Container

Lets run our second container based off the image we created from the modified version of the Dockerfile in the [GoLang-cpx](https://github.com/Citrix-TechSpecialist/GoLang-cpx/) repository. Enter the following command to run your docker container: 

```
docker run -dt --name=cpx-blog-2 -p 10000:80 cpx-blog:v2
```

You can view the running container by entering in the `docker ps` command: 
```
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                   NAMES
6e115d1c21f5        cpx-blog:v2            "/bin/sh -c '/usr/..."   About a minute ago   Up About a minute   0.0.0.0:10000->80/tcp   cpx-blog-2
```

Now lets view the updated website hosted by our new docker container. If you are following along on your local machine, go to url [http://localhost:10000](http://localhost:10000).

If you are following along in the sandbox environment, navigate your local browser to [http://userX-lb.sl.americasreadiness.com](http://userX-lb.sl.americasreadiness.com) where `X` denotes your user number in the FQDN. 

On the website, scroll down to the very bottom and notice the footer of this page stating: *2016. Hosted by container: **11ad31695df3**.* The container hostname is showing up because of the `/tmp/update.sh` script that was executed when the container was run to update all `.html` footer code as defined in our new Dockerfile.

  {% asset_img cpx-blog-2-footer.png cpx-blog-2 site's footer %}
 
Lastly, lets remove this container so we can recycle the host port `10000` for our new container. 

```
docker rm -f cpx-blog-2
```

### Step 3 : Persistent Volume Mounts

Thus far we have seen the docker container host the website with the `.html` data local to it's file system. Ideally, you would not want to store any persistent data on the container itself, rather you should store in on some network or hyperconverged storage solution that the container can access as if local instead. This allow you to de-coupling storage of persistent data in the container from the compute processing done by the container itself and allows you to be more agile, spreads your failure domain, and scale independently in storage and compute capacity. 

In this In this step, we will run the same container as in **step 1**, but with a volume mount that shares a directory with the docker host mounted in the container to share persistent data. Enter the following command to run a docker container with a [volume mount](https://docs.docker.com/engine/reference/run/#volume-shared-filesystems).

```
docker run -dt --name=cpx-blog-3 -p 10000:80 -v /data/GoLang-cpx/cpx-blog:/www:rw cpx-blog
```

Here is the breakdown of the new volume mount `-v` flag in the `docker run` command: 

Command | | Details
--- |--- | ---
`-v /data/GoLang-cpx/cpx-blog:/www:rw` | | The `-v` flag denotes that this container will have a volume mount that is located on the local host at `/data/GoLang-cpx/cpx-blog` and that directory will be mapped to the `/www` directory that is local to the container. The container will have *read/write* permissions to this directory as denoted by the `:rw` at the end. 

  * This flag allows us to remove the `COPY ./cpx-blog /www` command form our Dockerfile if desired to. However the pre-requisite of this container would become that a volume mount be provided at run time to host whatever content is in the mounted `/www` directory local to the container.. 

  * Adding volume mounts of persistent data to containers saves space as well, because now the data isn't replicated in each container, rather multiple containers can instead reference the same volume mount on a NFS network share, for example, mounted on the local docker host.

  * Other services can also independently manipulate data in the volume mount directory on the host that have read-write access and it can be reflected in the running cpx-blog containers for example. 

Once you have your container running, lets view the site hosted by our new docker container. If you are following along on your local machine, go to url [http://localhost:10000](http://localhost:10000).

You will notice that the site looks identical to it did in **Step 1**. Lets change some content to the title page to prove a point. 

Enter the following command to edit text in the `index.html` of the home page of the blog: 

```
sudo nano /data/GoLang-cpx/cpx-blog/index.html
```

Scroll down into the file where you see the line: 

```
<h1 class="brand-title">NetScaler NITRO Blogs</h1>
```

update that line to look like : 

```
<h1 class="brand-title">LEARN DOCKER!</h1>
```

Save and quit `nano` by entering the keys `ctrl` + `x` then `y` and `enter`. 

Now refresh your browser to the blog to view the updates changes. You should see a new title in the home page reflecting your changes to the `index.html`

Lastly, lets remove this container so we can recycle the host port `10000` for subsequent Modules. 

```
docker rm -f cpx-blog-3
```

### Review 

In this module, we ran a container hosting our website using a Dockerfile in the [GoLang-cpx](https://github.com/Citrix-TechSpecialist/GoLang-cpx/) repository. We also ran a container that has a script that ran at runtime to dynamically update the footer on each webpage to display the container's hostname. Lastly, we deployed a third container that hosted the webpage through a volume mount where the data of the website only resided on the host and we showed that the data could be independently manipulated to reflect updates on our container hosted website. 

Here is an overview of the previous 3 steps. 

  {% asset_img docker-run-new.gif docker run 3 containers %}
