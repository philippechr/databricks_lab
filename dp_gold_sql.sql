CREATE OR REFRESH STREAMING TABLE daily_student_courses
COMMENT "Tägliche Aggregation der Einschreibungen pro Student"
AS SELECT
  student_id,
  email,
  date_trunc('DD', processed_at) AS day,
  sum(quantity) AS total_courses_enrolled
FROM STREAM(LIVE.enrollments_silver)
GROUP BY student_id, email, day;