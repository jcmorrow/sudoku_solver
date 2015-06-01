require "set"
require "sudoku_puzzle"

describe SudokuPuzzle do
	describe 'retrieving spaces' do
		it "locates and returns spaces" do
			space = double("space", :letter => "A", :number => "1")
			allow(SudokuSpace).to receive(:new).and_return(space)

			puzzle = SudokuPuzzle.new(open_sudoku_puzzle('easy'))

			expect(puzzle.space("A1")).to eq(space)
		end
	end
	context "with an empty sudoku puzzle string" do
		let(:empty_sudoku) do
			<<SUD
0 0 0 |0 0 0 |0 0 0
0 0 0 |0 0 0 |0 0 0
0 0 0 |0 0 0 |0 0 0
------+------+-----
0 0 0 |0 0 0 |0 0 0
0 0 0 |0 0 0 |0 0 0
0 0 0 |0 0 0 |0 0 0
------+------+-----
0 0 0 |0 0 0 |0 0 0
0 0 0 |0 0 0 |0 0 0
0 0 0 |0 0 0 |0 0 0
SUD
		end
		describe '.units' do
			it "returns the correct units" do
				puzzle = SudokuPuzzle.new(empty_sudoku)
				expect(puzzle.peers("A1").collect { |unit| unit.coords }).to eq(["A2", "A3", "A4", "A5", "A6", "A7", "A8", "A9", "B1", "C1", "D1", "E1", "F1", "G1", "H1", "I1", "B2", "B3", "C2", "C3"])
			end
		end
		it "allows for assigning of values" do
			puzzle = SudokuPuzzle.new(empty_sudoku)
			expect(puzzle.assign("A1", 1)).to eq(true)
		end
		it "returns false when assigning an impossible value" do
			puzzle = SudokuPuzzle.new(empty_sudoku)
			puzzle.assign("A1", 1)
			expect(puzzle.assign("A2", 1)).to eq(false)
		end
	end
	it "prints out a puzzle with its possibilities" do
		puzzle = SudokuPuzzle.new(open_sudoku_puzzle('easy'))
		puts puzzle.spaces.map { |space| space.possibilities.inspect }
	end

	def open_sudoku_puzzle(file_name)
		File.read("spec/fixtures/" + file_name + ".sudoku")
	end
end