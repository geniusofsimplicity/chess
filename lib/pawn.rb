require_relative "chessman.rb"

class Pawn < Chessman
	U_SYMBOL_WHITE = "\u2659"
	U_SYMBOL_BLACK = "\u265F"

	def get_unicode_sybole
		return U_SYMBOL_WHITE if @colour == "white"
		return U_SYMBOL_BLACK if @colour == "black"
	end
end