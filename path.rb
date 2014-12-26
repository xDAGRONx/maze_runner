class Path
  attr_reader :nodes

  def initialize(nodes, *extras)
    @nodes = nodes + extras
  end

  def previous
    nodes[-2]
  end

  def last
    nodes.last
  end
end
