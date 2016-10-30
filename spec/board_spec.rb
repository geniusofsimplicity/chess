require "board.rb"
require "king.rb"
require "queen.rb"
require "rook.rb"
require "bishop.rb"
require "knight.rb"
require "pawn.rb"

describe Board do
	describe ".new" do
		context "setting up board" do
			let(:get_board_values){ Board.new.instance_variable_get(:@board) }
			let(:values_init_setup) do
				board = {}				
				("a".."h").each do |i|
					pawn_w = Pawn.new("white")
					board.send(:add_chessman, [1, i], pawn_w)
					pawn_b = Pawn.new("black")
					board.send(:add_chessman, [6, 7 - i], pawn_b)					
				end
				["a", "h"].each do |i|
					rook_w = Rook.new("white")
					board.send(:add_chessman, [0, i], rook_w)
					rook_b = Rook.new("black")
					board.send(:add_chessman, [7, i], rook_b)
				end
				["b", "g"].each do |i|
					knight_w = Knight.new("white")
					board.send(:add_chessman, [0, i], knight_w)
					knight_b = Knight.new("black")
					board.send(:add_chessman, [7, i], knight_b)
				end
				["c", "f"].each do |i|
					bishop_w = Bishop.new("white")
					board.send(:add_chessman, [0, i], bishop_w)
					bishop_b = Bishop.new("black")
					board.send(:add_chessman, [7, i], bishop_b)
				end
				queen_w = Queen.new("white")
				board.send(:add_chessman, [0, "d"], queen_w)
				queen_b = Queen.new("black")
				board.send(:add_chessman, [7, "d"], queen_b)
				king_w = King.new("white")
				board.send(:add_chessman, [0, "e"], king_w)
				king_b = King.new("black")
				board.send(:add_chessman, [7, "e"], king_b)
				board
			end

			it { expect(get_board_values).to be_an_instance_of Hash }			
			it { expect(get_board_values.size).to eql(32) }
			it { expect(get_board_values).to eql(values_init_setup) }
		end
	end

	describe "#add_chessman" do
		let(:pawn){ double("pawn") }
		let(:board_with_one_piece) do			
			board = Board.new
			board.instance_variable_set(:@board, {})
			board.send(:add_chessman, 1, "h", pawn)
			board
		end
		it { expect(board_with_one_piece.instance_variable_get(:@board)).to eql({[1, "h"] => pawn}) }
	end
	
end