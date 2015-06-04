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
		let(:invalid_sudoku) do

			<<SUD
4 1 7 |3 6 9 |8 2 5 
8 3 5 |1 2 9 |6 4 7 
6 9 2 |7 4 8 |3 1 2 
------+------+------
9 2 1 |4 3 7 |5 6 8 
7 5 6 |9 8 2 |4 3 3 
3 4 8 |5 1 6 |7 9 2 
------+------+------
2 8 9 |6 5 3 |1 7 4 
5 6 3 |2 7 4 |9 8 1 
1 7 4 |8 9 5 |3 2 6
SUD
		end

		it 'initializes and prints out a puzzle' do
			#puzzle = SudokuPuzzle.new(open_sudoku_puzzle('hard'))
			#puts puzzle.present
			puzzle = SudokuPuzzle.new(empty_sudoku)
			puts puzzle.assign(puzzle.get_space("A1"), "3")
			puts puzzle.present
		end
	end

	def open_sudoku_puzzle(file_name)
		File.read("spec/fixtures/" + file_name + ".sudoku")
	end
end