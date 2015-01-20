class BreadthSolver < Solver
  attr_reader :current_paths, :sub_paths

  def initialize(*args)
    @current_paths = []
    super
  end

  private

  def solve
    current_paths << Path.new([maze.start])
    build_path
  end

  def build_path
    visit_current_nodes

    if finale
      mark_final_dead_ends
      return true
    end

    evaluate_branches

    unless sub_paths.empty?
      @current_paths = sub_paths
      build_path
    end
  end

  def visit_current_nodes
    current_paths.each { |p| solution << p.last.visit.dup unless p.last.visited? }
  end

  def finale
    current_paths.find { |p| p.last == maze.finish }
  end

  def mark_final_dead_ends
    mark_dead_end(current_paths.flat_map(&:nodes) - finale.nodes)
  end

  def mark_dead_end(nodes)
    nodes.reverse_each { |n| solution << n.dead_end unless n.dead_end? }
  end

  def evaluate_branches
    @sub_paths = []
    current_paths.each do |current_path|
      if branches(current_path).empty?
        mark_dead_end(unique_nodes(current_path))
      else
        sub_paths.concat(branches(current_path))
      end
    end
  end

  def branches(path)
    unvisited_neighbors(path.last).map { |n| Path.new(path.nodes, n) }
  end

  def unique_nodes(path)
    path.nodes - other_paths(path).flat_map(&:nodes)
  end

  def other_paths(path)
    current_paths[current_paths.index(path) + 1..-1] + sub_paths
  end
end
