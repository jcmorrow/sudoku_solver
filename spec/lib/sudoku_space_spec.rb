require "sudoku_space"

describe SudokuSpace do
	context "given a valid but unknown SudokuSpace" do
		subject { SudokuSpace.new('C4', '0') }
		describe '.initialize' do
			it 'assigns the correct letter and number values' do
				expect(subject.letter).to eq('C')
				expect(subject.number).to eq('4')
			end
			it 'assigns the correct value values' do
				expect(subject.value).to eq('0')
			end
			it 'make all numbers possibilities' do
				expect(subject.possibilities).to eq(%w[ 1 2 3 4 5 6 7 8 9 ].to_set)
			end
		end
		describe '.eliminate' do
			it 'eliminates a possibility.' do
				subject.eliminate('9')
				expect(subject.possibilities).to eq(%w[ 1 2 3 4 5 6 7 8 ].to_set)
			end
			it 'allows a non-present value to be passed to eliminate and does nothing' do
				subject.eliminate('9')
				subject.eliminate('9')
				expect(subject.possibilities).to eq(%w[ 1 2 3 4 5 6 7 8 ].to_set)
			end
			it 'raises a conflict when the only possibility left is eliminated' do
				subject.possibilities.delete_if { |pos| pos != '1' }
				expect {subject.eliminate('1') }.to raise_error
			end
		end
		describe '.known?' do
			it 'returns false for unknown values' do
				expect(subject.known?).to eq(false)
			end
		end
	end
	context "given a valid, known sudoku space" do
		subject { SudokuSpace.new('C4', 1) }
		describe '.known?' do
			it 'returns true for known values' do
				expect(subject.known?).to eq(true)
			end
		end
	end
end