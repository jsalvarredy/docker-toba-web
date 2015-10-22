FROM williamyeh/ansible:debian8-onbuild
MAINTAINER Joaquin Salvarredy <joaquin@salvarredy.com.ar>
ENV DEBIAN_FRONTEND noninteractive

ADD ansible /ansible
WORKDIR /ansible

# Run Ansible to configure the Docker image
RUN ansible-playbook toba-web.yml -c local



WORKDIR /data
VOLUME ["/data"]

# Other Dockerfile directives are still valid
EXPOSE 80
COPY start.sh /start.sh
CMD ["/start.sh"]

