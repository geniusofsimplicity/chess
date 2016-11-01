require_relative "chessman.rb"

class Pawn < Chessman
	U_SYMBOL_WHITE = "\u2659"
	U_SYMBOL_BLACK = "\u265F"

	def get_unicode_sybole
		return U_SYMBOL_WHITE if @colour == "white"
		return U_SYMBOL_BLACK if @colour == "black"
	end

	def valid_move?(move_from, move_to, capture)
		diff_in_rows = move_to[0] - move_from[0]
		diff_in_columns = (move_from[1].ord - move_to[1].ord).abs
		normal_move_white = 
												diff_in_columns == 0 && 					#no side moves
												move_to[0] - move_from[0] == 1 &&	#only one up
												@colour == "white"								#for white pawns
		first_move_white = 
												diff_in_columns == 0 && 					#no side moves
												move_from[0] == 1 &&							#from starting position
												move_to[0] == 3	&&								#special move
												@colour == "white" &&							#for white pawns
												board[[move_from[0] + 1, move_from[1]]].nil?
		normal_move_black = 
												diff_in_columns == 0 && 						#no side moves
												move_to[0] - move_from[0] == -1	&& 	#only one up
												@colour == "black"									#for black pawns

		first_move_black = 
												diff_in_columns == 0 && 				#no side moves
												move_from[0] == 6 &&						#from starting position
												move_to[0] == 4	&&							#special move
												@colour == "black" &&						#for black pawns
												board[[move_from[0] - 1, move_from[1]]].nil?
		capture_by_white =
												diff_in_columns == 1 &&							#to the side
												move_to[0] - move_from[0] == 1 &&		#only one up
												capture &&													#special move
												@colour == "white"									#for white pawns
		capture_by_black =
												diff_in_columns == 1 &&							#to the side
												move_to[0] - move_from[0] == -1 &&	#only one up
												capture &&													#special move
												@colour == "black"									#for black pawns
		normal_move_white || normal_move_black ||
			first_move_white || first_move_black ||
			capture_by_white || capture_by_black
	end
end