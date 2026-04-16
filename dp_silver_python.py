import dlt
import pyspark.sql.functions as F


@dlt.table(name="enrollments_silver")
def enrollments_silver():
    # Stammdaten aus dem Katalog laden (jetzt existiert sie dank dem Setup-Skript!)
    students_lookup_df = spark.table("workspace.default.students")

    return (
        dlt.read_stream("enrollments_bronze")
        .where("quantity > 0")
        .withColumn("processed_at", F.to_timestamp("timestamp"))
        .join(students_lookup_df, "student_id", "left")
        .select(
            "enroll_id",
            "student_id",
            "email",
            "gpa",
            "profile",
            "quantity",
            "courses",
            "processed_at",
        )
    )
