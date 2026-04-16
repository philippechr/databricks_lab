-- 1. Ziel-Tabelle für den aktuellen Studenten-Status deklarieren
CREATE OR REFRESH STREAMING TABLE students_silver_cdc;

-- 2. CDC-Logik anwenden
CREATE FLOW cdc_students_flow
AS AUTO CDC INTO LIVE.students_silver_cdc
FROM STREAM(workspace.default.students_raw_stream) -- Angenommen, hier kommen die Änderungen an
KEYS (student_id)
SEQUENCE BY timestamp -- Wichtig für die korrekte Reihenfolge bei Updates
COLUMNS *;