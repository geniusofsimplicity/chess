# require "pawn.rb"
require "chess.rb"

describe Pawn do
	describe "#valid_move?"	do
		let(:pawn){ Pawn.new("white") }
		let(:move_from){ [1, "f"] }
		let(:board) do
			board = Board.new
			board.instance_variable_set(:@board, {})		
			board.send(:add_chessman, move_from, pawn)
			board
		end
		let(:board_values){ board.instance_variable_get(:@board) }
		context "performing validly" do			
			let(:move_to){ [2, "f"] }
			let(:move_to_special){ [3, "f"] }

			it "a normal move" do				
				expect(pawn.valid_move?(move_from, move_to, board_values)).to be_truthy
			end
			it "a first special move" do				
				expect(pawn.valid_move?(move_from, move_to_special, board_values)).to be_truthy
			end
		end
		context "performing invalidly" do			
			let(:move_to_3){ [4, "f"] }
			let(:move_to_back){ [0, "f"] }
			let(:move_to_side){ [1, "g"] }
			
			it "a 3 square move" do				
				expect(pawn.valid_move?(move_from, move_to_3, board_values)).to be_falsey
			end
			it "a backward move" do				
				expect(pawn.valid_move?(move_from, move_to_back, board_values)).to be_falsey
			end
			it "a side move" do				
				expect(pawn.valid_move?(move_from, move_to_side, board_values)).to be_falsey
			end
		end
	end
end