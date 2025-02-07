# Python as the base layer to setup the environment in which the container will run.
FROM python:latest



# install the necessary dependencies in the container
RUN apt-get install wget
RUN pip install pandas sqlalchemy psycopg2

# copy the file in the container by cd and  creating the directory
WORKDIR /app


# copies the files from the host OS file system to image file system.
COPY ingest_data_homework.py ingest_data_homework.py

# instructions that are executed when the container is run
# ENTRYPOINT [ "bash" ]

# Modified the entrypoint for pipeline execution.
ENTRYPOINT [ "python","ingest_data_homework.py" ]
