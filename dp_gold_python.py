import dlt
from pyspark.sql.functions import date_trunc, sum


@dlt.table(
    name="daily_student_courses",
    comment="Aggregierte Übersicht der täglichen Einschreibungen pro Student.",
)
def daily_student_courses():
    return (
        dlt.read_stream("enrollments_silver")
        .withColumn("day", date_trunc("DD", "processed_at"))
        .groupBy("student_id", "email", "day")
        .agg(sum("quantity").alias("total_courses_enrolled"))
    )
