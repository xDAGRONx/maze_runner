class BreadthSolver < Solver
  attr_reader :current_paths

  def initialize(*args)
    @current_paths = []
    super
  end

  def solve
    current_paths << Path.new([maze.start])
    build_path
  end

  private

  def build_path
    current_paths.each { |p| solution << p.last.visit.dup unless p.last.visited? }
    if finale
      mark_final_dead_ends
      return true
    end

    sub_paths = []
    current_paths.each_with_index do |current_path, i|
      if branches(current_path).empty?
        current_paths.values_at(0...i, (i + 1)..-1).each do |p|
          current_path.nodes -= p.nodes
        end
        current_path.nodes.reverse.each do |n|
          solution << n.dead_end unless n.dead_end?
        end
      else
        sub_paths.concat(branches(current_path))
      end
    end

    unless sub_paths.empty?
      @current_paths = sub_paths
      build_path
    end
  end

  def finale
    current_paths.find { |p| p.last == maze.finish }
  end

  def mark_final_dead_ends
    (current_paths.flat_map(&:nodes) - finale.nodes).reverse.each do |n|
      solution << n.dead_end unless n.dead_end?
    end
  end

  def branches(path)
    unvisited_neighbors(path.last).map do |n|
      Path.new(path.nodes, n)
    end
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
