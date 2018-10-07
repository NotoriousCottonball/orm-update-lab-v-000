require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_reader :id 
  
  def initialize (name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end
  
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT);
    SQL
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    DB[:conn].execute("DROP TABLE students")
  end
  
  def save
    if !self.id
      sql = <<-SQL
        INSERT INTO students (name, grade) VALUES (?, ?)
        SQL
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end
  
  def self.create(name:, grade:)
    student = self.new(name, grade)
    student.save
    student
  end
  
  def self.new_from_db(row)
    self.new(id = row[0], name = row[1], grade = row[2])
  end
  


end
