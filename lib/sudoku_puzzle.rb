require_relative 'sudoku_space'

class SudokuPuzzle
	attr_reader :spaces

	COLUMNS = %w[ 1 2 3 4 5 6 7 8 9 ]
	ROWS = %w[ A B C D E F G H I]

	#PUZZLE FOR REFERENCE:
	#
=begin
		1 2 3  4 5 6  7 8 9

	A	3 0 6 |0 1 5 |0 0 0
	B	0 0 4 |0 0 0 |3 0 0
	C	0 0 0 |0 6 8 |1 9 4
		------+------+------
	D	0 8 0 |0 0 6 |0 0 0
	E	0 0 0 |2 4 9 |6 0 1
	F	6 4 0 |0 0 0 |2 0 5
		------+------+------
	G	0 0 8 |0 0 3 |0 1 0
	H	0 3 7 |8 9 1 |4 6 2
	I	0 2 0 |6 0 0 |8 0 0
=end
	#
	def initialize(puzzle_string)
		# remove everything that isn't a number, split it into an array, and
		# return the integer format of everything that's left
		@spaces = []
		value_string = puzzle_string.gsub(/[^\d]/, '').split(//).reverse
		ROWS.each do |letter|	
			COLUMNS.each do |number|
				@spaces.push(SudokuSpace.new("#{letter}#{number}", value_string.pop))
			end
		end
		@spaces.select { |space| space.value != 0 } .each do |space|
			peers(space.coords).each do |peer|
				eliminate(peer.coords, space.value.to_s)
			end
		end
	end
	def space(coords)
		#called with things like "A1", "D5", etc.
		return spaces.select { |space| space.letter == coords[0] && space.number == coords[1] } .pop
	end
	def units(coords)
		given_space = space(coords)

		units_composition = [ (row(given_space.letter).to_set.delete(given_space)),
				  			  (column(given_space.number).to_set.delete given_space),
				  			  (box(given_space).to_set.delete given_space)]
		return units_composition
	end
	def peers(coords)
		peers_composition = Set.new()
		units(coords).each do |unit|
			peers_composition = peers_composition.merge unit
		end
		return peers_composition
	end

	def assign(coords, value)
		#if we can safely eliminate this value from all peers
		#of the coordinate, then do so and assign it.

		#check all peers to make sure their value is not the one we are eliminating
		peers(coords).each do |peer|
			if peer.value == value
				return false
			end
		end
		peers(coords).each do |peer|
			eliminate(peer.coords, value)
		end
		space(coords).possibilities = [value].to_set
		space(coords).value = value
		return true
	end
	def eliminate(coords, value)
		space(coords).possibilities.delete value
		if(space(coords).possibilities.count == 1)
			space(coords).value = space(coords).possibilities.to_a[0]
		end
	end

	def present
		puzzle_string = ""
		COLUMNS.each do |column|
			if (column == 3 || column == 6)
				puzzle_string << "------+------+------\n"
			end
			ROWS.each do |row|
				if (row == 3 || row == 6)
					puzzle_string << '|'
				end
				puzzle_string << self.space("#{row}#{column}").value.to_s
				unless(row == 8)
					puzzle_string  << " "
				end
			end
			unless column == 8
				puzzle_string << "\n"
			end
		end
		return puzzle_string
	end

	private

	def row(letter)
		return spaces.select { |space| space.letter == letter }
	end
	def column(number)
		return spaces.select { |space| space.number == number }
	end
	def box(space)
		#upper_left_corner = "#{COLUMNS[(COLUMNS.index(space.number) / 3).floor]}#{ROWS[(ROWS.index(space.letter) / 3).floor]}"
		numbers = COLUMNS.slice((COLUMNS.index(space.number) / 3).floor, 3)
		letters = ROWS.slice((ROWS.index(space.letter) / 3).floor, 3)

		return spaces.select { |space| (numbers.include? space.number) && (letters.include? space.letter) }
	end
end