require_relative "chessman.rb"

class Knight < Chessman
	U_SYMBOL_WHITE = "\u2658"
	U_SYMBOL_BLACK = "\u265E"

	def get_unicode_sybole
		return U_SYMBOL_WHITE if @colour == "white"
		return U_SYMBOL_BLACK if @colour == "black"
	end
end