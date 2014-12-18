class Node
  attr_reader :row, :column

  def initialize(row, column)
    @row = row
    @column = column
    @visited = false
    @used = false
    @dead_end = false
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

  def dead_end
    @dead_end = true
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
