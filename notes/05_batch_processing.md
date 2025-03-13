## Apache Spark using PySpark

Processing data - two types

1. Batch
2. Stream

Batch jobs process data weekly, daily, hourly (3 times per hour)

Technologies: Python scripts, SQL, Spark, Flink.

Workflow: DataLake -> Python -> SQL(dbt) -> Spark -> Python

Advantages of Batch Jobs:
1. Easy to manage
2. Workflow has a parameter that is executed for a particular time interval, so we can retry of something fails. Not happening in real time so easy to maintain.
3. Scaling 

Disadvantage:
1. Delay to get data and workflow execution.

Mostly it is 80% batch and 20% streaming in real time.

Apache Spark is a clustered based distributed processing engine which takes the data from your data lake, processes it and pushes it into a data warehouse or other storage spaces.

Available in Java, Scala, Python and R. Can be used for both batch and streaming data.

### When to use Spark?

When the data is in datalake (s3/GCS), process it in spark, and push it back into sql.

Usually Spark takes from a data lake and pushes it back to the data lake, if it is a data warehouse we can use SQL, but data lakes contain both structured and unstructured data.

HIVE, PRESTO/AWS ATHENA can be used to work with data in data lakes.

If we can express our batch job as SQL go with it using the above.But usually in ML , training and testing models cannot be expressed using SQL.

### Installing Spark on a VM in Google Cloud Platform

1. Create a VM and install JVM using the below link from the website

### Installing Java

Download OpenJDK 11 or Oracle JDK 11 (It's important that the version is 11 - spark requires 8 or 11)

We'll use [OpenJDK](https://jdk.java.net/archive/)

Download it (e.g. to `~/spark`):

```
wget https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz
```

Unpack it:

```bash
tar xzfv openjdk-11.0.2_linux-x64_bin.tar.gz
```

define `JAVA_HOME` and add it to `PATH`:

```bash
export JAVA_HOME="${HOME}/spark/jdk-11.0.2"
export PATH="${JAVA_HOME}/bin:${PATH}"
```

check that it works:

```bash
java --version
```

Output:

```
openjdk 11.0.2 2019-01-15
OpenJDK Runtime Environment 18.9 (build 11.0.2+9)
OpenJDK 64-Bit Server VM 18.9 (build 11.0.2+9, mixed mode)
```

Remove the archive:

```bash
rm openjdk-11.0.2_linux-x64_bin.tar.gz
```

### Installing Spark


Download Spark. Use 3.3.2 version:

```bash
wget https://archive.apache.org/dist/spark/spark-3.3.2/spark-3.3.2-bin-hadoop3.tgz
```

Unpack:

```bash
tar xzfv spark-3.3.2-bin-hadoop3.tgz
```

Remove the archive:

```bash
rm spark-3.3.2-bin-hadoop3.tgz
```

Add it to `PATH`:

```bash
export SPARK_HOME="${HOME}/spark/spark-3.3.2-bin-hadoop3"
export PATH="${SPARK_HOME}/bin:${PATH}"
```

### Testing Spark

Execute `spark-shell` and run the following:

```scala
val data = 1 to 10000
val distData = sc.parallelize(data)
distData.filter(_ < 10).collect()
```

### PySpark

It's the same for all platforms. Go to [pyspark.md](pyspark.md). 

Create a new folder notebooks and create a jupyter notebook.

If Pyspark is not recongnized in the jupyter notebook, add the paths in the notebook and then try.

```python
import os
os.environ["JAVA_HOME"]="${HOME}/spark/jdk-11.0.2"
os.environ["PATH"]="${JAVA_HOME}/bin:${PATH}"
```

Port forwarding when using Linux in a VM:

8080 - Jupyter notebook
4040 - Spark jobs




