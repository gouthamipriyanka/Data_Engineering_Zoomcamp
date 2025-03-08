# Workflow orchestration using Kestra

### Installing kestra using docker-compose

Go to the link https://kestra.io/docs/installation/docker-compose for the below command.

In the terminal navigate to the desired folder and execute the command to create a docker-compose.yaml file in the directory.

```powershell

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/kestra-io/kestra/develop/docker-compose.yml" -OutFile "docker-compose.yml"

```

Then run the commands

```bash
docker compose build
docker compose up
```

Once installed, for this project it is important we have the latest version of postgres. To check

```bash
docker-compose ps
docker exec -it <container_name> psql --version
```

Once the container starts, you can access the Kestra UI at http://localhost:8080.

***

Make sure you connect pg-admin and postgres to the same network or just copy the docker file as it is.

### Hands-On Coding Project: Build Data Pipelines with Kestra in local Postgres and GCP

The flows are present in the week 2 folder.


