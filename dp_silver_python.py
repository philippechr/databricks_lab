import dlt
from pyspark.sql.functions import to_timestamp


@dlt.table(
    name="enrollments_silver",
    comment="Bereinigte und mit Studenten-Stammdaten angereicherte Daten.",
)
@dlt.expect_or_drop("valid_quantity", "quantity > 0")  # Datenqualitätsregel
def enrollments_silver():
    # Wir lesen den Bronze-Stream
    bronze_df = dlt.read_stream("enrollments_bronze")
    # Statische Tabelle für den Join (muss im Katalog existieren)
    students_df = spark.table("main.default.students")

    return (
        bronze_df.filter("quantity > 0")
        .withColumn("processed_at", to_timestamp("timestamp"))
        .join(students_df, "student_id", "left")
    )
