## Question 1. Understanding docker first run 

Run docker with the `python:3.12.8` image in an interactive mode, use the entrypoint `bash`.

What's the version of `pip` in the image?

- 24.3.1
- 24.2.1
- 23.3.1
- 23.2.1

### Solution:

Since, the python image is readily available in docker hub, we can directly use it instead of creating a custom image.

```bash
docker run -it --entrypoint bash python:3.12.8
```
Once you are in the bash shell, check for the pip version using the below command.

```bash
pip --version
```

Output: pip 24.3.1 from /usr/local/lib/python3.12/site-packages/pip (python 3.12)

Answer:
```
24.3.1
```

## Question 2. Understanding Docker networking and docker-compose

Given the following `docker-compose.yaml`, what is the `hostname` and `port` that **pgadmin** should use to connect to the postgres database?

```yaml
services:
  db:
    container_name: postgres
    image: postgres:17-alpine
    environment:
      POSTGRES_USER: 'postgres'
      POSTGRES_PASSWORD: 'postgres'
      POSTGRES_DB: 'ny_taxi'
    ports:
      - '5433:5432'
    volumes:
      - vol-pgdata:/var/lib/postgresql/data

  pgadmin:
    container_name: pgadmin
    image: dpage/pgadmin4:latest
    environment:
      PGADMIN_DEFAULT_EMAIL: "pgadmin@pgadmin.com"
      PGADMIN_DEFAULT_PASSWORD: "pgadmin"
    ports:
      - "8080:80"
    volumes:
      - vol-pgadmin_data:/var/lib/pgadmin  

volumes:
  vol-pgdata:
    name: vol-pgdata
  vol-pgadmin_data:
    name: vol-pgadmin_data
```

- postgres:5433
- localhost:5432
- db:5433
- postgres:5432
- db:5432

### Solution:

The docker-compose file has "db" as the service name for the postgres and port as 5432. 

```
db:5432
```
## Question 3. Trip Segmentation Count

During the period of October 1st 2019 (inclusive) and November 1st 2019 (exclusive), how many trips, **respectively**, happened:
1. Up to 1 mile
2. In between 1 (exclusive) and 3 miles (inclusive),
3. In between 3 (exclusive) and 7 miles (inclusive),
4. In between 7 (exclusive) and 10 miles (inclusive),
5. Over 10 miles 

Answers:

- 104,802;  197,670;  110,612;  27,831;  35,281
- 104,802;  198,924;  109,603;  27,678;  35,189
- 104,793;  201,407;  110,612;  27,831;  35,281
- 104,793;  202,661;  109,603;  27,678;  35,189
- 104,838;  199,013;  109,645;  27,688;  35,202

```sql
SELECT 
    CASE 
        WHEN trip_distance <= 1 THEN 'Up to 1 mile'
        WHEN trip_distance > 1 AND trip_distance <= 3 THEN '1 to 3 miles'
        WHEN trip_distance > 3 AND trip_distance <= 7 THEN '3 to 7 miles'
        WHEN trip_distance > 7 AND trip_distance <= 10 THEN '7 to 10 miles'
        ELSE 'Over 10 miles'
    END AS distance_range,
    COUNT(*) AS trip_count
FROM green_trip_data
WHERE lpep_pickup_datetime >= '2019-10-01'
  AND lpep_pickup_datetime < '2019-11-01'
GROUP BY distance_range
ORDER BY trip_count DESC;

```
Answer

```
104,838;  199,013;  109,645;  27,688;  35,202
```
## Question 4. Longest trip for each day

Which was the pick up day with the longest trip distance?
Use the pick up time for your calculations.

Tip: For every day, we only care about one single trip with the longest distance. 

- 2019-10-11
- 2019-10-24
- 2019-10-26
- 2019-10-31

### Solution

``` sql
SELECT 
    lpep_pickup_datetime::date AS pickup_date, 
    MAX(trip_distance) AS max_trip_distance
FROM green_trip_data
GROUP BY pickup_date
ORDER BY max_trip_distance DESC
LIMIT 1;
```
Answer:

```
2019-10-31
```

## Question 5. Three biggest pickup zones

Which were the top pickup locations with over 13,000 in
`total_amount` (across all trips) for 2019-10-18?

Consider only `lpep_pickup_datetime` when filtering by date.
 
- East Harlem North, East Harlem South, Morningside Heights
- East Harlem North, Morningside Heights
- Morningside Heights, Astoria Park, East Harlem South
- Bedford, East Harlem North, Astoria Park

```sql

SELECT "PULocationID", SUM(total_amount) AS total_amount_sum
FROM public.green_trip_data
WHERE lpep_pickup_datetime::date = '2019-10-18'
GROUP BY "PULocationID"
HAVING SUM(total_amount) > 13000
ORDER BY total_amount_sum DESC
LIMIT 3;

```
Answer:

```
East Harlem North, East Harlem South, Morningside Heights
```

## Question 6. Largest tip

For the passengers picked up in October 2019 in the zone
named "East Harlem North" which was the drop off zone that had
the largest tip?

Note: it's `tip` , not `trip`

We need the name of the zone, not the ID.

- Yorkville West
- JFK Airport
- East Harlem North
- East Harlem South

```sql
SELECT 
	t."PULocationID" as pickup_id,
    z."Zone" AS dropoff_zone,
    MAX(t.tip_amount) AS tip
FROM "green_trip_data" t
JOIN "taxi_zones" z ON t."DOLocationID" = z."LocationID"
WHERE t."lpep_pickup_datetime" >= '2019-10-01' 
  AND t."lpep_pickup_datetime" < '2019-11-01'
  AND t."PULocationID" = (SELECT "LocationID" FROM "taxi_zones" WHERE "Zone" = 'East Harlem North')
GROUP BY dropoff_zone,pickup_id 
ORDER BY tip DESC
LIMIT 1;
```
Answer

```
JFK Airport
```

## Terraform

In this section homework we'll prepare the environment by creating resources in GCP with Terraform.

In your VM on GCP/Laptop/GitHub Codespace install Terraform. 
Copy the files from the course repo
[here](../../../01-docker-terraform/1_terraform_gcp/terraform) to your VM/Laptop/GitHub Codespace.

Modify the files as necessary to create a GCP Bucket and Big Query Dataset.


## Question 7. Terraform Workflow

Which of the following sequences, **respectively**, describes the workflow for: 
1. Downloading the provider plugins and setting up backend,
2. Generating proposed changes and auto-executing the plan
3. Remove all resources managed by terraform`

Answers:
- terraform import, terraform apply -y, terraform destroy
- teraform init, terraform plan -auto-apply, terraform rm
- terraform init, terraform run -auto-approve, terraform destroy
- terraform init, terraform apply -auto-approve, terraform destroy
- terraform import, terraform apply -y, terraform rm

Answer
```
terraform init, terraform apply -auto-approve, terraform destroy

```
