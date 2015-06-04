require 'sudoku_puzzle'

class SudokuSolver

  def initialize(puzzle_string)
    @puzzle = SudokuPuzzle.new(puzzle_string)
  end

  def self.solve(puzzle_string)
    new(puzzle_string).solve
  end
=begin
      solve
        propogate constraints of current knowns
        solved?
          yes => great, return it
          no => OK, copy, guess, solve.
        invalid?
          yes => ok, return false
          no => ok, guess, solve.
=end  
  def solve(puzzle = @puzzle)
    #make sure we have unknown spaces
    puts "SOLVE CALLED"
    puzzle.propogate_constraints
    puts puzzle.present
    if puzzle.solved?
      puts "SOLVED"
      return puzzle
    elsif puzzle.invalid?
      puts "INVALID"
      return false
    else
      puts "PUZZLE NOT SOLVED AND PUZZLE NOT INVALID"
      new_copy = copy(puzzle)
      puts new_copy.present

      unknown = new_copy.spaces.select { |space| !space.known? }
      space_to_guess = unknown.sort { |a, b| a.possibilities.size <=> b.possibilities.size } [0]
      puts "#{space_to_guess}"
      guess = space_to_guess.possibilities.to_a[0]
      puts "Assigning #{guess} to #{space_to_guess.coords}"
      new_copy.assign(space_to_guess, guess)
      puts new_copy.present
      if(solve(new_copy))
        return new_copy
      else
        puts "eliminating #{guess} from #{space_to_guess.coords}"
        puzzle.eliminate(puzzle.get_space(space_to_guess.coords), guess)
        puzzle.propogate_constraints
        solve(puzzle)
      end
    end
  end

  def copy(puzzle)
    return SudokuPuzzle.new(puzzle.present)
  end
  def present
    return @puzzle.present
  end
end
