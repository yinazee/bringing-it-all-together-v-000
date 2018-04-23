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

 def self.save
   if self.id
     self.update
   else
     sql = <<-SQL
     INSERT INTO dogs (name, breed)
     VALUES (?, ?)
     SQL
     DB[:conn].execute(sql, self.name, self.breed)
     @id = DB[:conn].execute("SELECT las_insert_rowid() FROM dogs").[0][0]
   end
   self
end
