-- Transformation und Join mit integrierter Qualitätsregel
CREATE OR REFRESH STREAMING TABLE enrollments_silver (
  CONSTRAINT valid_quantity EXPECT (quantity > 0) ON VIOLATION DROP ROW
)
COMMENT "Bereinigte Daten mit Qualitätsprüfung"
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