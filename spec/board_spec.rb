require "board.rb"
require "king.rb"
require "queen.rb"
require "rook.rb"
require "bishop.rb"
require "knight.rb"
require "pawn.rb"
require "chessman.rb"

describe Board do
	describe ".new" do
		context "setting up board" do
			let(:get_board_values){ Board.new.instance_variable_get(:@board) }			

			it { expect(get_board_values).to be_an_instance_of Hash }			
			it { expect(get_board_values.size).to eql(32) }
			it "checking all chessmen" do
				board_values = get_board_values				
				("a".."h").each do |i|
					pawn_w = board_values[[1, i]]
					expect(pawn_w.instance_variable_get(:@colour)).to eql("white")
					expect(pawn_w).to be_an_instance_of(Pawn)
					pawn_b = board_values[[6, i]]
					expect(pawn_b.instance_variable_get(:@colour)).to eql("black")
					expect(pawn_b).to be_an_instance_of(Pawn)
				end
				["a", "h"].each do |i|
					rook_w = board_values[[0, i]]
					expect(rook_w.instance_variable_get(:@colour)).to eql("white")
					expect(rook_w).to be_an_instance_of(Rook)
					rook_b = board_values[[7, i]]
					expect(rook_b.instance_variable_get(:@colour)).to eql("black")
					expect(rook_b).to be_an_instance_of(Rook)					
			end
				["b", "g"].each do |i|
					knight_w = board_values[[0, i]]
					expect(knight_w.instance_variable_get(:@colour)).to eql("white")
					expect(knight_w).to be_an_instance_of(Knight)
					knight_b = board_values[[7, i]]
					expect(knight_b.instance_variable_get(:@colour)).to eql("black")
					expect(knight_b).to be_an_instance_of(Knight)
				end
				["c", "f"].each do |i|
					bishop_w = board_values[[0, i]]
					expect(bishop_w.instance_variable_get(:@colour)).to eql("white")
					expect(bishop_w).to be_an_instance_of(Bishop)
					bishop_b = board_values[[7, i]]
					expect(bishop_b.instance_variable_get(:@colour)).to eql("black")
					expect(bishop_b).to be_an_instance_of(Bishop)
				end
				queen_w = board_values[[0, "d"]]
				expect(queen_w.instance_variable_get(:@colour)).to eql("white")
				expect(queen_w).to be_an_instance_of(Queen)				
				queen_b = board_values[[7, "d"]]
				expect(queen_b.instance_variable_get(:@colour)).to eql("black")
				expect(queen_b).to be_an_instance_of(Queen)
				king_w = board_values[[0, "e"]]
				expect(king_w.instance_variable_get(:@colour)).to eql("white")
				expect(king_w).to be_an_instance_of(King)
				king_b = board_values[[7, "e"]]
				expect(king_b.instance_variable_get(:@colour)).to eql("black")
				expect(king_b).to be_an_instance_of(King)				
			end
		end
	end

	describe "#add_chessman" do
		let(:pawn){ double("pawn") }
		let(:board_with_one_piece) do			
			board = Board.new
			board.instance_variable_set(:@board, {})
			board.send(:add_chessman, [1, "h"], pawn)
			board
		end
		it { expect(board_with_one_piece.board).to eql({[1, "h"] => pawn}) }
	end
	describe "#checkmate?" do
		# most test cases have duplicate to test behaviour of Queen, Bishop and Rook separately
		let(:colour_loyal) { "white" }
		let(:colour_enemy) { "black" }
		context "resolving positively" do
			let(:board_checkmate) do			
				board = Board.new({})
				board.send(:add_chessman, [0, "e"], King.new(colour_loyal))
				board.send(:add_chessman, [7, "a"], King.new(colour_enemy))
				board.send(:add_chessman, [0, "g"], Rook.new(colour_loyal))
				board.send(:add_chessman, [0, "d"], Queen.new(colour_loyal))
				board.send(:add_chessman, [1, "d"], Pawn.new(colour_loyal))
				board.send(:add_chessman, [1, "e"], Pawn.new(colour_loyal))
				board.send(:add_chessman, [0, "h"], Rook.new(colour_enemy))
				board.send(:add_chessman, [2, "h"], Bishop.new(colour_enemy))
				board.send(:add_chessman, [3, "h"], Bishop.new(colour_enemy))
				board
			end
			let(:board_checkmate_01) do			
				board = Board.new({})
				board.send(:add_chessman, [0, "e"], King.new(colour_loyal))
				board.send(:add_chessman, [7, "a"], King.new(colour_enemy))
				board.send(:add_chessman, [0, "g"], Rook.new(colour_loyal))
				board.send(:add_chessman, [0, "d"], Queen.new(colour_loyal))
				board.send(:add_chessman, [1, "d"], Pawn.new(colour_loyal))
				board.send(:add_chessman, [1, "e"], Pawn.new(colour_loyal))
				board.send(:add_chessman, [0, "h"], Rook.new(colour_enemy))
				board.send(:add_chessman, [2, "h"], Queen.new(colour_enemy))
				board.send(:add_chessman, [3, "h"], Queen.new(colour_enemy))
				board
			end
			let(:board_checkmate_2) do			
				board = Board.new({})
				board.send(:add_chessman, [0, "e"], King.new(colour_loyal))
				board.send(:add_chessman, [7, "a"], King.new(colour_enemy))
				board.send(:add_chessman, [0, "g"], Rook.new(colour_loyal))
				board.send(:add_chessman, [0, "d"], Queen.new(colour_loyal))
				board.send(:add_chessman, [1, "d"], Pawn.new(colour_loyal))
				board.send(:add_chessman, [1, "e"], Pawn.new(colour_loyal))				
				board.send(:add_chessman, [0, "h"], Rook.new(colour_enemy))
				board.send(:add_chessman, [2, "h"], Queen.new(colour_enemy))
				board.send(:add_chessman, [5, "d"], Queen.new(colour_enemy))
				board.reflect_move([5, "d"], [2, "g"], colour_enemy)
				board
			end
			let(:board_checkmate_21) do			
				board = Board.new({})
				board.send(:add_chessman, [0, "e"], King.new(colour_loyal))
				board.send(:add_chessman, [7, "a"], King.new(colour_enemy))
				board.send(:add_chessman, [0, "g"], Rook.new(colour_loyal))
				board.send(:add_chessman, [0, "d"], Queen.new(colour_loyal))
				board.send(:add_chessman, [1, "d"], Pawn.new(colour_loyal))
				board.send(:add_chessman, [1, "e"], Pawn.new(colour_loyal))				
				board.send(:add_chessman, [0, "h"], Rook.new(colour_enemy))
				board.send(:add_chessman, [2, "h"], Bishop.new(colour_enemy))
				board.send(:add_chessman, [5, "d"], Bishop.new(colour_enemy))
				board.reflect_move([5, "d"], [2, "g"], colour_enemy)
				board
			end
			let(:board_checkmate_3) do			
				board = Board.new({})
				board.send(:add_chessman, [0, "e"], King.new(colour_loyal))
				board.send(:add_chessman, [7, "a"], King.new(colour_enemy))
				board.send(:add_chessman, [0, "f"], Rook.new(colour_loyal))
				board.send(:add_chessman, [0, "d"], Rook.new(colour_loyal))
				board.send(:add_chessman, [1, "d"], Pawn.new(colour_loyal))
				board.send(:add_chessman, [1, "f"], Pawn.new(colour_loyal))				
				board.send(:add_chessman, [3, "a"], Rook.new(colour_enemy))				
				board.reflect_move([3, "a"], [3, "e"], colour_enemy)
				board
			end
			let(:board_checkmate_31) do			
				board = Board.new({})
				board.send(:add_chessman, [0, "e"], King.new(colour_loyal))
				board.send(:add_chessman, [7, "a"], King.new(colour_enemy))
				board.send(:add_chessman, [0, "f"], Rook.new(colour_loyal))
				board.send(:add_chessman, [0, "d"], Rook.new(colour_loyal))
				board.send(:add_chessman, [1, "d"], Pawn.new(colour_loyal))
				board.send(:add_chessman, [1, "f"], Pawn.new(colour_loyal))				
				board.send(:add_chessman, [3, "a"], Queen.new(colour_enemy))				
				board.reflect_move([3, "a"], [3, "e"], colour_enemy)
				board
			end
			let(:board_checkmate_4) do			
				board = Board.new({})
				board.send(:add_chessman, [0, "e"], King.new(colour_loyal))
				board.send(:add_chessman, [7, "a"], King.new(colour_enemy))				
				board.send(:add_chessman, [0, "d"], Rook.new(colour_loyal))
				board.send(:add_chessman, [1, "d"], Pawn.new(colour_loyal))
				board.send(:add_chessman, [1, "e"], Pawn.new(colour_loyal))
				board.send(:add_chessman, [1, "f"], Pawn.new(colour_loyal))				
				board.send(:add_chessman, [3, "h"], Rook.new(colour_enemy))				
				board.reflect_move([3, "h"], [0, "h"], colour_enemy)
				board
			end
			let(:board_checkmate_41) do			
				board = Board.new({})
				board.send(:add_chessman, [0, "e"], King.new(colour_loyal))
				board.send(:add_chessman, [7, "a"], King.new(colour_enemy))				
				board.send(:add_chessman, [0, "d"], Rook.new(colour_loyal))
				board.send(:add_chessman, [1, "d"], Pawn.new(colour_loyal))
				board.send(:add_chessman, [1, "e"], Pawn.new(colour_loyal))
				board.send(:add_chessman, [1, "f"], Pawn.new(colour_loyal))				
				board.send(:add_chessman, [3, "h"], Queen.new(colour_enemy))				
				board.reflect_move([3, "h"], [0, "h"], colour_enemy)
				board
			end

			it { expect(board_checkmate.checkmate?(colour_enemy)).to be_truthy }
			it { expect(board_checkmate_01.checkmate?(colour_enemy)).to be_truthy }
			it { expect(board_checkmate_2.checkmate?(colour_enemy)).to be_truthy }
			it { expect(board_checkmate_21.checkmate?(colour_enemy)).to be_truthy }
			it { expect(board_checkmate_3.checkmate?(colour_enemy)).to be_truthy }
			it { expect(board_checkmate_31.checkmate?(colour_enemy)).to be_truthy }
			it { expect(board_checkmate_4.checkmate?(colour_enemy)).to be_truthy }
			it { expect(board_checkmate_41.checkmate?(colour_enemy)).to be_truthy }
		end

		context "resolving negatively" do
			let(:board_checkmate) do			
				board = Board.new({})
				board.send(:add_chessman, [0, "e"], King.new(colour_loyal))
				board.send(:add_chessman, [7, "a"], King.new(colour_enemy))
				board.send(:add_chessman, [0, "g"], Rook.new(colour_loyal))
				board.send(:add_chessman, [0, "d"], Queen.new(colour_loyal))
				board.send(:add_chessman, [1, "d"], Pawn.new(colour_loyal))
				board.send(:add_chessman, [1, "e"], Pawn.new(colour_loyal))
				board.send(:add_chessman, [5, "g"], Rook.new(colour_loyal))
				board.send(:add_chessman, [0, "h"], Rook.new(colour_enemy))
				board.send(:add_chessman, [2, "h"], Queen.new(colour_enemy))
				board.send(:add_chessman, [3, "a"], Queen.new(colour_enemy))
				board.reflect_move([3, "a"], [3, "h"], colour_enemy)
				board
			end
			let(:board_checkmate_01) do			
				board = Board.new({})
				board.send(:add_chessman, [0, "e"], King.new(colour_loyal))
				board.send(:add_chessman, [7, "a"], King.new(colour_enemy))
				board.send(:add_chessman, [0, "g"], Rook.new(colour_loyal))
				board.send(:add_chessman, [0, "d"], Queen.new(colour_loyal))
				board.send(:add_chessman, [1, "d"], Pawn.new(colour_loyal))
				board.send(:add_chessman, [1, "e"], Pawn.new(colour_loyal))
				board.send(:add_chessman, [5, "g"], Rook.new(colour_loyal))
				board.send(:add_chessman, [0, "h"], Rook.new(colour_enemy))
				board.send(:add_chessman, [2, "h"], Bishop.new(colour_enemy))
				board.send(:add_chessman, [6, "e"], Bishop.new(colour_enemy))
				board.reflect_move([6, "e"], [3, "h"], colour_enemy)
				board
			end

			let(:board_checkmate_2) do			
				board = Board.new({})
				board.send(:add_chessman, [0, "e"], King.new(colour_loyal))
				board.send(:add_chessman, [7, "a"], King.new(colour_enemy))
				board.send(:add_chessman, [0, "g"], Rook.new(colour_loyal))
				board.send(:add_chessman, [0, "d"], Queen.new(colour_loyal))
				board.send(:add_chessman, [1, "d"], Pawn.new(colour_loyal))
				board.send(:add_chessman, [1, "e"], Pawn.new(colour_loyal))
				board.send(:add_chessman, [3, "b"], Rook.new(colour_loyal))
				board.send(:add_chessman, [0, "h"], Rook.new(colour_enemy))
				board.send(:add_chessman, [2, "h"], Queen.new(colour_enemy))
				board.send(:add_chessman, [7, "d"], Queen.new(colour_enemy))
				board.reflect_move([7, "d"], [3, "h"], colour_enemy)
				board
			end

			let(:board_checkmate_3) do			
				board = Board.new({})
				board.send(:add_chessman, [0, "e"], King.new(colour_loyal))
				board.send(:add_chessman, [7, "a"], King.new(colour_enemy))
				board.send(:add_chessman, [0, "f"], Bishop.new(colour_loyal))
				board.send(:add_chessman, [0, "d"], Queen.new(colour_loyal))
				board.send(:add_chessman, [1, "d"], Pawn.new(colour_loyal))
				board.send(:add_chessman, [1, "f"], Pawn.new(colour_loyal))				
				board.send(:add_chessman, [3, "a"], Rook.new(colour_enemy))				
				board.reflect_move([3, "a"], [3, "e"], colour_enemy)								
				board
			end
			let(:board_checkmate_31) do			
				board = Board.new({})
				board.send(:add_chessman, [0, "e"], King.new(colour_loyal))
				board.send(:add_chessman, [7, "a"], King.new(colour_enemy))
				board.send(:add_chessman, [0, "f"], Bishop.new(colour_loyal))
				board.send(:add_chessman, [0, "d"], Queen.new(colour_loyal))
				board.send(:add_chessman, [1, "d"], Pawn.new(colour_loyal))
				board.send(:add_chessman, [1, "f"], Pawn.new(colour_loyal))				
				board.send(:add_chessman, [3, "a"], Queen.new(colour_enemy))				
				board.reflect_move([3, "a"], [3, "e"], colour_enemy)
				board
			end
			let(:board_checkmate_4) do			
				board = Board.new({})				
				board.send(:add_chessman, [0, "e"], King.new(colour_loyal))
				board.send(:add_chessman, [7, "a"], King.new(colour_enemy))				
				board.send(:add_chessman, [0, "d"], Rook.new(colour_loyal))
				board.send(:add_chessman, [1, "d"], Pawn.new(colour_loyal))
				board.send(:add_chessman, [1, "e"], Bishop.new(colour_loyal))
				board.send(:add_chessman, [1, "f"], Pawn.new(colour_loyal))
				board.send(:add_chessman, [3, "h"], Rook.new(colour_enemy))				
				board.reflect_move([3, "h"], [0, "h"], colour_enemy)
				board
			end
			let(:board_checkmate_41) do			
				board = Board.new({})				
				board.send(:add_chessman, [0, "e"], King.new(colour_loyal))
				board.send(:add_chessman, [7, "a"], King.new(colour_enemy))				
				board.send(:add_chessman, [0, "d"], Rook.new(colour_loyal))
				board.send(:add_chessman, [1, "d"], Pawn.new(colour_loyal))
				board.send(:add_chessman, [1, "e"], Bishop.new(colour_loyal))
				board.send(:add_chessman, [1, "f"], Pawn.new(colour_loyal))
				board.send(:add_chessman, [3, "h"], Queen.new(colour_enemy))				
				board.reflect_move([3, "h"], [0, "h"], colour_enemy)
				board
			end

			it { expect(board_checkmate.checkmate?(colour_enemy)).to be_falsey }
			it { expect(board_checkmate_01.checkmate?(colour_enemy)).to be_falsey }
			it { expect(board_checkmate_2.checkmate?(colour_enemy)).to be_falsey }
			it { expect(board_checkmate_3.checkmate?(colour_enemy)).to be_falsey }
			it { expect(board_checkmate_31.checkmate?(colour_enemy)).to be_falsey }
			it { expect(board_checkmate_4.checkmate?(colour_enemy)).to be_falsey }
			it { expect(board_checkmate_41.checkmate?(colour_enemy)).to be_falsey }
		end
		
	end	
end