class SudokuSolver

  def initialize(puzzle)
    @puzzle = puzzle
  end

  def self.solve(puzzle)
    new(puzzle).solve
  end

  def solve
    #make sure we have unknown spaces
    if (@puzzle.spaces.select { |space| space.known? == false } .length) > 0
      while(spaces_found)
        spaces_found = false
        @puzzle.spaces.select { |space| space.known? == false } .each do |space|
          possibilities = eliminate_possibilities(space)
          if possibilities.length == 1
            spaces_found = true
            space.value = (possibilities.to_a)[0]
          end
        end
      end
      return @puzzle.present
    end
  end

  def eliminate_possibilities(space)
    #start with one through nine. Remove some.
    possibilities = (1..9).to_a.to_set
    impossible_values = @puzzle.row(space.y_coord).to_set + @puzzle.column(space.x_coord).to_set + @puzzle.section((space.y_coord/3).floor, (space.x_coord/3).floor).to_set
    return possibilities - impossible_values
  end
end
