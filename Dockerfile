ARG BASE_CONTAINER=public.ecr.aws/j1r0q0g6/notebooks/notebook-servers/jupyter-pytorch-cuda-full:v1.5.0
FROM $BASE_CONTAINER

USER root

# https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-ver16#ubuntu18
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list > /etc/apt/sources.list.d/mssql-release.list

RUN apt-get update -y

RUN ACCEPT_EULA=Y apt-get install msodbcsql18 mssql-tools18 -y

# Install pyodbc https://stackoverflow.com/a/51894871
RUN apt-get install g++ unixodbc-dev -y

COPY requirements.txt .

RUN pip install -r requirements.txt

EXPOSE 8888

ENV GRANT_SUDO=1
ENV RESTARTABLE=1

# https://github.com/kubeflow/kubeflow/tree/master/components/example-notebook-servers#custom-images--s6--run-as-root
ENTRYPOINT ["/init"]
# CMD ["sh","-c", "jupyter lab --notebook-dir=/home/${NB_USER} --ip=0.0.0.0 --no-browser --allow-root --port=8888 --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*' --NotebookApp.base_url=${NB_PREFIX}"]