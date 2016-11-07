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
	
end