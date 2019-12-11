class Dog
  attr_accessor :id, :name, :breed

  def initialize(id: nil, name: nil, breed: nil)
    @id = id
    @name = name
    @breed = breed
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs(
    id INTEGER PRIMARY KEY,
    name TEXT,
    breed TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE IF EXISTS dogs
    SQL

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

  def self.create(name:, breed:)
    dog = self.new(name: name, breed: breed)
    dog.save
  end

  def self.new_from_db(row)
    dog = self.new(id: row[0], name: row[1],breed: row[2])
    dog
  end

  def update
  sql = "UPDATE dogs SET name = ?, breed = ? WHERE id = ?"
  DB[:conn].execute(sql, self.name, self.breed, self.id)
end

  def self.find_by_id(id)
    sql = <<-SQL
    SELECT * FROM dogs WHERE id = ?
    SQL
    DB[:conn].execute(sql,id).map {|row| Dog.new_from_db(row)}.first
  end

  def self.find_by_name(name)
  sql = <<-SQL
    SELECT * FROM dogs WHERE name = ?
    SQL
    DB[:conn].execute(sql,name).map { |row| Dog.new_from_db(row)}.first
  end

  def self.find_or_create_by(name:, breed:)


  end
end
