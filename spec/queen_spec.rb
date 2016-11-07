require "queen.rb"
require "pawn.rb"

describe Queen do
	describe "#valid_move?"	do
		context "moving like a bishop" do
			let(:queen_w){ Queen.new("white") }
			let(:queen_b){ Queen.new("black") }
			let(:queen){ [queen_w, queen_b].sample }
			let(:move_from){ [rand(8), ("a".."h").to_a.sample] }
			let(:board) do
				board = Board.new
				board.instance_variable_set(:@board, {})		
				board.send(:add_chessman, move_from, queen)
				board
			end			
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

				it { expect(queen.valid_move?(move_from, move_to_valid, board)).to be_truthy }
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

				it { expect(queen.valid_move?(move_from, move_to_invalid, board)).to be_falsey }

				it "leaping over" do
					expect(queen.valid_move?(move_from, move_to_valid_1, board_with_leap)).to be_falsey				
				end
			end
		end

		context "moving like a rook" do
			let(:queen_w){ Queen.new("white") }
			let(:queen_b){ Queen.new("black") }
			let(:queen){ [queen_b, queen_w].sample }

			let(:move_from){ [rand(2) + 3, ["d", "e"].sample] }
			let(:board) do
				board = Board.new
				board.instance_variable_set(:@board, {})		
				board.send(:add_chessman, move_from, queen)
				board
			end

			context "performing validly" do
				let(:move_in_rank_up_to){ [ rand(2) + 6, move_from[1]] }
				let(:move_in_rank_down_to){ [ rand(3), move_from[1]] }
				let(:move_in_file_left_to){ [ move_from[0], (97 + rand(3)).chr] }
				let(:move_in_file_right_to){ [ move_from[0], (97 + rand(3) + 5).chr] }

				it "a rank move up" do				
					expect(queen.valid_move?(move_from, move_in_rank_up_to, board)).to be_truthy
				end
				it "a rank move down" do				
					expect(queen.valid_move?(move_from, move_in_rank_down_to, board)).to be_truthy
				end
				it "a file move to the left" do				
					expect(queen.valid_move?(move_from, move_in_file_left_to, board)).to be_truthy
				end
				it "a file move to the right" do				
					expect(queen.valid_move?(move_from, move_in_file_right_to, board)).to be_truthy
				end
			end

			context "performing invalidly" do
				let(:move_in_rank_up_to){ [ rand(2) + 6, move_from[1]] }
				let(:move_in_rank_down_to){ [ rand(2), move_from[1]] }
				let(:move_in_file_left_to){ [ move_from[0], (97 + rand(2)).chr] }
				let(:move_in_file_right_to){ [ move_from[0], (97 + rand(2) + 6).chr] } # landing on g or h
				let(:board_leap_rank_up) do
					board = Board.new
					board.instance_variable_set(:@board, {})		
					board.send(:add_chessman, [ move_in_rank_up_to[0] - 1, move_in_rank_up_to[1]], Pawn.new(["black", "white"].sample))
					board
				end
				let(:board_leap_rank_down) do
					board = Board.new
					board.instance_variable_set(:@board, {})		
					board.send(:add_chessman, [ move_in_rank_down_to[0] + 1, move_in_rank_down_to[1]], Pawn.new(["black", "white"].sample))
					board
				end
				let(:board_leap_file_left) do
					board = Board.new
					board.instance_variable_set(:@board, {})		
					board.send(:add_chessman, [ move_in_file_left_to[0], (move_in_file_left_to[1].ord + 1).chr], Pawn.new(["black", "white"].sample))
					board
				end
				let(:board_leap_file_right) do
					board = Board.new
					board.instance_variable_set(:@board, {})		
					board.send(:add_chessman, [ move_in_file_right_to[0], (move_in_file_right_to[1].ord - 1).chr], Pawn.new(["black", "white"].sample))
					board
				end

				it "a leaping rank move up" do				
					expect(queen.valid_move?(move_from, move_in_rank_up_to, board_leap_rank_up)).to be_falsey
				end
				it "a leaping rank move down" do				
					expect(queen.valid_move?(move_from, move_in_rank_down_to, board_leap_rank_down)).to be_falsey
				end
				it "a file move to the left" do				
					expect(queen.valid_move?(move_from, move_in_file_left_to, board_leap_file_left)).to be_falsey
				end
				it "a file move to the right" do				
					expect(queen.valid_move?(move_from, move_in_file_right_to, board_leap_file_right)).to be_falsey
				end
			end

		end
	end
end