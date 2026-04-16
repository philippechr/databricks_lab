CREATE OR REFRESH STREAMING TABLE enrollments_bronze_sql
COMMENT "Rohdaten Ingest via SQL Auto Loader"
AS SELECT 
  *, 
  current_timestamp() AS arrival_time,
  _metadata.file_path AS source_file
FROM cloud_files("/Volumes/workspace/default/volume/", "json", map("cloudFiles.inferColumnTypes", "true"));