require 'optparse'
require 'highline/system_extensions'
require './maze'
require './builder'
require './solver'
require './depth_solver'

module MazeRunner
  @done = false

  def self.options
    @options ||= {
      height: terminal_height - 4,
      width: terminal_width / 2 - 2,
      display_time: 0.005,
      show_make: false,
      iterations: Float::INFINITY
    }
  end

  def self.parse(args)
    option_parser.parse!(args)
  end

  def self.maze
    Maze.new(options[:height], options[:width],
      options[:display_time], options[:show_make])
  end

  def self.run
    puts
    graceful_exit
    (0...options[:iterations]).each do
      m = maze
      Builder.path(m) do |n|
        n.draw(m)
        sleep(options[:display_time]) if options[:show_make]
      end
      DepthSolver.solution(m) do |n|
        n.draw(m)
        sleep(options[:display_time])
      end
      sleep(2)
      m.erase
      break if done?
    end

    puts "Hope you enjoyed the show!"
  end

  def self.done?
    @done
  end

  private

  def self.terminal_width
    HighLine::SystemExtensions.terminal_size.first
  end

  def self.terminal_height
    HighLine::SystemExtensions.terminal_size.last
  end

  def self.graceful_exit
    trap('INT') { done? ? exit : @done = true }
  end

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

      opts.on('-s', '--[no-]show-make', 'Display steps to create maze') do |m|
        options[:show_make] = m
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
