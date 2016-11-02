# require "pawn.rb"
require "chess.rb"

describe Pawn do
	describe "#valid_move?"	do
		let(:pawn_w){ Pawn.new("white") }
		let(:pawn_b){ Pawn.new("black") }

		context "for white pawn" do
			let(:move_from){ [1, "f"] }
			let(:board) do
				board = Board.new
				board.instance_variable_set(:@board, {})		
				board.send(:add_chessman, move_from, pawn_w)
				board
			end
			let(:board_values){ board.instance_variable_get(:@board) }
			context "performing validly" do			
				let(:move_to){ [2, "f"] }
				let(:move_to_special){ [3, "f"] }	
				let(:pos_b_1){ [2, "e"] }			
				let(:pos_b_2){ [2, "g"] }
				let(:move_to_capture_b_1){ [2, "e"] }	
				let(:move_to_capture_b_2){ [2, "g"] }	
				let(:board_w_1) do
					board = Board.new
					board.instance_variable_set(:@board, {})		
					board.send(:add_chessman, pos_b_1, pawn_b)
					board
				end
				let(:board_w_2) do
					board = Board.new
					board.instance_variable_set(:@board, {})		
					board.send(:add_chessman, pos_b_2, pawn_b)
					board
				end
				let(:board_values_w_1){ board_w_1.instance_variable_get(:@board) }
				let(:board_values_w_2){ board_w_2.instance_variable_get(:@board) }

				it "a normal move" do				
					expect(pawn_w.valid_move?(move_from, move_to, board_values)).to be_truthy
				end
				it "a first special move" do				
					expect(pawn_w.valid_move?(move_from, move_to_special, board_values)).to be_truthy
				end
				it "capturing enemy to the left" do				
					expect(pawn_w.valid_move?(move_from, move_to_capture_b_1, board_values_w_1)).to be_truthy				
				end
				it "capturing enemy to the right" do
					expect(pawn_w.valid_move?(move_from, move_to_capture_b_2, board_values_w_2)).to be_truthy
				end
			end
			context "performing invalidly" do			
				let(:move_to_3){ [4, "f"] }
				let(:move_to_back){ [0, "f"] }
				let(:move_to_side){ [1, "g"] }
				let(:move_to_diag_1){ [2, "g"] }
				let(:move_to_diag_2){ [2, "e"] }

				it "a 3 square move" do				
					expect(pawn_w.valid_move?(move_from, move_to_3, board_values)).to be_falsey
				end
				it "a backward move" do				
					expect(pawn_w.valid_move?(move_from, move_to_back, board_values)).to be_falsey
				end
				it "a side move" do				
					expect(pawn_w.valid_move?(move_from, move_to_side, board_values)).to be_falsey
				end
				it "a right diagonal move" do				
					expect(pawn_w.valid_move?(move_from, move_to_diag_1, board_values)).to be_falsey
				end
				it "a left diagonal move" do				
					expect(pawn_w.valid_move?(move_from, move_to_diag_2, board_values)).to be_falsey
				end
			end
		end

		context "for black pawn" do
			let(:move_from){ [6, "c"] }
			let(:board) do
				board = Board.new
				board.instance_variable_set(:@board, {})		
				board.send(:add_chessman, move_from, pawn_b)
				board
			end
			let(:board_values){ board.instance_variable_get(:@board) }
			context "performing validly" do			
				let(:move_to){ [5, "c"] }
				let(:move_to_special){ [4, "c"] }	
				let(:pos_w_1){ [5, "b"] }			
				let(:pos_w_2){ [5, "d"] }
				let(:move_to_capture_w_1){ [5, "b"] }	
				let(:move_to_capture_w_2){ [5, "d"] }	
				let(:board_b_1) do
					board = Board.new
					board.instance_variable_set(:@board, {})		
					board.send(:add_chessman, pos_w_1, pawn_w)
					board
				end
				let(:board_b_2) do
					board = Board.new
					board.instance_variable_set(:@board, {})		
					board.send(:add_chessman, pos_w_2, pawn_w)
					board
				end
				let(:board_values_b_1){ board_b_1.instance_variable_get(:@board) }
				let(:board_values_b_2){ board_b_2.instance_variable_get(:@board) }

				it "a normal move" do				
					expect(pawn_b.valid_move?(move_from, move_to, board_values)).to be_truthy
				end
				it "a first special move" do				
					expect(pawn_b.valid_move?(move_from, move_to_special, board_values)).to be_truthy
				end
				it "capturing enemy to the left" do				
					expect(pawn_b.valid_move?(move_from, move_to_capture_w_1, board_values_b_1)).to be_truthy				
				end
				it "capturing enemy to the right" do
					expect(pawn_b.valid_move?(move_from, move_to_capture_w_2, board_values_b_2)).to be_truthy
				end
			end
			context "performing invalidly" do			
				let(:move_3_squares_down){ [3, "c"] }
				let(:move_to_back){ [7, "c"] }
				let(:move_to_side){ [6, "b"] }
				let(:move_to_diag_1){ [5, "b"] }
				let(:move_to_diag_2){ [5, "d"] }

				it "moving 3 square down" do				
					expect(pawn_b.valid_move?(move_from, move_3_squares_down, board_values)).to be_falsey
				end
				it "a backward move" do				
					expect(pawn_b.valid_move?(move_from, move_to_back, board_values)).to be_falsey
				end
				it "a side move" do				
					expect(pawn_b.valid_move?(move_from, move_to_side, board_values)).to be_falsey
				end
				it "a left diagonal move" do				
					expect(pawn_b.valid_move?(move_from, move_to_diag_1, board_values)).to be_falsey
				end
				it "a right diagonal move" do				
					expect(pawn_b.valid_move?(move_from, move_to_diag_2, board_values)).to be_falsey
				end
			end
		end		
	end
end