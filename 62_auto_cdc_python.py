import dlt


@dlt.view  # Wir definieren die Quelle oft als View
def students_source():
    return spark.readStream.table("workspace.default.students_updates")


dlt.create_streaming_table("students_silver_cdc")

dlt.apply_changes(
    target="students_silver_cdc",
    source="students_source",
    keys=["student_id"],
    sequence_by="timestamp",  # Zeitstempel der Änderung
    apply_as_deletes="operation = 'DELETE'",  # Optional: Behandelt Löschungen
    stored_as_scd_type=1,  # Typ 1 = Überschreiben (aktueller Stand)
)
