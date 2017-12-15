---
title: Introduction to Docker Compose
tag:
 - [docker]
 - [sandbox]
 - [backdoor]
 - [container ide]
 - [docker-compose]
 - [dockerfile]
 - [docker-cli]
 - [cloud9]
 - [NetScaler]
 - [cpx]
 - [docker 101]
category:
  - [tutorials]
date: 2017-12-14 17:28:29
show: false
---

[Module 0](https://docs.docker.com/engine/installation/) | [Module 1](/docker-101-mod1) | [Module 2](/docker-101-mod2) | [Module 3](/docker-101-mod3)
:---: | :---: | :---: | :---:

# Module 3: Using Docker Compose

Let's assume by now you are familiar with basic Docker commands such as [`docker run`](https://docs.docker.com/engine/reference/run/#volume-shared-filesystems), [`docker ps`](https://docs.docker.com/engine/reference/commandline/ps/), [`docker pull`](https://docs.docker.com/engine/reference/commandline/pull/), [`docker rm`](https://docs.docker.com/engine/reference/commandline/rm/), and the various parameter flags (such as `-v` for volume mounts) associated with some of these commands.

It should also be obvious at this point that deploying docker containers at scale by hand with `docker run` commands can be very involved and, at time, too complicated with multiple lines of `docker ..` commands to deploy a large environment. Luckily, docker containers are not meant to be deployed via individual commands, rather they are often deployed to a desired state using various other tools that help automate and/or orchestrate microservices backed by docker containers. Some of these accompanying tools are provided below for reference.

<!-- more --> 
Docker Tool | Details
--- | ---
[Kubernetes](https://kubernetes.io/) | Google's container orchestration and automation solution to schedule and maintain service state of docker containers.
[Mesos](https://mesosphere.com/why-mesos/?utm_source=adwords&utm_medium=g&utm_campaign=43843512431&utm_term=mesos&utm_content=196225818929&gclid=CjwKEAjwtJzLBRC7z43vr63nr3wSJABjJDgJ_9xn3RWHnkH_nDjxQs1X8U6YgQ0drZPoOTfLv9-4hhoCqN3w_wcB)/[Marathon](https://mesosphere.github.io/marathon/) | Another Automation platform (Mesos) with an orchestration framework (Marathon) to ensure service state of docker containers.
[Rancher](http://rancher.com/) | One of my favorites, complimentary to K8. Rancher is an opensource container management solution that makes it easy to deploy and manage containers in their own 'Cattle environments' and can even operate and manage other orchestration platforms like Kubernetes, Mesos/Marathon, and Docker Swarm.
[Docker Swarm](https://docs.docker.com/swarm/overview/) | Docker's solution to automation and orchestration of clustered resources to provide a pool of Docker hosts into a single, virtual Docker host.
[Docker Compose](https://docs.docker.com/compose/) | A automation tool for defining and running multi-container Docker applications. This tool is less sophisticated than the ones listed above and more simpler to use but with fewer features for larger deployments at scale.

**In this module, we will be focusing on learning how to use Docker Compose to provision a self contained development environment based on a single input file that describes our desired state and configuration.**

## Docker Compose 

>Source of description comes from [Docker's documentation](https://docs.docker.com/compose/overview/).

Compose is a tool for defining and running multi-container Docker applications. With Compose, you use a Compose file to configure your application’s services. Then, using a single command, you create and start all the services from your configuration.

Using Compose is basically a three-step process.

**Step 1**: Define your container with a `Dockerfile` so it can be reproduced anywhere. Either have provide the [Dockerfile as an input](https://docs.docker.com/compose/reference/build/) or have the defined container hosted in a [docker registry](https://docs.docker.com/registry/) like [docker hub](hub.docker.com/).

**Step 2**: Define the containers that make up your microservices in a `docker-compose.yml` file so it can be run together with other containers in an isolated environment. The `docker-compose.yml` basically consist of `key` : `value` pairs as per the [yaml syntax](https://github.com/Animosity/CraftIRC/wiki/Complete-idiot's-introduction-to-yaml) describing the desired state of your services.

**Step 3**: Lastly, run the command `docker-compose up` and Compose will start and run your entire microservice based app as per the desired state.

## Overview

In this module, we are going to automate the deployment of a simple, self contained, dockerized [sandbox environment](https://github.com/Citrix-TechSpecialist/nitro-ide) to write scripts that issue [NITRO](http://docs.citrix.com/ja-jp/netscaler/11/nitro-api.html) commands to your NetScaler ADCs. In this case we will be issuing commands to a [NetScaler CPX](microloadbalancer.com) that will be locally provisioned on your machine to load balance simple containerized websites. However, it should be noted that this tutorial can be translated to develop and issue commands against other [NetScaler ADCs](https://www.citrix.com/products/netscaler-adc/platforms.html) as well if desired.

The desired environment will have the following topology:

  {% asset_img topology.jpg Dev Box Topology %}

Services | Details
--- | ---
**Webserver A** | Static containerized HTTP website
**Webserver B** | Static containerized HTTP website
**NetScaler CPX** | This will be the target NetScaler to send NITRO API calls to load balance webserver A and webserver B.
**Cloud9 IDE** | Web-based Interactive Developer Environment that allows for rapid scripting and coding through a web browser.

  >All the services above will be isolated in a dedicated [Docker Network](https://docs.docker.com/engine/userguide/networking/). Individual web interfaces that we will need direct external access to will have [external ports mapped](https://docs.docker.com/compose/compose-file/compose-file-v2/#ports) to the container for access from the underlay network (basically your host's LAN).

---

## Exercise 1 : Create docker-compose.yaml

Instead of creating a `docker-compose.yml` file from scratch, we are going to copy one from another repository to get started. We will then examine the file and understand it's anatomy before finally making edits to suite our environment needs.

### Step 1

To get started, enter the following commands to clone a repository with a `docker-compose.yml` file already made for us. Navigate to the directory and view the contents with `nano`.

```bash
# Change directory to the workspace you want to clone the repository
cd /data

# Clone the desired repository
sudo git clone https://github.com/Citrix-TechSpecialist/nitro-ide.git

# enter the directory of the repository
cd nitro-ide

# View the file contents of docker-compose.yml
nano docker-compose.yml
```
Here is a copy of the <a href="/_code/docker-101/docker-compose.yaml" download="docker-compose.yaml">docker-compose.yaml</a> file for reference. It is recommended you open it in another tab in your browser to follow along.  

Below are the desired services we want to configure and deploy.

  1. [Webserver A](https://hub.docker.com/r/mayankt/webserver/) that is a static website site
  2. [Webserver B](https://hub.docker.com/r/mayankt/webserver/) that is a different static website
  3. [Cloud9 IDE](https://c9.io/) which we will use to write code and execute python scripts to automate configuration of NetScaler CPX.
  4. [NetScaler CPX](https://microloadbalancer.com) a NetScaler in a docker container that share the same API as other NetScaler ADCs.  

### Explaining the docker-compose.yml File

Below are snippets of the <a href="/_code/docker-101/docker-compose.yaml" download="docker-compose.yaml">`docker-compose.yaml`</a>  with comments (`#`) per line with details of each `key` : `value` pairs describing the desired deployment.

**Sandbox Network**

With Docker you can define specific container networks. In this case we are creating a [bridge network](https://docs.docker.com/engine/userguide/networking/#bridge-networks) specific to deploying only our desired containers to within a SDN boundary internal to the host.

```
networks:                             # This defines that below are settings for docker networks
  sandbox:                            # Name of the network
    driver: bridge                    # The type of network driver to use
    ipam:                             # Details of the network and IP space
      config:                         # Configuration parameters
        - subnet: "192.168.13.0/24"   # The desired subnet of the docker network
```

**WebServer A / B**

```
webserver-a/b:                         # Service name
    image: "mayankt/webserver:a"       # Docker container image to use
    restart: always                    # Restart the service if it fails or the host reboots
    networks:                          # This describes the docker networks the containers will be part of
      sandbox:                         # Docker network's name
        ipv4_address: "192.168.13.11"  # Static IP address of this service/container. You can leave this key:value out and to obtain an IP from Docker's IPAM
    hostname: webserver-a              # Desired hostname of the container
```

[**NetScaler CPX**](http://docs.citrix.com/en-us/netscaler-cpx/12/deploy-using-docker-image-file.html)

```
  cpx:                                               # Service Name
    image: "store/citrix/netscalercpx:12.0-41.16"    # Docker container image to use from Citrix' registry
    environment:									                   # Environment Variables local to the container
      EULA: "yes"									                   # same as 'export EULA="yes"' as a pre-req for CPX to work
    restart: always                                  # Restart the service if it fails or the host reboots
    cap_add:                                         # Add specific container kernel capabilities https://docs.docker.com/engine/security/security/#linux-kernel-capabilities
      - NET_ADMIN                                    # Perform various network-related operations https://linux.die.net/man/7/capabilities
    ulimits                                          # Override the default (resource) ulimits for a container
      core: -1                                       # Use unlimited CPU, up to the amount available on the host system.
    networks:                                        # This describes the docker networks the containers will be part of
      sandbox:                                       # Docker network's name
        ipv4_address: "192.168.13.20"                # Static IP address of this service/container. You can leave this key:value out and to obtain an IP from Docker's IPAM
    ports:                                           # Exposed ports mapped to the host from the container.
      - "10000-10050:10000-10050"					
      - "9080:80"
    hostname: ns-adc                                 # Desired hostname of the container
```

[**Cloud9 IDE**](https://aws.amazon.com/cloud9/)

```
  nitro-ide:                          # Service Name
    image: "mayankt/nitro-ide"        # Docker container image to use from Citrix' registry
    restart: always                   # Restart the service if it fails or the host reboots
    dns: 8.8.8.8                      # Specific DNS server to use for host name resolution from within the container
    networks:                         # This describes the docker networks the containers will be part of
      sandbox:                        # Docker network's name
        ipv4_address: "192.168.13.10" # Static IP address of this service/
    ports:                            # Exposed ports mapped to the host from the container.
      - "9090:80"
      - "9091:8000"
    links:                            # Link to containers in another service given service name and/or a link alias ("SERVICE:ALIAS"). "ping web-a" will ping the webserver-a service from within the container.
      - "cpx"
      - "webserver-a:web-a"
      - "webserver-b:web-b"
    volumes:                          # Volume mounts local to the host mapped to a directory local to the container with read/write access (rw)
        - ${DATA_DIR}:/workspace:rw      
    hostname: nitro-ide               # Desired hostname of the container
```
> Note you may have to uncomment the `volumes` section to mount volumes in the docker file that is pulled from the repository. Use `nano` to remove the `#` from the `volumes:` block.

### Step 2

Set the environmental variable `DATA_DIR` to `/data` on the docker host. This environment variable will substitute the value `/data` into the docker compose file when we provision our containers. Type the following on your docker host:

```
export DATA_DIR="/data"`
```

Verify that the environmental variable was set successfully by typing the following command:

```
echo $DATA_DIR
```

It should return the `/data` directory path.

### Review

In this module we clones a repository with our desired compose file. We explored what constitutes a `docker-compose.yml` file and what the various parameters mean. We set the value `/data` for a placeholder in the compose file that took in an environment variable to specify which local directory will be mapped to our IDE's local workspace `/workspace` so we can share data from host to container.

Here is an overview of configuration steps:

  {% asset_img docker-compose.gif docker-compose up -d %}

---

## Exercise 2 : Compose an Environment

Once you have your <a href="/_code/docker-101/docker-compose.yaml" download="docker-compose.yaml">docker-compose.yaml</a> set, you can move forward with provisioning your environment.

### Step 1 : Provision an Environment

In the `/data/nitro-ide` directory, enter the following commands:

```
# Navigate to the repository local to your host
cd /data/nitro-ide

# Issue the docker compose command to provision your environment
docker-compose up -d
```
  > The `-d` in the [`docker-compose up -d`](https://docs.docker.com/compose/reference/up/) specifies that containers run in the background in detached mode.

You should observe an output similar to the following:

```
Pulling cpx (store/citrix/netscalercpx:12.0-41.16)...
12.0-41.16: Pulling from store/citrix/netscalercpx
4e1f679e8ab4: Pull complete
..
..
..
588f5003e10f: Pull complete
Digest: sha256:31a65cfa38833c747721c6fbc142faec6051e5f7b567d8b212d912b69b4f1ebe
Status: Downloaded newer image for store/citrix/netscalercpx:12.0-41.16
Pulling nitro-ide (mayankt/nitro-ide:latest)...
latest: Pulling from mayankt/nitro-ide
a3ed95caeb02: Pull complete
..
..
..
9581fa7fd579: Pull complete
Digest: sha256:53c464876633e95f8e11ea821c50add0ff8e00a70c5aacd65f465d2d3045d8d3
Status: Downloaded newer image for mayankt/nitro-ide:latest
Pulling webserver-b (mayankt/webserver:b)...
b: Pulling from mayankt/webserver
3ac0c2aa6889: Pull complete
..
..
..
4484f1613730: Pull complete
Digest: sha256:5807d78ba9c3892238a1eef2763c82f719d077b02a0c087122b816d276f0fbc4
Status: Downloaded newer image for mayankt/webserver:b
Pulling webserver-a (mayankt/webserver:a)...
a: Pulling from mayankt/webserver
3ac0c2aa6889: Already exists
..
..
..
f128b2a739b4: Already exists
1341f98ff817: Pull complete
Digest: sha256:921d4054855c335dcd48a83bd881fa9059fa003f62f1b29bbe4b3a40fc79cc9a
Status: Downloaded newer image for mayankt/webserver:a
Creating nitroide_webserver-b_1
Creating nitroide_nitro-ide_1
Creating nitroide_cpx_1
Creating nitroide_webserver-a_1
```
You can validate your desired containers are running by issuing a `docker ps` command to see all running containers.  

```
CONTAINER ID        IMAGE                                  COMMAND                  CREATED             STATUS              PORTS             
                                                                     NAMES
37892600b3d6        store/citrix/netscalercpx:12.0-41.16   "/bin/sh -c 'bash ..."   13 seconds ago      Up 10 seconds       22/tcp, 443/tcp, 1
61/udp, 0.0.0.0:10000-10050->10000-10050/tcp, 0.0.0.0:9080->80/tcp   nitroide_cpx_1
772b633440d7        mayankt/webserver:a                    "/bin/sh -c 'nginx'"     13 seconds ago      Up 10 seconds       80/tcp, 443/tcp   
                                                                     nitroide_webserver-a_1
aeef73f08b84        mayankt/nitro-ide                      "supervisord -c /e..."   13 seconds ago      Up 11 seconds       3000/tcp, 0.0.0.0:
9090->80/tcp, 0.0.0.0:9091->8000/tcp                                 nitroide_nitro-ide_1
bb50c29a35c8        mayankt/webserver:b                    "/bin/sh -c 'nginx'"     13 seconds ago      Up 10 seconds       80/tcp, 443/tcp   
                                                                     nitroide_webserver-b_1
```

### Step 2 : Access your IDE

Once all your containers are running successfully, navigate to your IDE's web console. On your local machine, go to url [http://localhost:9090](http://localhost:9090).

  >Please wait up to 60 seconds for the IDE and CPX to fully load before they are accessible via the web console. Usually services are available within 30 seconds of deployment.

You should be greeted with Cloud9's loading page and then ultimately the IDE editor pane. Within the side pane you should notice your `workspace` directory and within that directory you should see the `nitro-ide` repository on your docker host.

You can select any file to open and edit it or to examine it. You even have access to the container's CLI terminal in the bottom pane. In the container's CLI pane within Cloud9 IDE, enter the following commands:

```
git clone -b cpx-101 https://github.com/Citrix-TechSpecialist/NetScalerNITRO.git
```

### Step 3 : Execute Script from IDE

A new directory will have been created `NetScalerNITRO` with the `nsAuto.py` python script that is pre-coded to configure the CPX to loadbalance webserver-a and webserver-b.

In the bottom pane within the container's CLI, enter the following commands to configure the CPX via NITRO scripted with Netscaler's Python SDK. Desired state configuration is specified in the `nsAutoCfg.json` file with pre-seeded default values for our environment (i.e. backend webserver IP's and CPX default username and pass along with its NSIP.)

  >It is highly encouraged to open the `nsAuto.py` and `nsAutoCfg.json` file within the IDE to examine and learn from its contents and understand how the script is coded with NetScaler's NITRO Python SDK.

```
cd NetScalerNITRO
python nsAuto.py
```

You will see an output similar to:

```
Configuring NS
Starting to configure...
All done preforming configuration
```

This indicates that the CPX has been configured successfully. It is load balancing Webserver A and Webserver B on its port 10000, using it's docker container IP in the sandbox docker network. Container port 10000 is mapped to host port 10000 so you can access your load balancer at [http://localhost:10000](http://localhost:10000).

### Step 4 : Validate Configurations

To validate the configurations on the NetScaler CPX, enter the following commands on the Docker host to attach to the container's bash terminal:

`docker exec -it nitroide_cpx_1 /bin/bash` and you will have entered into CPX's CLI.

Then enter in the following NetScaler CLI commands to view configured vservers on the ADC with the following command:

`cli_script.sh "sh lb vservers"` and you will see an output similar to the following for the configured vserver:

```
1)webserver (192.168.13.20:10000) - HTTPType: ADDRESS
State: UP
Last state change was at Fri Jul 14 02:02:23 2017
Time since last state change: 0 days, 01:30:54.410
Effective State: UP
Client Idle Timeout: 180 sec
Down state flush: ENABLED
Disable Primary Vserver On Down : DISABLED
Appflow logging: ENABLED
Port Rewrite : DISABLED
No. of Bound Services :  2 (Total)  2 (Active)
Configured Method: ROUNDROBINBackupMethod: NONE
Mode: IP
Persistence: NONE
Vserver IP and Port insertion: OFF
Push: DISABLEDPush VServer:
Push Multi Clients: NO
Push Label Rule: none
L2Conn: OFF
Skip Persistency: None
Listen Policy: NONE
IcmpResponse: PASSIVE
RHIstate: PASSIVE
New Service Startup Request Rate: 0 PER_SECOND, Increment Interval: 0
Mac mode Retain Vlan: DISABLED
DBS_LB: DISABLED
Process Local: DISABLED
Traffic Domain: 0
TROFS Persistence honored: ENABLED
Retain Connections on Cluster: NO
```

### Review

In this exercise we deployed a sandbox development environment with an IDE, NetScaler CPX, and 2 simple webservers using docker compose. We then logged into the IDE and cloned a repository with python code that will automatically configure the NetScaler CPX using the pre-defined input file `nsAutoCfg.json` that provides details on the desired configuration state of the CPX. We validated that the websites were being load balanced and saw the running load balancer configuration on the CPX.

Here is an overview of the procedures above:

  {% asset_img docker-compose-up.gif docker compose up %}
