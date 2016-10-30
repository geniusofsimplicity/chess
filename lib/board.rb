require "king.rb"
require "queen.rb"
require "rook.rb"
require "bishop.rb"
require "knight.rb"
require "pawn.rb"

class Board
	def initialize
		@board = {}				
		("a".."h").each do |i|
			pawn_w = Pawn.new("white")
			add_chessman([1, i], pawn_w)
			pawn_b = Pawn.new("black")
			add_chessman([6, i], pawn_b)					
		end
		["a", "h"].each do |i|
			rook_w = Rook.new("white")
			add_chessman([0, i], rook_w)
			rook_b = Rook.new("black")
			add_chessman([7, i], rook_b)
		end
		["b", "g"].each do |i|
			knight_w = Knight.new("white")
			add_chessman([0, i], knight_w)
			knight_b = Knight.new("black")
			add_chessman([7, i], knight_b)
		end
		["c", "f"].each do |i|
			bishop_w = Bishop.new("white")
			add_chessman([0, i], bishop_w)
			bishop_b = Bishop.new("black")
			add_chessman([7, i], bishop_b)
		end
		queen_w = Queen.new("white")
		add_chessman([0, "d"], queen_w)
		queen_b = Queen.new("black")
		add_chessman([7, "d"], queen_b)
		king_w = King.new("white")
		add_chessman([0, "e"], king_w)
		king_b = King.new("black")
		add_chessman([7, "e"], king_b)		
	end

	private

	def add_chessman(position, chessman)
		@board[position] = chessman
	end
end