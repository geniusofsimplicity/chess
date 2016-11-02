require "rook.rb"
require "pawn.rb"

describe Rook do
	describe "#valid_move?"	do
		let(:rook_w){ Rook.new("white") }
		let(:rook_b){ Rook.new("black") }
		let(:rook){ [rook_b, rook_w].sample }

		let(:move_from){ [rand(2) + 3, ["d", "e"].sample] }
		let(:board) do
			board = Board.new
			board.instance_variable_set(:@board, {})		
			board.send(:add_chessman, move_from, rook)
			board
		end
		let(:board_values){ board.instance_variable_get(:@board) }

		context "performing validly" do
			let(:move_in_rank_up_to){ [ rand(2) + 6, move_from[1]] }
			let(:move_in_rank_down_to){ [ rand(3), move_from[1]] }
			let(:move_in_file_left_to){ [ move_from[0], (97 + rand(3)).chr] }
			let(:move_in_file_right_to){ [ move_from[0], (97 + rand(3) + 5).chr] }

			it "a rank move up" do				
				expect(rook.valid_move?(move_from, move_in_rank_up_to, board_values)).to be_truthy
			end
			it "a rank move down" do				
				expect(rook.valid_move?(move_from, move_in_rank_down_to, board_values)).to be_truthy
			end
			it "a file move to the left" do				
				expect(rook.valid_move?(move_from, move_in_file_left_to, board_values)).to be_truthy
			end
			it "a file move to the right" do				
				expect(rook.valid_move?(move_from, move_in_file_right_to, board_values)).to be_truthy
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
			let(:board_value_leap_rank_up){ board_leap_rank_up.instance_variable_get(:@board) }
			let(:board_leap_rank_down) do
				board = Board.new
				board.instance_variable_set(:@board, {})		
				board.send(:add_chessman, [ move_in_rank_down_to[0] + 1, move_in_rank_down_to[1]], Pawn.new(["black", "white"].sample))
				board
			end
			let(:board_value_leap_rank_down){ board_leap_rank_down.instance_variable_get(:@board) }
			let(:board_leap_file_left) do
				board = Board.new
				board.instance_variable_set(:@board, {})		
				board.send(:add_chessman, [ move_in_file_left_to[0], (move_in_file_left_to[1].ord + 1).chr], Pawn.new(["black", "white"].sample))
				board
			end
			let(:board_value_leap_file_left){ board_leap_file_left.instance_variable_get(:@board) }
			let(:board_leap_file_right) do
				board = Board.new
				board.instance_variable_set(:@board, {})		
				board.send(:add_chessman, [ move_in_file_right_to[0], (move_in_file_right_to[1].ord - 1).chr], Pawn.new(["black", "white"].sample))
				board
			end
			let(:board_value_leap_file_right){ board_leap_file_right.instance_variable_get(:@board) }

			it "a leaping rank move up" do				
				expect(rook.valid_move?(move_from, move_in_rank_up_to, board_value_leap_rank_up)).to be_falsey
			end
			it "a leaping rank move down" do				
				expect(rook.valid_move?(move_from, move_in_rank_down_to, board_value_leap_rank_down)).to be_falsey
			end
			it "a file move to the left" do				
				expect(rook.valid_move?(move_from, move_in_file_left_to, board_value_leap_file_left)).to be_falsey
			end
			it "a file move to the right" do				
				expect(rook.valid_move?(move_from, move_in_file_right_to, board_value_leap_file_right)).to be_falsey
			end
		end
	end	
end