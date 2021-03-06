# https://github.com/jupyterhub/dockerspawner/issues/154#issuecomment-317029043
ARG BASE_CONTAINER=gcr.io/kubeflow-images-public/tensorflow-2.1.0-notebook-gpu:1.0.0
FROM $BASE_CONTAINER

USER root

# RUN echo "$NB_USER:$NB_USER" | chpasswd
# RUN sudo adduser $NB_USER sudo

# Switch back to jovyan to avoid accidental container runs as root
# USER $NB_UID

EXPOSE 8888

ENV GRANT_SUDO=1
ENV RESTARTABLE=1

# https://github.com/kubeflow/kubeflow/blob/master/components/tensorflow-notebook-image/Dockerfile
ENTRYPOINT ["tini", "--"]
CMD ["sh","-c", "jupyter lab --notebook-dir=/home/${NB_USER} --ip=0.0.0.0 --no-browser --allow-root --port=8888 --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*' --NotebookApp.base_url=${NB_PREFIX}"]