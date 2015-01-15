require 'paint'
require './node'
require './wall'
require './path'

class Maze
  attr_reader :height, :width

  def initialize(height, width)
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

  def get_node(row, column)
    return nil if row < 0 || column < 0
    @nodes[row][column] if row < @height && column < @width
  end

  def start
    @nodes[1][1]
  end

  def finish
    @nodes[-2][-2]
  end

  def entrance
    @nodes[0][1]
  end

  def exit
    @nodes[-1][-2]
  end
end
