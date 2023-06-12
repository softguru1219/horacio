# README

## Run Horacio Web application
1. Run the task to import the data from access file
  - rake db:reset
  - rake horacio:import_tables[bijouterie]
  - rake horacio:import_data[bijouterie]
  - rake db:migrate
2. Run the Rails app
  - Used the tables to show the exams from db.
    1. tblRéservationsDétails
    2. tblCompilationHeures and tblCompilationHeuresModules