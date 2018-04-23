require 'pry'

class Dog

  attr_accessor :id, :name, :breed

  def initialize(hash)
    hash.each {|key, value| self.send(("#{key}="), value)}
  end

  def self.create_table
   sql =  <<-SQL
     CREATE TABLE IF NOT EXISTS dogs (
       id INTEGER PRIMARY KEY,
       name TEXT,
       breed TEXT
       )
   SQL

   DB[:conn].execute(sql)
 end

 def self.drop_table
   sql = "DROP TABLE IF EXISTS dogs"
   DB[:conn].execute(sql)
 end

 def save
   if self.id
     self.update
   else
     sql = <<-SQL
     INSERT INTO dogs (name, breed)
     VALUES (?, ?)
     SQL

     DB[:conn].execute(sql, self.name, self.breed)
     @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
   end
   self
 end

 def self.create(hash)
   # dog = self.new
   # dog.save
   # dog
   new(hash).tap{ |h| h.save }
 end

 def self.find_by_id(id)
   sql = <<-SQL
   SELECT * 
   FROM dogs 
   WHERE id = ? 
   LIMIT 1
   SQL

DB[:conn].execute(sql, id).map do |row|
     self.new_from_db(row)
  end.first
  # binding.pry
end


end
