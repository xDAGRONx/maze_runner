require 'optparse'
require './maze'

module MazeRunner
  class << self
    attr_accessor :options
  end

  @options = {
    height: 25,
    width: 40,
    display_time: 0.005,
    iterations: Float::INFINITY
  }

  def self.parse(args)
    option_parser.parse!(args)
  end

  def self.maze
    Maze.new(options[:height], options[:width], options[:display_time])
  end

  def self.run
    puts
    (0...options[:iterations]).each do
      m = maze.make.solve
      sleep(2)
      m.erase
    end

    puts "Hope you enjoyed the show!"
  end

  private

  def self.option_parser
    OptionParser.new do |opts|
      opts.banner = "Usage: ruby maze_runner.rb [options]"

      opts.separator ''
      opts.separator 'Specific options:'

      opts.on('-h', '--height HEIGHT', Integer, 'Height of the maze') do |h|
        options[:height] = h
      end

      opts.on('-w', '--width WIDTH', Integer, 'Width of the maze') do |w|
        options[:width] = w
      end

      opts.on('-d', '--display-time N', Float,
        'Display each step N seconds') do |n|
          options[:display_time] = n
        end

      opts.on('-i', '--iterations N', Integer, 'Display N mazes') do |n|
        options[:iterations] = n
      end

      opts.on_tail('--help', "Show this message") do
        puts opts
        exit
      end
    end
  end
end

if __FILE__ == $0
  MazeRunner.parse(ARGV)
  MazeRunner.run
end
