CREATE OR REFRESH STREAMING TABLE enrollments_bronze
COMMENT "Rohdaten-Ingest via SQL Auto Loader aus dem Volume"
AS SELECT 
  *, 
  current_timestamp() AS arrival_time,
  _metadata.file_path AS source_file
FROM cloud_files("/Volumes/workspace/default/volume/enrollments_raw", "json", map("cloudFiles.inferColumnTypes", "true"));