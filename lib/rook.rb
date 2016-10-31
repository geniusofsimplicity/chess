require_relative "chessman.rb"

class Rook < Chessman
	U_SYMBOL_WHITE = "\u2656"
	U_SYMBOL_BLACK = "\u265C"

	def get_unicode_sybole
		return U_SYMBOL_WHITE if @colour == "white"
		return U_SYMBOL_BLACK if @colour == "black"
	end
end