require_relative "chessman.rb"

class King < Chessman
	U_SYMBOL_WHITE = "\u2654"
	U_SYMBOL_BLACK = "\u265A"

	def get_unicode_sybole
		return U_SYMBOL_WHITE if @colour == "white"
		return U_SYMBOL_BLACK if @colour == "black"
	end

	#TODO: add special move of the king
	def valid_move?(move_from, move_to)
		diff_in_rows = (move_from[0] - move_to[0]).abs
		diff_in_columns = (move_from[1].ord - move_to[1].ord).abs
		diff_in_columns < 2 && diff_in_rows < 2
	end
end