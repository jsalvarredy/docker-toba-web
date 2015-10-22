FROM FROM williamyeh/ansible:debian8-onbuild


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

