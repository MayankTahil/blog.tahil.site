#
# Hexo Dockerfile
#
# https://github.com/mayanktahil/docker-hexo
#

# Pull base image.
FROM node:alpine
MAINTAINER Mayank Tahilramani
# Install Hexo
RUN npm install -g hexo
ENV HOME /home/hexo
# Mount a Host Directory as a Data Volume for hexo
VOLUME /blog
# Expose ports.
EXPOSE 4000
COPY ./blog /blog
WORKDIR /blog
ENTRYPOINT ["hexo"]

CMD ["server"]