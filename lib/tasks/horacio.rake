# frozen_string_literal: true

namespace :horacio do
  desc 'Import the tables and data from file'

  class_name = nil
  schema_name = 'horacio'

  # schema_name = nil
  class_name = ARGV[1] if ARGV.length > 1

  schema_name = "horacio_#{class_name}_students" if class_name

  db_path = "#{Rails.root}/db/TemplateDB.accde"
  linked_db_path = "#{Rails.root}/db/HoracioData.accdb"

  db = Mdb.open(db_path.to_s)
  linked_db = Mdb.open(linked_db_path.to_s)

  tables = db.tables
  linked_tables = linked_db.tables

  config = Rails.configuration.database_configuration

  # Import the tables
  task :import_tables, [:class_name] => [:environment] do |t, args|
    class_name = args[:class_name]
    schema_name = "horacio_#{class_name}_students" if class_name

    if schema_name
      conn = ActiveRecord::Base.connection
      unless conn.schema_exists? schema_name.to_s
        conn.create_schema(schema_name.to_s)
      end
      import_tables(tables, db_path, config, schema_name, conn)
      import_tables(linked_tables, linked_db_path, config, schema_name, conn)
    end
  end

  # Import the data into table
  task :import_data, [:class_name] => [:environment] do |t, args|
    class_name = args[:class_name]
    schema_name = "horacio_#{class_name}_students" if class_name
    
    if schema_name
      conn = ActiveRecord::Base.connection
      pg_conn = conn_postgres(config)
      if conn.schema_exists? schema_name.to_s
        save_data(conn, pg_conn, tables, db, schema_name)
        save_data(conn, pg_conn, linked_tables, linked_db, schema_name)
      end
     end
  end
end

# Save the data into table
def save_data(conn, pg_conn, tables, database, schema_name)
  tables.each do |t|
    schema_table = "#{schema_name}.#{t}"
    if conn.table_exists? schema_table.to_s
      conn.execute %(DELETE FROM "#{schema_name}"."#{t}")
      puts("Truncated the records of #{schema_table} successfully")

      records = database[t.to_s]

      records.each do |record|
        col_vals = []

        record.keys.each do |k|
          val = record[k]
          val = 'null' if val.nil? || val == ''
          col_vals.push(pg_conn.escape_string(val))
        end
        begin
          query = "INSERT INTO \"#{schema_name}\".\"#{t}\" VALUES ( #{col_vals.map { |m| m == 'null' ? '%s' : "'%s'" }.join(', ')} )"
          conn.execute query % col_vals
        rescue Exception => e
          puts e.message.to_s
        end
      end

      puts("Successfully saved the data of #{t}")

    end
  rescue Exception => e
    puts "#{t}, #{e.message}"
  end
end

# Connect to postgresql table
def conn_postgres(config)
  host = config[Rails.env]['host']
  database = config[Rails.env]['database']
  username = config[Rails.env]['username']
  password = config[Rails.env]['password']

  pg_conn = PG::Connection.new(host: host, port: 5432, dbname: database, user: username, password: password)

  pg_conn
end

# import tables
def import_tables(tables, database_path, config, schema_name, conn)
  username = config[Rails.env]['username']
  database = config[Rails.env]['database']

  tables.each do |t|
    unless conn.table_exists? t.to_s
      system("mdb-schema -T #{t} -N #{schema_name} #{database_path} postgres | psql -d #{database} -U #{username}")
    end
  rescue Exception => e
    puts t.to_s, e.message.to_s
  end
end
