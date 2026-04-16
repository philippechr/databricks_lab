import dlt
import pyspark.sql.functions as F
from pyspark.sql.functions import col


@dlt.table(name="enrollments_bronze")
def enrollments_bronze():
    return (
        spark.readStream.format("cloudFiles")
        .option("cloudFiles.format", "json")
        .option("cloudFiles.inferColumnTypes", "true")
        .load(
            "/Volumes/workspace/default/volume/enrollments_raw"
        )  # Echter Pfad aus dem Setup
        .select(
            "*",
            F.current_timestamp().alias("arrival_time"),
            col("_metadata.file_path").alias("source_file"),
        )
    )
