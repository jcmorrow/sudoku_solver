require "set"
require "sudoku_puzzle"

describe SudokuPuzzle do
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

		it 'initializes and prints out a puzzle' do
			puzzle = SudokuPuzzle.new(open_sudoku_puzzle('easy'))
			puts puzzle.present
		end
	end

	def open_sudoku_puzzle(file_name)
		File.read("spec/fixtures/" + file_name + ".sudoku")
	end
end