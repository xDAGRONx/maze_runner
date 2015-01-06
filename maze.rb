require 'paint'
require './node'
require './wall'
require './path'

class Maze
  attr_reader :height, :width

  def initialize(height, width, display_time = 0.0005, show_make = false)
    @display_time = display_time
    @show_make = show_make
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
    draw_make(@nodes[0][1].path)
    draw_make(@nodes[-1][-2].path)
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
    draw_make(node.path) unless node.path?
    return true if last_node?(node)
    next_node = neighbors(node).reject { |n| n.path? }.sample
    if next_node
      draw_make(get_wall(node, next_node).path)
      make_path(next_node, node)
      make_path(node, previous)
    end
  end

  def breadth_solve_path(paths)
    paths.each { |p| draw(p.last.visit) unless p.last.visited? }
    if finale = paths.find { |p| last_node?(p.last) }
      dead_nodes = (paths.flat_map(&:nodes) - finale.nodes)
      dead_nodes.concat(dead_nodes.flat_map { |n| open_walls(n) })
      dead_nodes.shuffle.each do |n|
        draw(n.dead_end) unless n.dead_end?
      end
      return true
    end

    sub_paths = []
    paths.each_with_index do |path, i|
      branches = neighbors(path.last).reject do |n|
        n.visited? || !get_wall(path.last, n).path?
      end .map { |n| Path.new(path.nodes, n) }

      if branches.empty?
        paths.values_at(0...i, (i + 1)..-1).each do |p|
          path.nodes -= p.nodes
        end
        (path.nodes + path.nodes.flat_map { |n| open_walls(n) })
          .shuffle.each do |n|
            draw(n.dead_end) unless n.dead_end?
          end
      else
        sub_paths.concat(branches)
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

  def open_walls(node)
    [
      get_node(node.row - 1, node.column),
      get_node(node.row + 1, node.column),
      get_node(node.row, node.column - 1),
      get_node(node.row, node.column + 1)
    ].compact.select { |w| w.path? }
  end

  def get_wall(node, other_node)
    row = (node.row + other_node.row) / 2
    column = (node.column + other_node.column) / 2
    @nodes[row][column]
  end

  def draw_make(node)
    @show_make ? draw(node) : quick_draw(node)
  end

  def quick_draw(node)
    node.draw(self)
  end

  def draw(node)
    quick_draw(node)
    sleep(@display_time)
  end

  def show_step
    puts self.paint
    sleep(0.09)
    print "\r" + ("\e[A" * height) + "\e[J"
  end
end
