require "sudoku_solver"

describe SudokuSolver do
=begin
  describe '.eliminate_possibilities' do
    it "returns an array" do
      puzzle = double("puzzle")
      allow(puzzle).to receive(:row).and_return([])
      allow(puzzle).to receive(:column).and_return([])
      allow(puzzle).to receive(:section).and_return([])


      expect(SudokuSolver.new(puzzle).eliminate_possibilities(SudokuSpace.new(0,0,0))).to eq((1..9).to_set)
    end
    it "correctly subtracts impossible values via row" do
      puzzle = double("puzzle")
      allow(puzzle).to receive(:row).and_return([1,5,9])
      allow(puzzle).to receive(:column).and_return([])
      allow(puzzle).to receive(:section).and_return([])

      expect(SudokuSolver.new(puzzle).eliminate_possibilities(SudokuSpace.new(0,0,0))).to eq([2,3,4,6,7,8].to_set)
    end
    it "correctly subtracts impossible values via column" do
      puzzle = double("puzzle")
      allow(puzzle).to receive(:row).and_return([])
      allow(puzzle).to receive(:column).and_return([2,4,6])
      allow(puzzle).to receive(:section).and_return([])

      expect(SudokuSolver.new(puzzle).eliminate_possibilities(SudokuSpace.new(0,0,0))).to eq([1,3,5,7,8,9].to_set)
    end
    it "correctly subtracts impossible values via section" do
      puzzle = double("puzzle")
      allow(puzzle).to receive(:row).and_return([])
      allow(puzzle).to receive(:column).and_return([])
      allow(puzzle).to receive(:section).and_return([3,7,8])

      expect(SudokuSolver.new(puzzle).eliminate_possibilities(SudokuSpace.new(0,0,0))).to eq([1,2,4,5,6,9].to_set)
    end
    it "correctly determines the value when there is only one possibility" do
      puzzle = SudokuPuzzle.new(open_sudoku_puzzle("easy"))

      solver = SudokuSolver.new(puzzle)
      expect(solver.eliminate_possibilities(puzzle.space(0,7))).to eq([5].to_set)
    end
  end

  describe ".solve" do
    it "solves an easy puzzle" do
      puzzle = open_sudoku_puzzle("easy")

      expect(SudokuSolver.solve(SudokuPuzzle.new(puzzle))).to eq(easy_solution)
    end


    it "solves an hard puzzle" do
      puzzle = open_sudoku_puzzle("hard")

      expect(SudokuSolver.solve(SudokuPuzzle.new(puzzle))).to eq(hard_solution)
    end

    def easy_solution
      <<EOS.sub(/\s+$/, "")
3 9 6 |4 1 5 |7 2 8
8 1 4 |9 7 2 |3 5 6
2 7 5 |3 6 8 |1 9 4
------+------+------
1 8 2 |5 3 6 |9 4 7
7 5 3 |2 4 9 |6 8 1
6 4 9 |1 8 7 |2 3 5
------+------+------
4 6 8 |7 2 3 |5 1 9
5 3 7 |8 9 1 |4 6 2
9 2 1 |6 5 4 |8 7 3
EOS
    end

    def hard_solution
      <<EOS.sub(/\s+$/, "")
4 1 7 |3 6 9 |8 2 5
6 3 2 |1 5 8 |9 4 7
9 5 8 |7 2 4 |3 1 6
------+------+------
8 2 5 |4 3 7 |1 6 9
7 9 1 |5 8 6 |4 3 2
3 4 6 |9 1 2 |7 5 8
------+------+------
2 8 9 |6 4 3 |5 7 1
5 7 3 |2 9 1 |6 8 4
1 6 4 |8 7 5 |2 9 3
EOS
    end
  end
=end

  it 'does some things' do
    puts SudokuSolver.solve(open_sudoku_puzzle('easy')).present
    puts SudokuSolver.solve(open_sudoku_puzzle('hard')).present
  end

  def open_sudoku_puzzle(file_name)
    File.read("spec/fixtures/" + file_name + ".sudoku")
  end
end
