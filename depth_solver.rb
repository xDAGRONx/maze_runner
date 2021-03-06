class DepthSolver < Solver
  private

  def solve
    build_path(maze.start, maze.finish)
  end

  def build_path(node, previous)
    solution << node.visit.dup unless node.visited?
    return true if node == maze.finish
    if next_node = unvisited_neighbors(node).sample
      if build_path(next_node, node)
        true
      else
        solution << next_node.dead_end
        build_path(node, previous)
      end
    end
  end
end
