CREATE OR REFRESH STREAMING TABLE daily_student_courses_sql
COMMENT "Tägliche Aggregation für das Reporting"
AS SELECT
  student_id,
  email,
  date_trunc('DD', processed_at) AS day,
  sum(quantity) AS total_courses_enrolled
FROM STREAM(LIVE.enrollments_silver_sql)
GROUP BY student_id, email, day;