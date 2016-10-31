require_relative "chessman.rb"

class Queen < Chessman
	U_SYMBOL_WHITE = "\u2655"
	U_SYMBOL_BLACK = "\u265B"

	def get_unicode_sybole
		return U_SYMBOL_WHITE if @colour == "white"
		return U_SYMBOL_BLACK if @colour == "black"
	end
end