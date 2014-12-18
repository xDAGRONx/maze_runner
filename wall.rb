class Wall
  def initialize
    @broken = false
    @visited = false
    @dead_end = false
  end

  def break
    @broken = true
  end

  def broken?
    @broken
  end

  def visit
    @visited = true
  end

  def visited?
    @visited
  end

  def dead_end
    @dead_end = true
  end

  def dead_end?
    @dead_end
  end

  def paint
    if broken?
      if visited?
        dead_end? ? Paint['  ', nil, :red] : Paint['  ', nil, :green]
      else
        '  '
      end
    else
      Paint['  ', nil, 46]
    end
  end
end
