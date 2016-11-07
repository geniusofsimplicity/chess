require_relative "chessman.rb"

class Pawn < Chessman
	U_SYMBOL_WHITE = "\u2659"
	U_SYMBOL_BLACK = "\u265F"

	def get_unicode_sybole
		return U_SYMBOL_WHITE if @colour == "white"
		return U_SYMBOL_BLACK if @colour == "black"
	end

	def valid_move?(move_from, move_to, board_object)		
		board = board_object.board
		diff_in_rows = move_to[0] - move_from[0]
		diff_in_columns = (move_from[1].ord - move_to[1].ord).abs
		normal_move_white = 
												diff_in_columns == 0 && 					#no side moves
												move_to[0] - move_from[0] == 1 &&	#only one up
												board[move_to].nil? && 						# must be empty
												@colour == "white"								#for white pawns
		first_move_white = 
												diff_in_columns == 0 && 					#no side moves
												move_from[0] == 1 &&							#from starting position
												move_to[0] == 3	&&								#special move
												(board[move_to].nil? && board[[move_to[0] - 1, move_to[1]]].nil?) && 	# must be empty
												@colour == "white" &&							#for white pawns
												board[[move_from[0] + 1, move_from[1]]].nil?
		normal_move_black = 
												diff_in_columns == 0 && 						#no side moves
												move_to[0] - move_from[0] == -1	&& 	#only one down
												board[move_to].nil? && 							# must be empty
												@colour == "black"									#for black pawns

		first_move_black = 
												diff_in_columns == 0 && 				#no side moves
												move_from[0] == 6 &&						#from starting position
												move_to[0] == 4	&&							#special move
												board[move_to].nil? && board[[move_to[0] + 1, move_to[1]]].nil? && 	# must be empty
												@colour == "black" &&						#for black pawns
												board[[move_from[0] - 1, move_from[1]]].nil?
		if board[move_to]
			capture_by_white =
												diff_in_columns == 1 &&								#to the side
												move_to[0] - move_from[0] == 1 &&			#only one up
												board[move_to].colour == "black" &&	
												@colour == "white"										#for white pawns
			capture_by_black =
												diff_in_columns == 1 &&							#to the side
												move_to[0] - move_from[0] == -1 &&	#only one up
												board[move_to].colour == "white" &&	
												@colour == "black"									#for black pawns
		end
		last_move = board_object.last_move
		if last_move && last_move[2].class == Pawn
			en_passant_move_white =
												move_from[0] == 4 &&	
												move_to[0] == 5 &&
												last_move[0][0] == 6 && # black pawn from rank 7
												last_move[1][0] == 4 && # to rank 5 -> first special move
												last_move[1][1] == move_to[1] &&
												@colour == "white"

			en_passant_move_black =
												move_from[0] == 3 &&
												move_to[0] == 2 &&
												last_move[0][0] == 1 && # black pawn from rank 7
												last_move[1][0] == 3 && # to rank 5 -> first special move
												last_move[1][1] == move_to[1] &&
												@colour == "black"
		end
		

		
		normal_move_white || normal_move_black ||
			first_move_white || first_move_black ||
			capture_by_white || capture_by_black ||
			en_passant_move_black || en_passant_move_white
	end
end