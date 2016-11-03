require "bishop.rb"
require "pawn.rb"

describe Bishop do
	describe "#valid_move?"	do
		let(:bishop_w){ Bishop.new("white") }
		let(:bishop_b){ Bishop.new("black") }
		let(:bishop){ [bishop_w, bishop_b].sample }
		let(:move_from){ [rand(8), ("a".."h").to_a.sample] }
		let(:board) do
			board = Board.new
			board.instance_variable_set(:@board, {})		
			board.send(:add_chessman, move_from, bishop)
			board
		end
		let(:board_values){ board.instance_variable_get(:@board) }
		def get_valid_move(squares)
			#north-east
			direction1 = [7 - move_from[0], "h".ord - move_from[1].ord].min

			#north-west
			direction2 = [7 - move_from[0], move_from[1].ord - "a".ord].min

			#south-east
			direction3 = [move_from[0], "h".ord - move_from[1].ord].min

			#south-west
			direction4 = [move_from[0], move_from[1].ord - "a".ord].min

			direction = []
			direction << 1 if direction1 > squares
			direction << 2 if direction2 > squares
			direction << 3 if direction3 > squares
			direction << 4 if direction4 > squares			

			choice = direction.sample

			case choice
			when 1 #north-east
				n = rand(direction1 - squares) + squares
				move_to = [move_from[0] + n + 1, (move_from[1].ord + n + 1).chr]
			when 2 #north-west
				n = rand(direction2 - squares) + squares
				move_to = [move_from[0] + n + 1, (move_from[1].ord - n - 1).chr]
			when 3 #south-east
				n = rand(direction3 - squares) + squares		
				move_to = [move_from[0] - n - 1, (move_from[1].ord + n + 1).chr]
			when 4 #south-west
				n = rand(direction4 - squares) + squares		
				move_to = [move_from[0] - n - 1, (move_from[1].ord - n - 1).chr]
			end
			move_to
		end		
		
		context "performing validly" do			
			let(:move_to_valid) do			
				get_valid_move(0)
			end

			it { expect(bishop.valid_move?(move_from, move_to_valid, board_values)).to be_truthy }
		end

		context "performing invalidly" do
			let(:move_to_invalid) do
				move_to = []
				move_to[0] = ((0..7).to_a - [move_from[0]]).sample
				n = (move_from[0] - move_to[0]).abs
				move_to[1] = (("a".."h").to_a - [move_from[1], (move_from[1].ord - n).chr, (move_from[1].ord + n).chr]).sample
				move_to
			end
			let(:move_to_valid_1) do			
				get_valid_move(1)
			end
			let(:board_with_leap) do
				board = Board.new
				board.instance_variable_set(:@board, {})
				in_between = (move_from[0] - move_to_valid_1[0]).abs
				rank_sign = move_to_valid_1[0] <=> move_from[0]
				file_sign = move_to_valid_1[1] <=> move_from[1]
				moves = rand(in_between - 1) + 1
				move_n_rank = moves * rank_sign				
				move_n_file = moves * file_sign				
				rank_min = [move_from[0], move_to_valid_1[0]].min
				file_min = [move_from[1], move_to_valid_1[1]].min
				pawn_rank = move_from[0] + move_n_rank
				pawn_file = (move_from[1].ord + move_n_file).chr				
				pawn_position = [pawn_rank, pawn_file]
				board.send(:add_chessman, pawn_position, Pawn.new(["white", "black"].sample))
				board
			end
			let(:board_values_leap){ board_with_leap.instance_variable_get(:@board) }
			it { expect(bishop.valid_move?(move_from, move_to_invalid, board_values)).to be_falsey }

			it "leaping over" do
				expect(bishop.valid_move?(move_from, move_to_valid_1, board_values_leap)).to be_falsey				
			end
		end

	end
	
end