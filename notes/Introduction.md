# Overview:

### Week 1&2 : Introduction to Docker, Terraform and GCP
***

**Docker**: Docker is a containerization platform which is used to deliver software in packages called containers.

Docker Commands: 
* -rm : remove
* -i  : interactive mode
* -r : recursive
* docker run : run a container
* docker build : builds the image from the dockerfile

How a docker container is built?

![alt text](images/docker_image.png)

Docker containers are stateless meaning any data stored is lost when they are restarted or stopped. We should rely on external sources to store persisitent information. 

For stateful applications we need to mount volumes from host machine to container or use external databases.



**Create a dummy pipeline**
***

The pipeline.py file contains a python script that accepts a system argument day and prints it using the print statement. 



**Write a dockerfile to build a docker image**
***

A dockerfile does not have an extension and we name it "dockerfile". This file contains the required set of commands to build a docker container.

To build the image from the file we use:

```ssh
docker build -t test:pandas .
```

test  - image name

pandas - tag (default is latest)

.(period) - represents the current directory as the build context, tells Docker to use the current directory as the source for building the Docker image.

Now the Dockerfile contains how to build the container.



**Run the container**:

***

```ssh
docker run -it test:pandas day_number
```

The ouput prints two lines:

* ['pipeline.py', '<day_number>']
* job finished successfully for the day of <day_number>

### Using Docker to run a Postgres container
***

We need to create a folder to store the database information because containers are stateless. We use volumes for this in this course.

Create a folder to allow postgres to store the data.

Run the postgres container by specifying certain variables as shown below:

```bash
winpty docker run -it \
    -e POSTGRES_USER="root" \
    -e POSTGRES_PASSWORD="root" \
    -e POSTGRES_DB="ny_taxi" \
    -v D:\\Technical\\DataTalks\\Data_Engineering_Zoomcamp\\docker\\ny_taxi_postgres_datadata:/var/lib/postgresql/data \
    -p 5432:5432 \
    postgres:13

```

### Connecting pg-admin and postgres
***
 ```bash
winpty docker run -it \
     -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
     -e PGADMIN_DEFAULT_PASSWORD="root" \
     -p 8080:80 \
     dpage/pgadmin4
```

Once the login page opens on the link http://localhost:8080/login, use the relevant details from above to login. Create a new server with a name, connection and save. This might throw an error as postgres and pgadmin are in two different containers and hence needs to be linked through a docker network to be able to communicate with each other.

### Connecting postgres and pgadmin via a docker network

Step 1: Run the postgres container in the network using the below additions to the previous command.

```bash
winpty docker run -it \
    -e POSTGRES_USER="root" \
    -e POSTGRES_PASSWORD="root" \
    -e POSTGRES_DB="ny_taxi" \
    -v D:\\Technical\\DataTalks\\Data_Engineering_Zoomcamp\\docker\\ny_taxi_postgres_data:/var/lib/postgresql/data \
    -p 5432:5432 \
    --network=pg-network \
    --name pg-database \
    postgres:latest 
```

Step 2: Run the pgadmin container in the same network.

```bash

winpty docker run -it \
    -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
    -e PGADMIN_DEFAULT_PASSWORD="root" \
    -p 8080:80 \
    --network=pg-network \
    --name pg-admin1 \
    dpage/pgadmin4

``` 


### Dockerizing the jupyter notebook into a python script to poulate the postgres database

Convert the notebook into a python script using the below command

```bash
 jupyter nbconvert --to=script notebookname.ipynb
```

Remove the unnecessary lines and after cleaning up the file a bit, we need to pass the arguments to connect to the engine through command line.

Pass the arguments using the library argparse. Based on the below line of code, 

```bash
engine = create_engine('database://user:password@host:port/database_name')
```
we need database, user, password, host, port, database_name/table_name. 

Since, in the notebook we directly pass the csv file, and we need to pass it through command line now, we need the url of the file as well as one of the params.

Change the script variables according to the params and test it using the below command. (Make sure to delete the table contents before filling the table again.)


URL = "https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2021-01.csv"
```bash
python ingest_data.py \
    --user = root \
    --password = root \
    --host = localhost \
    --port = 5432 \
    --db = ny_taxi \
    --table_name = yellow_taxi_trips \
    --url = {URL}
```
The above command will create the table and fill the database. 


Dockerizing the script and creating a container:

Modify the previous docker file by adding the extra dependencies and build the container.

```bash

FROM python:3.9.1

# We need to install wget to download the csv file
RUN apt-get install wget

# psycopg2 is a postgres db adapter for python: sqlalchemy needs it
RUN pip install pandas sqlalchemy psycopg2

WORKDIR /app
COPY ingest_data.py ingest_data.py 

ENTRYPOINT [ "python", "ingest_data.py" ]

```

Build the image

```bash
docker build -t taxi_ingest:v001 .
```

Run the container.

Things to remember:
* The new container and postgres and pgadmin should all be in one network to work. So provide the network name before the name of the container which is pg-network created before in this case.
* The database connection should connect to postgres in another container and hence instead of localhost we point it to postgres
* Drop the table beforehand or leave it as is since it is replaced by the script.

