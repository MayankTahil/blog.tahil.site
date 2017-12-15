---
title: Hands on with Docker
tag:
 - [docker]
 - [docker 101]
 - [containers]
category:
  - [tutorials]
  - [docker]
date: 2017-12-14 17:28:29
show: true
---

[Module 0](https://docs.docker.com/engine/installation/) | [Module 1](/docker-101-mod1) | [Module 2](/docker-101-mod2) | [Module 3](/docker-101-mod3)
:---: | :---: | :---: | :---:


# Introduction

I figured I'd start off my first post on a topic I am deeply passionate about : [**Docker containers**](https://www.docker.com/what-container)! In this tutorial, we are going to gain hands on experience and learn the basics docker containers are (how to run them, configure them, and consume them), docker images (how to use them and how to build them), docker commands, and finally learn how to automate the deployment of a simple 'containerized environment' with multiple 'services'.

<!-- more -->

The end result will be a self contained dockerized [sandbox environment / IDE](https://github.com/Citrix-TechSpecialist/nitro-ide/tree/0206630bd6903887d599613a42dd65da550cc37e) to develop scripts and to issue them via [NITRO REST API](http://docs.citrix.com/ja-jp/netscaler/11/nitro-api.html) commands to your NetScaler ADCs. This is just one of **many use cases** to showcase container 'orchestration' to a desired state via simple YAML files. But before we begin, we need a brief introduction on 'containers' and how Docker works under the hood.  This introduction is meant to be short intentionally because the point of the tutorial below is more focused on getting "hands on experience" rather than "delving into theory".

# Tutorial Contents

  * [**Module 0**: Install Docker Locally](https://docs.docker.com/engine/installation/)
  * [**Module 1**: Introduction to Docker Images and Containers](/docker-101-mod1)
  	* *Exercise 1*: Pulling Docker Images
  	* *Exercise 2*: Running a Docker Container
  * [**Module 2**: Introduction to Docker Files](/docker-101-mod2)
    * *Dockerfiles* 
  	* *Exercise 1*: Write a Dockerfile
  	* *Exercise 2*: Run another Docker Container
  * [**Module 3**: Introduction to Docker Compose](/docker-101-mod3)
    * *Exercise 1*: Create a `docker-compose.yaml` file
  	* *Exercise 2*: Compose an Environment


# Brief Technology Overview

> Source of the content below comes from an article published in [InfoWold](http://www.infoworld.com/article/3204171/linux/what-is-docker-linux-containers-explained.html)

[Docker containers](https://blog.docker.com/2016/05/docker-101-getting-to-know-docker/) are self-contained execution environments—with their own, isolated CPU, memory, block I/O, and network resources—that share the kernel of the host operating system. The result is **something that feels like a virtual machine, but sheds all the weight and startup overhead of a guest operating system.** 

To understand containers, we have to start with Linux [cgroups](https://sysadmincasts.com/episodes/14-introduction-to-linux-control-groups-cgroups) and [namespaces](http://blogs.igalia.com/dpino/2016/04/10/network-namespaces/), the Linux kernel features that create the walls between containers and other processes running on the host. Linux namespaces, originally developed by IBM, wrap a set of system resources and present them to a process to make it look like they are dedicated to that process.

**In short:** 

  * **Namespaces** :  Limits what the running process can see. I.E. processes can have their own view of the system’s resources.
  * **cgroups** :  Metering and limiting mechanism, they control how much of a system resource (CPU, memory) processes can use.

In comparison to virtual machines, containers feel and act like independent operating system environments, but are actually layered on top of an existing OS similar to how a VM would be on top of a hypervisor. A visual below is provided for contextual aid in comparison with traditional VM architecture vs a docker containerized architecture. 

  {% asset_img containers-visual.png Containers vs Virtual Machines %}

# Pre-requisites 

  * [Install Docker](https://docs.docker.com/engine/installation/)
  	* You must install Docker in your local environment to do this tutorial. Follow the instructions in the link provided to install Docker on your operating system. 

> **Note**: You can also find this tutorial directly on GitHub where I've posted an older version of this lab [here](https://github.com/Citrix-TechSpecialist/Docker-101) within the "Docker-101" repository of the [@Citrix-TechSpecialist](https://github.com/Citrix-TechSpecialist) organization. 