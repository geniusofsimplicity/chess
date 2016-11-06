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
	def valid_move?(move_from, move_to, board_values)
		board = Board.new(board_values)
		diff_in_rows = (move_from[0] - move_to[0]).abs
		diff_in_columns = (move_from[1].ord - move_to[1].ord).abs
		
		diff_in_columns < 2 && diff_in_rows < 2 && board_values[move_to].nil? && not_in_check?(move_from, move_to, board)
	end

	def get_valid_move(move_from, board_values)
		directions = {}
		directions[1] = move_from[0] < 7 && valid_move?(move_from, [move_from[0] + 1, move_from[1]], board_values)
		directions[2] = move_from[0] < 7 && move_from[1] < "h" && valid_move?(move_from, [move_from[0] + 1, move_from[1].next], board_values)
		directions[3] = move_from[1] < "h" && valid_move?(move_from, [move_from[0], move_from[1].next], board_values)
		directions[4] = move_from[0] > 0 && move_from[1] < "h" && valid_move?(move_from, [move_from[0] - 1, move_from[1].next], board_values)
		directions[5] = move_from[0] > 0 && valid_move?(move_from, [move_from[0] - 1, move_from[1]], board_values)
		directions[6] = move_from[0] > 0 && move_from[1] > "a" && valid_move?(move_from, [move_from[0] - 1, (move_from[1].ord - 1).chr], board_values)
		directions[7] = move_from[1] > "a" && valid_move?(move_from, [move_from[0], (move_from[1].ord - 1).chr], board_values)
		directions[8] = move_from[0] < 7 && move_from[1] > "a" && valid_move?(move_from, [move_from[0] + 1, (move_from[1].ord - 1).chr], board_values)
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

	# TODO: think about moving the method to the Board class
	def not_in_check?(move_from, move_to, board)
		board.reflect_move(move_from, move_to, @colour, true)
		result = !board.check?((@@colours - [@colour])[0])
		result
	end
end