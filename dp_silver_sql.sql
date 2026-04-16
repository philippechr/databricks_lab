CREATE OR REFRESH STREAMING TABLE enrollments_silver_sql;

-- Qualitätsregel hinzufügen
ALTER TABLE LIVE.enrollments_silver_sql 
ADD CONSTRAINT valid_quantity EXPECT (quantity > 0) ON VIOLATION DROP ROW;

SET spark.sql.streaming.statefulOperator.checkCorrectness.enabled = false;

CREATE OR REFRESH STREAMING TABLE enrollments_silver_sql
AS SELECT 
  e.*,
  to_timestamp(e.timestamp) AS processed_at,
  s.email,
  s.gpa
FROM STREAM(LIVE.enrollments_bronze_sql) e
LEFT JOIN main.default.students s ON e.student_id = s.student_id;