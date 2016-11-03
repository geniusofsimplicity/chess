require "knight.rb"

describe Knight do
	describe "#valid_move?"	do
		let(:knight_w){ Knight.new("white") }
		let(:knight_b){ Knight.new("black") }
		let(:knight){ [knight_w, knight_b].sample }
		let(:move_from){ [rand(4) + 2, ("c".."f").to_a.sample] }
		let(:board) do
			board = Board.new
			board.instance_variable_set(:@board, {})		
			board.send(:add_chessman, move_from, knight)
			board
		end
		let(:board_values){ board.instance_variable_get(:@board) }
		let(:move_to_valid) do
			pool_of_moves = [1, 2].shuffle
			rank_move = pool_of_moves.pop * [-1, 1].sample
			file_move = pool_of_moves.pop * [-1, 1].sample			
			move_to = [move_from[0] + rank_move, (move_from[1].ord + file_move).chr]			
			move_to
		end
		context "performing validly" do			
			it {	expect(knight.valid_move?(move_from, move_to_valid, board_values)).to be_truthy }			
		end

		context "performing invalidly" do
			let(:move_to_invalid_1) do
				move_to = []
				move_to[0] = move_to_valid[0] > move_from[0] ? move_to_valid[0] - rand(2) - 1 : move_to_valid[0] + rand(2) + 1
				move_to[1] = move_to_valid[1] > move_from[1] ? (move_to_valid[1].ord - rand(2) - 1).chr : (move_to_valid[1].ord + rand(2) + 1).chr
				move_to
			end
			let(:move_to_invalid_2) do
				move_to = []
				move_to[0] = ((0..7).to_a - [move_from[0] - 1, move_from[0] - 2, move_from[0] + 1, move_from[0] + 2]).sample
				move_to[1] = (("a".."h").to_a - [(move_from[1].ord - 1).chr, (move_from[1].ord - 2).chr, (move_from[1].ord + 1).chr, (move_from[1].ord + 2).chr]).sample				
				move_to
			end
			it {	expect(knight.valid_move?(move_from, move_to_invalid_1, board_values)).to be_falsey }

			it { expect(knight.valid_move?(move_from, move_to_invalid_2, board_values)).to be_falsey }
		end
	end
	
end