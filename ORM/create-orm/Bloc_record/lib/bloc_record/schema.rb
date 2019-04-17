require 'sqlite3'
require 'bloc_record/utility'

module Schema
  # Call table on an object to retrieve its SQL table name.
  def table
    BlocRecord::Utility.underscore(name)
  end

  # Call schema to iterate through the columns in a database table.
  def schema
    unless @schema
      @schema = {}
      connection.table_info(table) do |col|
        @schema[col["name"]] = col["type"]
      end
    end
    @schema
  end  

  # Return the column names of a table.
  def columns
    schema.keys
  end

  # Return the column names with exceptions.
  def attributes
    columns - ["id"]
  end

  # Return a count of records in a table.
  def count
    connection.execute(<<-SQL)[0][0]
      SELECT COUNT(*) FROM #{table}
    SQL
  end  
end