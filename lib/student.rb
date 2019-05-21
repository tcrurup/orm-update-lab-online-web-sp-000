require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade
  attr_reader :id 
  
  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end
  
  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO students(name, grade)
        VALUES(?, ?)
        SQL
      DB[:conn].execute(sql, self.name, self.grade)
    
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end
  
  def update
    sql = <<-SQL
      UPDATE students
      SET name = ?, grade = ?
      WHERE students.id = ?
      SQL
      
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
  
  def self.create(name, grade)
    student = Student.new(name, grade).tap{ |x| x.save }
  end
  
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students(
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      )
      SQL
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
      SQL
    DB[:conn].execute(sql)
  end
  
<<<<<<< HEAD
  def self.find_by_name(name)
    sql = <<-SQL 
      SELECT * 
      FROM students
      WHERE students.name = ?
      SQL
      
    DB[:conn].execute(sql, name).map do |student| 
      Student.new_from_db(student)
    end.first
  end
  
  def self.new_from_db(row)
    self.new(row[1], row[2], row[0])
=======
  def self.new_from_db(row)
    student = self.new.tap do |x|
      x.id = row[0]
      x.name = row[1]
      x.grade = row[3]
    end
>>>>>>> 7137c2636dc1b537dfb134b3571299d70c8795b5
  end


end
