-- 1. Zieltabelle definieren (Diese wird am Ende im Catalog sichtbar sein)
CREATE OR REFRESH STREAMING TABLE students_silver_cdc
COMMENT "Aktuelle Studenten-Stammdaten, gepflegt via CDC";

-- 2. CDC-Flow definieren
-- Wir nutzen hier AUTO CDC (das moderne Synonym für APPLY CHANGES)
CREATE FLOW students_cdc_flow
AS AUTO CDC INTO LIVE.students_silver_cdc
FROM STREAM(workspace.default.students_updates) -- Deine externe Quelle aus dem Setup
KEYS (student_id)                               -- Der Primärschlüssel für den Abgleich
APPLY AS DELETE WHEN operation = 'DELETE'        -- Logik für Löschungen
SEQUENCE BY sequence_id                         -- Verhindert Fehler durch falsche Reihenfolge
COLUMNS * EXCEPT (operation, sequence_id);      -- Wir lassen technische Spalten im Ziel weg