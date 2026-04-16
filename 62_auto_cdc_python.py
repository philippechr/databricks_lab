import dlt


# 1. Die Quelle als View definieren
@dlt.view
def students_source_view():  # Name der Funktion ist wichtig
    return spark.readStream.table("workspace.default.students_updates")


# 2. Die Zieltabelle deklarieren
dlt.create_streaming_table("students_silver_cdc")

# 3. Änderungen anwenden
dlt.apply_changes(
    target="students_silver_cdc",
    source="students_source_view",  # Hier den Namen der obigen Funktion nutzen
    keys=["student_id"],
    sequence_by="sequence_id",
    apply_as_deletes="operation = 'DELETE'",
    stored_as_scd_type=1,  # SCD Type 1 = Überschreiben (aktueller Stand)
)
