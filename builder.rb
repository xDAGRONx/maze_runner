class Builder
  attr_reader :maze, :path

  def self.path(maze)
    result = new(maze).run.path
    result.each { |n| yield n } if block_given?
    result
  end

  def initialize(maze)
    @maze = maze
    @path = []
  end

  def run
    unless built?
      path << maze.entrance.path
      path << maze.exit.path
      build_path(maze.start, maze.finish)
    end
    self
  end

  private

  def built?
    !path.empty?
  end

  def build_path(node, previous)
    path << node.path unless node.path?
    return true if node == maze.finish
    if next_node = unvisited_neighbors(node).sample
      path << get_wall(node, next_node).path
      build_path(next_node, node)
      build_path(node, previous)
    end
  end

  def unvisited_neighbors(node)
    neighbors(node).reject { |n| n.path? }
  end

  def neighbors(node)
    [
      maze.get_node(node.row - 2, node.column),
      maze.get_node(node.row + 2, node.column),
      maze.get_node(node.row, node.column - 2),
      maze.get_node(node.row, node.column + 2)
    ].compact
  end

  def get_wall(node, other_node)
    row = (node.row + other_node.row) / 2
    column = (node.column + other_node.column) / 2
    maze.get_node(row, column)
  end
end
