import dlt
import pyspark.sql.functions as F


@dlt.table(name="daily_student_courses")
def daily_student_courses():
    return (
        dlt.read_stream("enrollments_silver")
        .withColumn("day", F.date_trunc("DD", "processed_at"))
        .groupBy("student_id", "email", "day")
        .agg(F.sum("quantity").alias("total_courses_enrolled"))
    )
