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
		@spaces = []
		value_string = puzzle_string.gsub(/[^\d]/, '').split(//).reverse
		puts value_string
		ROWS.each do |letter|	
			COLUMNS.each do |number|
				@spaces.push(SudokuSpace.new("#{letter}#{number}", value_string.pop))
			end
		end
		@spaces.select { |space| space.known? } .each do |space|
			assign(space, space.value)
		end
	end
	def at_space(coords)
		#called with things like "A1", "D5", etc.
		return spaces.select { |space| space.letter == coords[0] && space.number == coords[1] } .pop
	end
	def units(space)
		units_composition = [ (row(space.letter).to_set.delete(space)),
				  			  (column(space.number).to_set.delete space),
				  			  (box(space).to_set.delete space)]
		return units_composition
	end
	def peers(space)
		peers_composition = Set.new()
		units(space).each do |unit|
			peers_composition = peers_composition.merge unit
		end
		return peers_composition
	end
	def assign(space, value)
		puts "assign called on #{space.coords} to #{value}"
		unless solved?
			%W[ 1 2 3 4 5 6 7 8 9 ].select { |p| p != value } .each do |poss|
				space.possibilities.delete poss
			end
			space.value = value
			peers(space).each do |peer|
				eliminate(peer, value)
			end
			return true
		end
	end
	def eliminate(space, possibility)
		puts "eliminate called on #{space.coords}"
		unless space.possibilities.length == 1 && space.possibilities.to_a[0] == possibility
			space.possibilities.delete possibility
		else
			raise "Conflict: Cannot eliminate #{possibility} from #{space.coords}"
		end
		if space.possibilities.size == 1 && space.value == '0'
			puts "assigning #{space.possibilities.to_a()[0]} to #{space.coords}"
			assign(space, space.possibilities.to_a()[0])
		end
		return true
	end
	def present
		puzzle_string = ""
		ROWS.each do |row|
			if (row == 'D' || row == 'G')
				puzzle_string << "------+------+------\n"
			end
			COLUMNS.each do |column|
				if (column == '4' || column == '7')
					puzzle_string << '|'
				end
				puzzle_string << self.at_space("#{row}#{column}").value.to_s
				unless(column == 8)
					puzzle_string  << " "
				end
			end
			unless row == 8
				puzzle_string << "\n"
			end
		end
		return puzzle_string
	end
	def solved?
		if (spaces.select { |space| !space.known? } .length == 0 )
			return true
		else
			return false
		end
	end

	private

	def row(letter)
		return spaces.select { |space| space.letter == letter }
	end

	def column(number)
		return spaces.select { |space| space.number == number }
	end

	def box(space)
		numbers = COLUMNS.slice(((COLUMNS.index(space.number) / 3).floor)*3, 3)
		letters = ROWS.slice(((ROWS.index(space.letter) / 3).floor)*3, 3)

		return spaces.select { |space| (numbers.include? space.number) && (letters.include? space.letter) }
	end

end