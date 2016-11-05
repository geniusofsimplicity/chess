require_relative "chessman.rb"

class Queen < Chessman
	U_SYMBOL_WHITE = "\u2655"
	U_SYMBOL_BLACK = "\u265B"

	def get_unicode_sybole
		return U_SYMBOL_WHITE if @colour == "white"
		return U_SYMBOL_BLACK if @colour == "black"
	end

	def valid_move?(move_from, move_to, board)
		diff_in_rows = (move_from[0] - move_to[0]).abs
		diff_in_columns = (move_from[1].ord - move_to[1].ord).abs
		diagonal_move = diff_in_columns == diff_in_rows

		rank_move = diff_in_rows > 0 && diff_in_columns == 0
		file_move = diff_in_rows == 0 && diff_in_columns > 0

		no_leap = false

		# TODO: move diagonal_move, rank_move and file_move methods to the Chessman class
		if diagonal_move
			in_the_way = board.select do |position, chessman|
				diff_in_rows = (position[0] - move_to[0]).abs
				diff_in_columns = (position[1].ord - move_to[1].ord).abs
				diff_in_columns == diff_in_rows && position != move_to && self != chessman
			end
			no_leap = in_the_way.count == 0
		end

		if rank_move
			in_the_way = 0
			the_way = [move_from[0], move_to[0]].sort
			((the_way[0] + 1)..(the_way[1] - 1)).each do |row|
				in_the_way += 1 if board[[row, move_from[1]]]
			end			
			no_leap = in_the_way == 0
		end

		if file_move
			in_the_way = 0
			the_way = [move_from[1], move_to[1]].sort
			(((the_way[0].ord + 1).chr)..((the_way[1].ord - 1).chr)).each do |column|
				in_the_way += 1 if board[[move_from[0], column]]
			end
			no_leap = in_the_way == 0
		end

		to_loyal = board[move_to] && board[move_to].colour == @colour

		no_leap && (!to_loyal) # no_leap is true only if one of the typical moves is true
	end
end