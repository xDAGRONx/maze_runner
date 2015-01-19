class Solver
  attr_reader :maze, :solution

  def self.solution(maze)
    result = new(maze).run.solution
    result.each { |n| yield n } if block_given?
    result
  end

  def initialize(maze)
    @maze = maze
    @solution = []
  end

  def run
    unless solved?
      solution << maze.entrance.visit
      solve
      solution << maze.exit.visit
    end
    self
  end

  private

  def solved?
    !solution.empty?
  end

  def unvisited_neighbors(node)
    neighbors(node).select { |n| n.path? && !n.visited? }
  end

  def neighbors(node)
    [
      maze.get_node(node.row - 1, node.column),
      maze.get_node(node.row + 1, node.column),
      maze.get_node(node.row, node.column - 1),
      maze.get_node(node.row, node.column + 1)
    ].compact
  end
end
