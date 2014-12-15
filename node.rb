class Node
  attr_reader :row, :column

  def initialize(row, column)
    @row = row
    @column = column
    @visited = false
    @used = false
  end

  def visit
    @visited = true
  end

  def visited?
    @visited
  end

  def use
    @used = true
  end

  def used?
    @used
  end

  def to_s
    visited? ? 'o' : ' '
  end
end
