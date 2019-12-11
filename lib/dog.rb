class Dog
  attr_accessor :id, :name, :breed

  def initialize(id: nil, name: nil, breed: nil)
    @id = id
    @name = name
    @breed = breed
  end

  def create_table
    sql = <<- SQL
    CREATE TABLE IF NOT EXISTS dogs(
    id INTEGER PRIMARY KEY,
    name TEXT,
    breed TEXT
    )
    SQL
  end
end
