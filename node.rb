class Node
  attr_reader :row, :column

  def initialize(row, column)
    @row = row
    @column = column
    @visited = false
    @path = false
    @dead_end = false
  end

  def path
    @path = true
    self
  end

  def path?
    @path
  end

  def visit
    @visited = true
    self
  end

  def visited?
    @visited
  end

  def dead_end
    @dead_end = true
    self
  end

  def dead_end?
    @dead_end
  end

  def paint
    if visited?
      dead_end? ? Paint['  ', nil, :red] : Paint['  ', nil, :green]
    else
      '  '
    end
  end
end
