require "sudoku_space"

describe SudokuSpace do
	context "given a valid but unknown SudokuSpace" do
		subject { SudokuSpace.new('C4', 0) }
		describe '.initialize' do
			it 'assigns the correct x and y values' do
				expect(subject.letter).to eq('C')
				expect(subject.number).to eq('4')
				expect(subject.value).to eq('0')
			end
		end
		describe '.known?' do
			it 'returns false for unknown values' do
				expect(subject.known?).to eq(false)
			end
		end
	end
	context "given a valid, known sudoku space" do
		subject { SudokuSpace.new('C4', '1') }
		describe '.known?' do
			it 'returns true for known values' do
				expect(subject.known?).to eq(true)
			end
		end
	end
end