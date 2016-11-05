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
		
		diff_in_columns < 2 && diff_in_rows < 2 && not_in_check?(move_from, move_to, board)
	end

	private

	def not_in_check?(move_from, move_to, board)
		board.reflect_move(move_from, move_to, true)
		result = !board.check?((@@colours - [@colour])[0])
		result
	end
end