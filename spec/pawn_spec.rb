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
				let(:colour_loyal) { "white" }
				let(:colour_enemy) { "black" }
				let(:pawn_b_en_passant){ Pawn.new(colour_enemy) }
				let(:board_en_passant) do			
					board = Board.new({})
					board.send(:add_chessman, [0, "e"], King.new(colour_loyal))
					board.send(:add_chessman, [7, "a"], King.new(colour_enemy))					
					board.send(:add_chessman, [1, "e"], Pawn.new(colour_loyal))					
					board.send(:add_chessman, [3, "f"], pawn_b_en_passant)
					board.reflect_move([1, "e"], [3, "e"], colour_loyal)
					board
				end

				it "a normal move" do				
					expect(pawn_w.valid_move?(move_from, move_to, board)).to be_truthy
				end
				it "a first special move" do				
					expect(pawn_w.valid_move?(move_from, move_to_special, board)).to be_truthy
				end
				it "capturing enemy to the left" do				
					expect(pawn_w.valid_move?(move_from, move_to_capture_b_1, board_w_1)).to be_truthy				
				end
				it "capturing enemy to the right" do
					expect(pawn_w.valid_move?(move_from, move_to_capture_b_2, board_w_2)).to be_truthy
				end

				it "En passant" do
					expect(pawn_b_en_passant.valid_move?([3, "f"], [2, "e"], board_en_passant)).to be_truthy
				end
			end
			context "performing invalidly" do			
				let(:move_to_3){ [4, "f"] }
				let(:move_to_back){ [0, "f"] }
				let(:move_to_side){ [1, "g"] }
				let(:move_to_diag_1){ [2, "g"] }
				let(:move_to_diag_2){ [2, "e"] }

				it "a 3 square move" do				
					expect(pawn_w.valid_move?(move_from, move_to_3, board)).to be_falsey
				end
				it "a backward move" do				
					expect(pawn_w.valid_move?(move_from, move_to_back, board)).to be_falsey
				end
				it "a side move" do				
					expect(pawn_w.valid_move?(move_from, move_to_side, board)).to be_falsey
				end
				it "a right diagonal move" do				
					expect(pawn_w.valid_move?(move_from, move_to_diag_1, board)).to be_falsey
				end
				it "a left diagonal move" do				
					expect(pawn_w.valid_move?(move_from, move_to_diag_2, board)).to be_falsey
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

				it "a normal move" do				
					expect(pawn_b.valid_move?(move_from, move_to, board)).to be_truthy
				end
				it "a first special move" do				
					expect(pawn_b.valid_move?(move_from, move_to_special, board)).to be_truthy
				end
				it "capturing enemy to the left" do				
					expect(pawn_b.valid_move?(move_from, move_to_capture_w_1, board_b_1)).to be_truthy				
				end
				it "capturing enemy to the right" do
					expect(pawn_b.valid_move?(move_from, move_to_capture_w_2, board_b_2)).to be_truthy
				end
			end
			context "performing invalidly" do			
				let(:move_3_squares_down){ [3, "c"] }
				let(:move_to_back){ [7, "c"] }
				let(:move_to_side){ [6, "b"] }
				let(:move_to_diag_1){ [5, "b"] }
				let(:move_to_diag_2){ [5, "d"] }

				it "moving 3 square down" do				
					expect(pawn_b.valid_move?(move_from, move_3_squares_down, board)).to be_falsey
				end
				it "a backward move" do				
					expect(pawn_b.valid_move?(move_from, move_to_back, board)).to be_falsey
				end
				it "a side move" do				
					expect(pawn_b.valid_move?(move_from, move_to_side, board)).to be_falsey
				end
				it "a left diagonal move" do				
					expect(pawn_b.valid_move?(move_from, move_to_diag_1, board)).to be_falsey
				end
				it "a right diagonal move" do				
					expect(pawn_b.valid_move?(move_from, move_to_diag_2, board)).to be_falsey
				end
			end
		end		
	end
end