```bash
winpty docker run -it \
    --network pg-network \
    taxi_ingest:v001 \
    --user=root \
    --password=root \
    --host=pg-database \
    --port=5432 \
    --db=ny_taxi \
    --table_name=yellow_taxi_trips \
    --url="http://192.168.56.1:8000/yellow_tripdata_2021-01.csv"
```
# Errors faced:

1. Arguments mismatch, eg: table-name when building the image and table_name while running the docker command .

Observations:

Each time you exceute the run container command, a container is created irrespective of the error it throws.

No spaces after = while passing the parameters in docker commands.

### New docker commands learned:

List of all images:

```bash
docker images
```

Remove an image

```bash
docker rmi image_name
```

List all the containers created using the image

```bash
docker ps -a --filter ancestor=<image_name> 
```
Remove all the contaiers under the image
```bash
docker rm $(docker ps -a -q --filter ancestor=<container_name>)
```
-q indicates the quiet flag indicating to show only container ids instead of all the additional information.

Remove all the containers except for a few:
```bash
docker ps -a -q | grep -v -E "<container1>|<container2>|<container3>" | xargs docker rm
```


### Running the postgres and pgadmin containers using docker compose

* Instead of configuring the containers separately and linking them to the network, we can define one yaml file, and put the details in there. 

* Docker compose is a utility that allows you to put multiple configs of containers in on place.

Create a docker-compose yaml file and define the services postgres and pgadmin with the necessary variables. They are automatically linked when the file runs avoiding the need to create a network.

```yaml

services:
  pg-database:
    image: postgres-latest
    environment:
      - POSTGRES_USER=root
      - POSTGRES_PASSWORD=root
      - POSTGRES_DB=ny_taxi
    volumes:
      - D:\\Technical\\DataTalks\\Data_Engineering_Zoomcamp\\docker\\ny_taxi_postgres_data:/var/lib/postgresql/data:rw
    ports:
      - "5432:5432"

  pg-admin:
    image: dpage/pgadmin4
    environment:
      - PGADMIN_DEFAULT_EMAIL=admin@admin.com
      - PGADMIN_DEFAULT_PASSWORD=root
    ports:
      - "8080:80"
```

To run the docker-compose file :

```bash
docker-compose up -d
```

-d means detached mode, so we get the terminal back for further use, but it still works without that.

The volumes are not defined in the pg-admin so you may need to re-enter the server details in pg-admin.

To stop the containers:
```bash
docker-compose down
```


## Terraform 

Terraform is an infrastructure as code tool that allows us to access infrstructure with the help of code. 

To install Terraform, download it and extract the folder to C > Program Files > Terraform folder (create a new one). Add the folder path to system environment variables.
Note: Do not forget to restart VS Code and Git Bash if you are testing for installation.

```bash
terraform --version
```
If this returns a version number, terraform is successfully installed on your machine.

Create a main.tf file in VS CODE.

Use the below command to automatically format the terraform file.

```bash
terraform fmt
```
In the main.tf file, change the "Project ID" which is available in the projects dashboard.

Here we use terraform in conjunction with Google Cloud Platform.

## Google Cloud Platform

1. Create a free GCP account by providing the country and payment details.
2. Create a new project and also a service account for the same.
    * To create a service account go to IAM & Admin -> Service Accounts -> Create Service account.
    * Select the roles based on the permissions you want to give, for this use case we selected,
    Storage Admin(via Cloud Storage service), Big Query Admin, Compute Admin. We can use the filter to get these roles too. Save and continue
    * Now select manage keys, click add key and select create new key, json and save. A json file with the credentials for the service account is downloaded to your local machine. Be careful as it is confidential.

3. Also install the Google Cloud SDK on your local machine using the link [Google SDK](https://cloud.google.com/sdk/docs/quickstart
) and follow the prompts.

4. Now assign the GOOGLE_CREDENTIALS using the below command in bash.

```bash
export GOOGLE_CREDENTIALS="<path_to_credentials_file>"
```
To check if the value is set correctly, use the below command.

```bash
echo $GOOGLE_CREDENTIALS 
```

5. Now navigate to the folder that has the .tf file and run the command

```bash
terraform init
```

6. Once this runs, run the plan, apply command and a state file with all the bucket information is created. Then for the demo purposes you can now try destroy command and make sure the resources are all destroyed. Check that a backup state file is now created too. 

Plan shows how and what resources will be created using the file. Apply deploys the resources.Destroy deletes those resources.

```bash
terraform plan 

terraform apply

terraform destroy
```

7. While adding these terraform folders to GitHub make sure to include a .gitignore file to eliminate senstive information of your account. Additionally, add the .json to gitignore too to avoid uploading sensitive credential information.


## Terraform Variables

The variables allow you to define variables that are common to use such as location, project_name in a single file. Then assign them in the main file using the var. notation. 

Refer the variables.tf file for examples. We can even add files to the variables and refer them in main.tf using functions.











