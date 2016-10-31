require_relative "chessman.rb"

class Bishop < Chessman
	U_SYMBOL_WHITE = "\u2657"
	U_SYMBOL_BLACK = "\u265D"

	def get_unicode_sybole
		return U_SYMBOL_WHITE if @colour == "white"
		return U_SYMBOL_BLACK if @colour == "black"
	end
end