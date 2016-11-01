require_relative "chessman.rb"

class Rook < Chessman
	U_SYMBOL_WHITE = "\u2656"
	U_SYMBOL_BLACK = "\u265C"

	def get_unicode_sybole
		return U_SYMBOL_WHITE if @colour == "white"
		return U_SYMBOL_BLACK if @colour == "black"
	end

	def valid_move?(move_from, move_to, board)
		diff_in_rows = (move_from[0] - move_to[0]).abs
		diff_in_columns = (move_from[1].ord - move_to[1].ord).abs		

		rank_move = diff_in_rows > 0 && diff_in_columns == 0
		file_move = diff_in_rows == 0 && diff_in_columns > 0

		no_leap = false		

		if rank_move
			in_the_way = board.select do |position, chessman|
				position[1] == move_from[1]
			end
			no_leap = in_the_way.count == 0
		end

		if file_move
			in_the_way = board.select do |position, chessman|
				position[0] == move_from[0]
			end
			no_leap = in_the_way.count == 0
		end
		# rank_move || file_move || no_leap
		no_leap # no_leap is true only if either rank_move or file_move is true
	end
end