class Builder
  attr_reader :maze, :show, :display_time
  alias_method :show?, :show

  def initialize(maze, show = false, display_time = 0.0005)
    @maze = maze
    @show = show
    @display_time = display_time
    @path = []
  end

  def path
    if @path.empty?
      @path << maze.entrance.path
      @path << maze.exit.path
      build_path(maze.start, maze.finish)
    end
    @path
  end

  def run
    draw(maze.entrance.path)
    draw(maze.exit.path)
    build(maze.start, maze.finish)
    unless show?
      maze.erase
      puts maze.paint
      sleep(display_time)
    end
  end

  private

  def build_path(node, previous)
    @path << node.path unless node.path?
    return true if node == maze.finish
    if next_node = unvisited_neighbors(node).sample
      @path << get_wall(node, next_node).path
      build_path(next_node, node)
      build_path(node, previous)
    end
  end

  def build(node, previous)
    draw(node.path) unless node.path?
    return true if node == maze.finish
    if next_node = unvisited_neighbors(node).sample
      draw(get_wall(node, next_node).path)
      build(next_node, node)
      build(node, previous)
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

  def draw(node)
    if show?
      node.draw(maze)
      sleep(display_time)
    end
  end
end
