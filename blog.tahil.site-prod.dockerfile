# Pull base image.
FROM node:alpine as hexo-server
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
ENTRYPOINT ["./export.sh"]
CMD [""]

#
# Hexo site hosted via uhttpd in Docker
#
FROM fnichol/uhttpd
MAINTAINER Mayank Tahilramani
COPY --from=hexo-server /blog/public /www
EXPOSE 80
ENTRYPOINT /usr/sbin/run_uhttpd -f -p 80 -h /www
CMD [""]