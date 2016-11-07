require "king.rb"
require "queen.rb"
require "chessman.rb"

describe King do
	let(:king_w){ King.new("white") }
	let(:king_b){ King.new("black") }
	let(:king){ [king_b, king_w].sample }
	let(:enemy_queen){ Queen.new((Chessman.colours - [king.colour])[0]) }

	let(:move_from){ [rand(8), ["a", "h"].sample] }
	let(:board) do
		board = Board.new
		board.instance_variable_set(:@board, {})		
		board.send(:add_chessman, move_from, king)
		board
	end	
	let(:move_to) do
		directions = {}
		directions[1] = move_from[0] < 7
		directions[2] = move_from[0] < 7 && move_from[1] < "h"
		directions[3] = move_from[1] < "h"
		directions[4] = move_from[0] > 0 && move_from[1] < "h"
		directions[5] = move_from[0] > 0
		directions[6] = move_from[0] > 0 && move_from[1] > "a"
		directions[7] = move_from[1] > "a"
		directions[8] = move_from[0] < 7 && move_from[1] > "a"
		valid_directions = directions.select{|k, v| v}
		valid_directions = valid_directions.keys
		choice = valid_directions.sample
		case choice
		when 1
			move_to = [move_from[0] + 1, move_from[1]]
		when 2
			move_to = [move_from[0] + 1, move_from[1].next]
		when 3
			move_to = [move_from[0], move_from[1].next]
		when 4
			move_to = [move_from[0] - 1, move_from[1].next]
		when 5
			move_to = [move_from[0] - 1, move_from[1]]
		when 6
			move_to = [move_from[0] - 1, (move_from[1].ord - 1).chr]
		when 7
			move_to = [move_from[0], (move_from[1].ord - 1).chr]
		when 8
			move_to = [move_from[0] + 1, (move_from[1].ord - 1).chr]
		end
		move_to				
	end

	context "performing validly" do
		it { expect(king.valid_move?(move_from, move_to, board)).to be_truthy }
	end

	context "performing invalidly" do
		let(:queen_position) do
			rank_pool = (0..7).to_a - [move_from[0]]
			file_pool = ("a".."h").to_a - [move_from[1]]
			choice = (move_from[1].ord - move_to[1].ord).abs > 0 ? "rank" : "file"
			position = []
			case choice
			when "rank"
				position[0] = (rank_pool - [move_to[0]]).sample #excluding init and target rank of the king
				position[1] = move_to[1]
			when "file"
				position[0] = move_to[0]
				position[1] = (file_pool - [move_to[1]]).sample #excluding init and target file of the king
			end
			position
		end
		let(:board_with_queen) do
			board = Board.new
			board.instance_variable_set(:@board, {})		
			board.send(:add_chessman, move_from, king)
			board.send(:add_chessman, queen_position, enemy_queen)			
			board
		end

		it { expect(king.valid_move?(move_from, move_to, board_with_queen)).to be_falsey }

	end

	describe "#castling_possible?" do
		context "positively" do
			let(:board_castling_white) do			
				board = Board.new({})
				board.send(:add_chessman, [0, "e"], king_w)
				board.send(:add_chessman, [7, "e"], king_b)
				board.send(:add_chessman, [0, "h"], Rook.new("white"))
				board.send(:add_chessman, [0, "a"], Rook.new("white"))
				board
			end
			let(:board_castling_black) do			
				board = Board.new({})
				board.send(:add_chessman, [0, "e"], king_w)
				board.send(:add_chessman, [7, "e"], king_b)
				board.send(:add_chessman, [7, "h"], Rook.new("black"))
				board.send(:add_chessman, [7, "a"], Rook.new("black"))
				board
			end
			it { expect(king_w.send(:castling_possible?, [0, "e"], [0, "h"], board_castling_white)).to be_truthy }
			it { expect(king_w.send(:castling_possible?, [0, "e"], [0, "a"], board_castling_white)).to be_truthy }
			it { expect(king_w.send(:castling_possible?, [7, "e"], [7, "h"], board_castling_black)).to be_truthy }
			it { expect(king_w.send(:castling_possible?, [7, "e"], [7, "a"], board_castling_black)).to be_truthy }
		end
		context "negatively" do
			let(:board_no_castling_white) do
				board = Board.new({})
				board.send(:add_chessman, [0, "e"], king_w)
				board.send(:add_chessman, [7, "a"], king_b)
				board.send(:add_chessman, [0, "h"], Rook.new("white"))
				board.send(:add_chessman, [0, "a"], Rook.new("white"))				
				board.send(:add_chessman, [5, "b"], Rook.new("black"))
				board.send(:add_chessman, [5, "f"], Rook.new("black"))
				board
			end
			let(:board_no_castling_black) do
				board = Board.new({})
				board.send(:add_chessman, [0, "e"], king_w)
				board.send(:add_chessman, [7, "e"], king_b)
				board.send(:add_chessman, [7, "h"], Rook.new("black"))
				board.send(:add_chessman, [7, "a"], Rook.new("black"))
				board.send(:add_chessman, [5, "b"], Rook.new("white"))
				board.send(:add_chessman, [5, "f"], Rook.new("white"))
				board
			end
			let(:board_no_castling_black_2) do
				board = Board.new({})
				board.send(:add_chessman, [0, "e"], king_w)
				board.send(:add_chessman, [7, "e"], king_b)
				board.send(:add_chessman, [7, "h"], Rook.new("black"))
				board.send(:add_chessman, [7, "a"], Rook.new("black"))
				board.reflect_move([7, "a"], [1, "a"], "black")
				board.reflect_move([1, "a"], [7, "a"], "black")
				board.reflect_move([7, "h"], [1, "h"], "black")
				board.reflect_move([1, "h"], [7, "h"], "black")
				board
			end
			let(:board_no_castling_white_2) do
				board = Board.new({})
				board.send(:add_chessman, [0, "e"], king_w)
				board.send(:add_chessman, [7, "e"], king_b)
				board.send(:add_chessman, [0, "h"], Rook.new("white"))
				board.send(:add_chessman, [0, "a"], Rook.new("white"))
				board.reflect_move([0, "a"], [1, "a"], "white")
				board.reflect_move([1, "a"], [0, "a"], "white")
				board.reflect_move([0, "h"], [1, "h"], "white")
				board.reflect_move([1, "h"], [0, "h"], "white")
				board
			end

			it { expect(king_w.send(:castling_possible?, [0, "e"], [0, "h"], board_no_castling_white)).to be_falsey }
			it { expect(king_w.send(:castling_possible?, [0, "e"], [0, "a"], board_no_castling_white)).to be_falsey }
			it { expect(king_w.send(:castling_possible?, [0, "e"], [0, "h"], board_no_castling_white_2)).to be_falsey }
			it { expect(king_w.send(:castling_possible?, [0, "e"], [0, "a"], board_no_castling_white_2)).to be_falsey }
			it { expect(king_b.send(:castling_possible?, [7, "e"], [7, "h"], board_no_castling_black)).to be_falsey }
			it { expect(king_b.send(:castling_possible?, [7, "e"], [7, "a"], board_no_castling_black)).to be_falsey }
			it { expect(king_b.send(:castling_possible?, [7, "e"], [7, "h"], board_no_castling_black_2)).to be_falsey }
			it { expect(king_b.send(:castling_possible?, [7, "e"], [7, "a"], board_no_castling_black_2)).to be_falsey }
		end
	end
	
end