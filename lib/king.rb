require_relative "chessman.rb"

class King < Chessman
	U_SYMBOL_WHITE = "\u2654"
	U_SYMBOL_BLACK = "\u265A"

	def get_unicode_sybole
		return U_SYMBOL_WHITE if @colour == "white"
		return U_SYMBOL_BLACK if @colour == "black"
	end
end