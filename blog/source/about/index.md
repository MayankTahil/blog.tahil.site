---
title: About
date: 2017-12-14 09:19:19
---

[![Online Resume](index/resume.png)](http://mayank.tahil.site) | [![@Mayanktahil](index/github.png)](https://github.com/mayanktahil) | [![@Mayanktahil](index/linkedin.png)](https://www.linkedin.com/in/mayanktahil/) | [![@Mayanktahil](index/twitter.png)](https://twitter.com/mayanktahil?lang=en) | [![@Mayanktahil](index/instagram.png)](https://www.instagram.com/mayanktahil/) | [![Send Mail](index/email.png)](mailto:mayank.tahil-AT-gmail.com) | [![RSS Feed](index/rss.png)](http://blog.tahil.site/atom.xml) | [![@mayankt](index/docker.png)](https://hub.docker.com/u/mayankt/)
:---: | :---: | :---: | :---: | :---: | :---: | :---: | :---:


# Introduction 

This blog originally started off as a weekend side project to learn more about front end development and to get my hands dirty with HTML, CSS, JavaScript, and AngularJS. After about a day, I realize just how easy modern tools have made it to quickly create beautiful, functioning websites. In a nutshell, this blog will serve to host content I've been originally stowing away in `README.MD` files within my GitHub repositories. Now I'd like legitimize them into online technical tutorials for the community to consume. However, this blog won't  focus *only* on technical 'how-to's' rather it will also be focusing on new and emerging technologies within the [container](https://en.wikipedia.org/wiki/Operating-system-level_virtualization) and [cloud](https://en.wikipedia.org/wiki/Cloud_computing) space. You can expect to see my personal opinions on start-ups and automation tools as they emerge into popularity. 

# Background

My education background is in Biochemistry with a focus on Neuro-engineering but professionally I work within IT as an experienced tech specialist who isn't afraid to automate anything and everything. I've been customer facing most of my career with marked experience in Pre-Sales, Customer Service, Networking, Cloud, Docker, and Automation. I consider myself a strong advocate of Open Source Software (OSS), Open Source Knowledge Sharing, and the ongoing shift of agile transformation at the data center and in the cloud. If I'm not working, you can likely find me walking my dog or exploring around the city. You can find out more about me by visiting my [online resume](http://mayank.tahil.site]. 

# Offline Blog 

If you have docker locally installed, you can steal a portable, lightweight, off line copy of this blog by following the steps below. 

## From Docker Hub

To pull a ready made image from my docker hub account, execute the following : 

```bash
docker run -it --rm -p 80:80 mayankt/blog:master
```

> You can abort hosting the site by pressing `ctrl` + `c` to quit terminal task execution. 

Navigate to [localhost](http://localhost) to view the contents of the blog in your web browser 

## From GitHub

You can clone this blog and create your own local docker image by executing : 

```bash
# Clone the repository locally
git clone https://github.com/MayankTahil/blog.tahil.site.git

# Enter repository 
cd blog.tahil.site

# Create your container image
docker build -f blog.tahil.site-lite.dockerfile -t mayankt/blog:master .

# Run your docker container
docker run -it --rm -p 80:80 mayankt/blog:master
```

> You can abort hosting the site by pressing `ctrl` + `c` to quit terminal task execution. 

Navigate to [localhost](http://localhost) to view the contents of the blog in your web browser 


# Global Notice

The owner/authors of this blog make no representations as to the accuracy or completeness of any information on this site or found by following any link on this site. The owner will not be liable for any errors or omissions in this information nor for the availability of this information. The owner will not be liable for any losses, injuries, or damages from the display or use of this information. All content in this blog is of the author's opinion and does not represent in any way his/her employer's nor any other corporation's opinion. These terms and conditions of use are subject to change at any time and without notice.





