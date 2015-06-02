class SudokuSpace
	attr_reader :letter, :number
	attr_accessor :value, :possibilities

	def initialize(identity, value)
		@letter = identity[0]
		@number = identity[1]
		if(value != "0")
			@value = value.to_s
			@possibilities = Set.new([ value.to_s ])
		else
			@value = "0"
			@possibilities = Set.new(%w[ 1 2 3 4 5 6 7 8 9 ])
		end
	end

	def known?
		unless value == '0'
			return true
		else
			return false
		end
	end

	def coords
		"#{letter}#{number}"
	end

end