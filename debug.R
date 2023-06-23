library(heuristicsmineR)

# Parallelbeispiels in Patients
patients_sub <- patients |> 
  filter(patient %in% 1:3 & handling %in% c("Registration",
                                            "Blood test",
                                            "MRI SCAN")) |> 
  arrange(patient, time)

dependency_matrix(patients_sub, threshold = 0.1)


# Debug unserer Daten
eventlog_test_ind_dates_sub <- 
  eventlog_test_ind_dates |> 
  # Reduktion auf wenige Lehrerinnen
  filter(Dokumentname %in% c("Van", "Verena")) |> 
  # und Codes
  filter(code %in% c("RG", "HM")) |> 
  # subset innerhalb der Person
  group_by(Dokumentname) |> 
  arrange(timestamp) |> 
  slice_activities(1:3) |> # subset zu drei Zeilen pro Person
  ungroup() |> 
  eventlog(  # coercion to eventlog - Klasse geht bei slice verloren :-( 
    case_id = "Dokumentname",
    activity_id = "code",
    activity_instance_id = "activity_instance_id_by_bupar",
    lifecycle_id = "lifecycle_id",
    timestamp = "timestamp",
    resource_id = "test"
  )

# subsettete Rohdaten anschauen
eventlog_test_ind_dates_sub |> 
  group_by(Dokumentname) |> 
  arrange(timestamp) |> 
  ungroup()

# händisch auszählen ob übergänge stimmen
dependency_matrix(eventlog_test_ind_dates_sub, threshold = 0)
  
  
