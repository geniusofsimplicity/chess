require_relative "chessman.rb"
require_relative "board.rb"

class King < Chessman
	U_SYMBOL_WHITE = "\u2654"
	U_SYMBOL_BLACK = "\u265A"

	def get_unicode_sybole
		return U_SYMBOL_WHITE if @colour == "white"
		return U_SYMBOL_BLACK if @colour == "black"
	end

	#TODO: add special move of the king
	def valid_move?(move_from, move_to, board_object)
		board_values = board_object.board
		# board = Board.new(board_values)
		diff_in_rows = (move_from[0] - move_to[0]).abs
		diff_in_columns = (move_from[1].ord - move_to[1].ord).abs
		
		diff_in_columns < 2 && diff_in_rows < 2 && board_values[move_to].nil? && not_in_check?(move_from, move_to, board_object)
	end

	def get_valid_move(move_from, board_object)
		directions = {}
		directions[1] = move_from[0] < 7 && valid_move?(move_from, [move_from[0] + 1, move_from[1]], board_object)
		directions[2] = move_from[0] < 7 && move_from[1] < "h" && valid_move?(move_from, [move_from[0] + 1, move_from[1].next], board_object)
		directions[3] = move_from[1] < "h" && valid_move?(move_from, [move_from[0], move_from[1].next], board_object)
		directions[4] = move_from[0] > 0 && move_from[1] < "h" && valid_move?(move_from, [move_from[0] - 1, move_from[1].next], board_object)
		directions[5] = move_from[0] > 0 && valid_move?(move_from, [move_from[0] - 1, move_from[1]], board_object)
		directions[6] = move_from[0] > 0 && move_from[1] > "a" && valid_move?(move_from, [move_from[0] - 1, (move_from[1].ord - 1).chr], board_object)
		directions[7] = move_from[1] > "a" && valid_move?(move_from, [move_from[0], (move_from[1].ord - 1).chr], board_object)
		directions[8] = move_from[0] < 7 && move_from[1] > "a" && valid_move?(move_from, [move_from[0] + 1, (move_from[1].ord - 1).chr], board_object)
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
		when nil
			return nil			
		end
		move_to			
	end

	private

	def castling_possible?(move_from, move_to, board_object)
		board_values = board_object.board
		castling_rooks = get_castling_rooks(move_from, board_object)
		castling_rooks.include?(board_values[move_to])
	end

	def get_castling_rooks(move_from, board_object)
		return [] if @move_count > 0
		board_values = board_object.board
		rank = move_from[0]
		left_rook = board_values[[rank, "a"]]
		result = []
		if left_rook.class == Rook && left_rook.move_count == 0
			condition = true #no threat and empty
			["b", "c", "d"].each do |file|
				condition &&= (board_values[[rank, file]].nil? &&
												not_in_check?(move_from, [rank, file], board_object))
			end
			result << left_rook if condition
		end
		right_rook = board_values[[rank, "h"]]		
		if right_rook.class == Rook && right_rook.move_count == 0
			condition = true #no threat and empty
			["f", "g"].each do |file|
				condition &&= (board_values[[rank, file]].nil? &&
												not_in_check?(move_from, [rank, file], board_object))
			end
			result << right_rook if condition
		end
		result
	end
		
	def not_in_check?(move_from, move_to, board_object)
		board = Board.new(board_object.board)
		board.reflect_move(move_from, move_to, @colour, true)		
		result = !board.check?(Chessman.get_enemy_colour(@colour))
		result
	end
end