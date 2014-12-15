require './node'
require './wall'

class Maze
  attr_reader :height, :width

  def initialize(height, width)
    @height = height.even? ? height + 1 : height
    @width = width.even? ? width + 1 : width
    @nodes = @height.times.map do |row|
      if row.even?
        Array.new(@width) { Wall.new }
      else
        @width.times.map do |column|
          column.even? ? Wall.new : Node.new(row, column)
        end
      end
    end
  end

  def to_s
    @nodes.each_with_object('') do |row, result|
      row.each { |node| result << " #{node}" }
      result << "\n"
    end
  end

  def make
    @nodes[0][1].break
    @nodes[-1][-2].break
    make_path(@nodes[1][1], @nodes[-2][-2])
    self
  end

  def solve
    solve_path(@nodes[1][1], @nodes[-2][-2])
    self
  end

  private

  def make_path(node, previous)
    node.use
    return true if last_node?(node)
    next_node = neighbors(node).select { |n| !n.used? }.sample
    if next_node
      puts `clear`
      puts self
      sleep(0.1)
      get_wall(node, next_node).break
      make_path(next_node, node)
      make_path(node, previous)
    end
  end

  def solve_path(node, previous)
    node.visit
    return true if last_node?(node)
    next_node = neighbors(node).reject do |n|
      n.visited? || !get_wall(node, n).broken?
    end .sample
    if next_node
      puts `clear`
      puts self
      sleep(0.1)
      get_wall(node, next_node).visit
      solve_path(next_node, node) || solve_path(node, previous)
    end
  end

  def neighbors(node)
    [
      get_node(node.row - 2, node.column),
      get_node(node.row + 2, node.column),
      get_node(node.row, node.column - 2),
      get_node(node.row, node.column + 2)
    ].compact
  end

  def last_node?(node)
    node.row == @height - 2 && node.column == @width - 2
  end

  def get_node(row, column)
    return nil if row < 0 || column < 0
    @nodes[row][column] if row < @height && column < @width
  end

  def get_wall(node, other_node)
    row = (node.row + other_node.row) / 2
    column = (node.column + other_node.column) / 2
    @nodes[row][column]
  end
end

m = Maze.new(50, 70).make.solve
puts
puts '=' * (m.width * 2)
puts
puts m
