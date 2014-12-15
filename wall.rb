class Wall
  def initialize
    @broken = false
    @visited = false
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

  def to_s
    if broken?
      visited? ? 'o' : ' '
    else
      'W'
    end
  end
end
