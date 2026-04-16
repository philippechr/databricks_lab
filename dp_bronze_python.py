import dlt
from pyspark.sql.functions import current_timestamp, col


@dlt.table(
    name="enrollments_bronze",
    comment="Rohdaten aus dem Volume via Auto Loader aufgenommen.",
)
def enrollments_bronze():
    return (
        spark.readStream.format("cloudFiles")
        .option("cloudFiles.format", "json")
        .option("cloudFiles.inferColumnTypes", "true")
        .load("/Volumes/workspace/default/volume/")
        .select(
            "*",
            current_timestamp().alias("arrival_time"),
            col("_metadata.file_path").alias("source_file"),
        )
    )
