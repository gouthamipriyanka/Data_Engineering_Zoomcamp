# Python as the base layer to setup the environment in which the container will run.
FROM python:latest

# perform the required tasks in the container
RUN pip install pandas

# copy the file in the container by cd and  creating the directory
WORKDIR /app


# copies the files from the host OS file system to image file system.
COPY pipeline.py pipeline.py

# instructions that are executed when the container is run
# ENTRYPOINT [ "bash" ]

# Modified the entrypoint for pipeline execution.
ENTRYPOINT [ "python","pipeline.py" ]
