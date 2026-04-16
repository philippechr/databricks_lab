CREATE OR REFRESH STREAMING TABLE enrollments_silver;

-- Qualitätsregel: Datensätze mit quantity <= 0 werden verworfen
ALTER TABLE LIVE.enrollments_silver 
ADD CONSTRAINT valid_quantity EXPECT (quantity > 0) ON VIOLATION DROP ROW;

-- Transformation und Join
CREATE OR REFRESH STREAMING TABLE enrollments_silver
AS SELECT 
  e.enroll_id,
  e.student_id,
  s.email,
  s.gpa,
  s.profile,
  e.quantity,
  e.courses,
  to_timestamp(e.timestamp) AS processed_at
FROM STREAM(LIVE.enrollments_bronze) e
LEFT JOIN workspace.default.students s ON e.student_id = s.student_id;