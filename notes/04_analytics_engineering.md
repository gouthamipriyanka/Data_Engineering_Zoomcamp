# Goal: Transforming the data loaded in DWH (Big Query) into Analytical Views developing a dbt project.


## What is dbt?
DBT is Data Build Tool that helps data analysts and engineers transform data in their warehouses more effectively. It allows you to write SQL, which is then compiled into the code that builds your data models. This code is then run against your data warehouse, and the results are stored in your warehouse as tables.

## Loading a dataset in Big Query from public data source. 

Explorer -> Search Bar -> Type BigQuery public datasets -> Go to Datasets in Cloud MarketplaceSelect or search the dataset.

## Creating a dataset in Big Query and loading the data into the required data tables.

1. Click on three dots beside the project name -> Create Dataset -> Enter the dataset name and select the region -> Click on Create Dataset.

    The dataset name here comes from the path 04-analytics-engineering/taxi_rides_ny/models/staging/schema.yml which is trips_data_all.

2. Create a table in the dataset. Click on the three dots beside the dataset name -> Create Table -> Enter the table name and select the schema -> Click on Create Table.

    The names are selected from the schema.yml as green_trip_data and yellow_trip_data for this project.

    Intially create the table using CTAS for loading the 2019 dataset and then insert the 2020 data into the same table.

3. SQLto create the table and load the data.

```sql
    CREATE TABLE `project_name.trips_data_all.green_tripdata` as
    SELECT * FROM `bigquery-public-data.new_york_taxi_trips. tlc_green_trips_2019` ;

    INSERT INTO `project_name.trips_data_all.green_tripdata`
    SELECT * FROM `bigquery-public-data.new_york_taxi_trips. tlc_green_trips_2020` ;
```

Similary do it for  the yellow_trips as well.

## dbt_cloud_setup

Create a developer account in the link [SignUp](https://www.getdbt.com/signup)








