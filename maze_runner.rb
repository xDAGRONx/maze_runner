require './maze'

if __FILE__ == $0
  height = (ARGV[0] || 25).to_i
  width = (ARGV[1] || 40).to_i
  display_time = (ARGV[2] || 0.005).to_f
  loops = ARGV[3] ? ARGV[3].to_i : Float::INFINITY

  puts
  (0...loops).each do
    m = Maze.new(height, width, display_time).make.solve
    sleep(2)
    m.erase
  end

  puts "Hope you enjoyed the show!"
end
