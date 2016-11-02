require_relative "king.rb"
require_relative "queen.rb"
require_relative "rook.rb"
require_relative "bishop.rb"
require_relative "knight.rb"
require_relative "pawn.rb"

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
		@background = "8| _ _ _ _ _ _ _ _\n7| _ _ _ _ _ _ _ _\n6| _ _ _ _ _ _ _ _\n5| _ _ _ _ _ _ _ _\n4| _ _ _ _ _ _ _ _\n3| _ _ _ _ _ _ _ _\n2| _ _ _ _ _ _ _ _\n1| _ _ _ _ _ _ _ _\n==================\n | a b c d e f g h"
	end

	def print		
		puts place_chessmen
	end

	def reflect_move(move_from, move_to)
		if valid_move?(move_from, move_to)
			chessman = @board.delete(move_from)			
			@board[move_to] = chessman
			return true
		end			
		false
	end

	def valid_move?(move_from, move_to)
		chessman = @board[move_from]
		chessman.valid_move?(move_from, move_to, @board)
	end

	def end_of_game?(colour)
		puts "@borad = #{@board}"
		enemy_king = @board.select do |position, chessman|			
			chessman.colour != colour && chessman.is_a?(King)
		end		
		king_position = enemy_king.keys[0]
		loyal_chessmen = @board.select do |position, chessman|
			chessman.colour == colour
		end		
		checkmate = false
		loyal_chessmen.each do |position, chessman|			
			checkmate ||= chessman.valid_move?(position, king_position, @board)
		end
		checkmate
	end

	private

	def place_chessmen
		background = @background.split("\n")			
		#utf-8 a -> 97... h-> 104
		@board.each do |pos, chessman|			
			column = pos[1].ord - 97
			background[7 - pos[0]][3 + column * 2] = chessman.get_unicode_sybole
		end
		background.join("\n")
	end

	def add_chessman(position, chessman)
		@board[position] = chessman
	end
end