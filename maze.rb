require 'paint'
require './node'
require './wall'
require './path'

class Maze
  attr_reader :height, :width

  def initialize(height, width, display_time = 0.0005)
    @display_time = display_time
    @height = height.even? ? height + 1 : height
    @width = width.even? ? width + 1 : width
    @nodes = @height.times.map do |row|
      if row.even?
        Array.new(@width) { |column| Wall.new(row, column) }
      else
        @width.times.map do |column|
          column.even? ? Wall.new(row, column) : Node.new(row, column)
        end
      end
    end
    puts self.paint
  end

  def paint
    @nodes.each_with_object('') do |row, result|
      row.each { |node| result << node.paint }
      result << "\n"
    end
  end

  def erase
    print "\r" + ("\e[A" * height) + "\e[J"
  end

  def make
    draw(@nodes[0][1].path)
    draw(@nodes[-1][-2].path)
    make_path(@nodes[1][1], @nodes[-2][-2])
    self
  end

  def solve
    draw(@nodes[0][1].visit)
    solve_path(@nodes[1][1], @nodes[-2][-2])
    # breadth_solve_path([Path.new([@nodes[1][1]])])
    draw(@nodes[-1][-2].visit)
    self
  end

  private

  def make_path(node, previous)
    draw(node.path) unless node.path?
    return true if last_node?(node)
    next_node = neighbors(node).reject { |n| n.path? }.sample
    if next_node
      draw(get_wall(node, next_node).path)
      make_path(next_node, node)
      make_path(node, previous)
    end
  end

  def breadth_solve_path(paths)
    paths.each { |p| draw(p.last.visit) unless p.last.visited? }
    return true if paths.any? { |p| last_node?(p.last) }

    sub_paths = paths.flat_map do |path|
      neighbors(path.last).reject do |n|
        n.visited? || !get_wall(path.last, n).path?
      end .map do |n|
        Path.new(path.nodes, n)
      end
    end

    unless sub_paths.empty?
      sub_paths.each { |p| draw(get_wall(p.last, p.previous).visit) }
      breadth_solve_path(sub_paths)
    end
  end

  def solve_path(node, previous)
    draw(node.visit) unless node.visited?
    return true if last_node?(node)
    next_node = neighbors(node).reject do |n|
      n.visited? || !get_wall(node, n).path?
    end .sample
    if next_node
      draw(get_wall(node, next_node).visit)
      if solve_path(next_node, node)
        true
      else
        draw(get_wall(node, next_node).dead_end)
        draw(next_node.dead_end)
        solve_path(node, previous)
      end
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

  def draw(node)
    print "\r"
    print "\e[A" * (height - node.row)
    print "\e[C" * 2 * node.column
    print node.paint
    print "\e[B" * (height - node.row)
    print "\r"
    sleep(@display_time)
  end

  def show_step
    puts self.paint
    sleep(0.09)
    print "\r" + ("\e[A" * height) + "\e[J"
  end
end
