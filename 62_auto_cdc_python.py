import dlt


@dlt.view
def students_source():
    # Stelle sicher, dass dieser Pfad exakt so existiert
    return spark.readStream.table("workspace.default.students_updates")


dlt.create_streaming_table("students_silver_cdc")

dlt.apply_changes(
    target="students_silver_cdc",
    source="students_source",
    keys=["student_id"],
    sequence_by="sequence_id",  # Muss mit der Spalte im Setup oben übereinstimmen
    apply_as_deletes="operation = 'DELETE'",
    stored_as_scd_type=1,
)
