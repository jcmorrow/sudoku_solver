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
		ROWS.each do |letter|	
			COLUMNS.each do |number|
				@spaces.push(SudokuSpace.new("#{letter}#{number}", value_string.pop))
			end
		end
		#NO
		#@spaces.select { |space| space.known? } .each do |space|
		#	assign(space, space.value)
		#end
	end
	def get_space(coords)
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
		if (!solved?) && (space.possibilities.include?(value))
			%W[ 1 2 3 4 5 6 7 8 9 ].select { |p| p != value } .each do |poss|
				space.possibilities.delete poss
			end
			space.value = value
			return propogate_constraints
		else
			return true
		end
	end
	def propogate_constraints
		spaces.select { |space| space.known? }.each do |space|
			peers(space).each do |peer|
				if eliminate(peer, space.value)
					next
				else
					return false 
				end
			end
		end
		return true
	end
	def eliminate(space, possibility)
		unless space.possibilities.length == 1 && space.possibilities.to_a[0] == possibility
			space.possibilities.delete possibility
		else
			return false
		end
		if space.possibilities.size == 1 && space.value == '0'
			"assigning #{space.possibilities.to_a()[0]} to #{space}"
			assign(space, space.possibilities.to_a()[0])
		end
		return true
	end
	def present item = :value
		puzzle_string = ""
		ROWS.each do |row|
			if (row == 'D' || row == 'G')
				puzzle_string << "------+------+------\n"
			end
			COLUMNS.each do |column|
				if (column == '4' || column == '7')
					puzzle_string << '|'
				end
				if(self.get_space("#{row}#{column}").send(item).respond_to? :each)
					puzzle_string << self.get_space("#{row}#{column}").send(item).count.to_s
				else
					puzzle_string << self.get_space("#{row}#{column}").send(item).to_s
				end
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
	def search
		puts "SEARCH CALLED"
		if solved?
			puts "SEARCH RETURNING SOLVED"
			return self
		elsif invalid?
			puts "SEARCH RETURNING FALSE"
			return false
		else
			copy = self.copy_puzzle
			unknown_spaces = copy.spaces.select { |space| !space.known? }
			fewest_possibilities = unknown_spaces.sort { |a, b| a.possibilities.count <=> b.possibilities.count} [0]
			guessed_space = fewest_possibilities
			guess = fewest_possibilities.possibilities.to_a[0]
			puts "Trying #{guess} in #{guessed_space}"
			copy.assign(fewest_possibilities, fewest_possibilities.possibilities.to_a[0])
			puts "SEARCH going on"
			if(copy.search)
				puts "solved?"
			else
				puts "eliminating #{guess} from #{guessed_space}"
				eliminate(get_space(guessed_space.coords), guess)
				search
			end
		end
	end
	def solved?
		if (spaces.select { |space| !space.known? } .length == 0 && !invalid? )
			return true
		else
			return false
		end
	end
	def invalid?
		spaces.each do |space|
			units(space).each do |unit|
				%w[ 1 2 3 4 5 6 7 8 9 ].each do |number|
					if(unit.to_a.map(&:value).count(number) > 1)
						return true
					end
				end
			end
		end
		return false
	end
	def copy_puzzle
		return SudokuPuzzle.new(present)
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