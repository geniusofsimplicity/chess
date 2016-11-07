require_relative "chessman.rb"

class Bishop < Chessman
	U_SYMBOL_WHITE = "\u2657"
	U_SYMBOL_BLACK = "\u265D"

	def get_unicode_sybole
		return U_SYMBOL_WHITE if @colour == "white"
		return U_SYMBOL_BLACK if @colour == "black"
	end

	def valid_move?(move_from, move_to, board)		
		diff_in_rows = (move_from[0] - move_to[0]).abs
		diff_in_columns = (move_from[1].ord - move_to[1].ord).abs

		diagonal_move = diff_in_columns == diff_in_rows
		no_leap = false

		if diagonal_move
			in_the_way = 0
			rank_sign = move_to[0] <=> move_from[0]
			file_sign = move_to[1] <=> move_from[1]
			(diff_in_columns - 1).times do |i|
				current_square = [move_from[0] + (i + 1) * rank_sign, (move_from[1].ord + (i + 1) * file_sign).chr]
				in_the_way += 1 if board[current_square]
			end			
			no_leap = in_the_way == 0
		end

		no_leap # no_leap is true only if diagonal_move is true
	end
end