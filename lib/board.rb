require_relative "king.rb"
require_relative "queen.rb"
require_relative "rook.rb"
require_relative "bishop.rb"
require_relative "knight.rb"
require_relative "pawn.rb"

class Board
	attr_reader :board
	def initialize(board = nil)
		# square_sym = "\u25A1"
		square_sym = "\u2B1C"
		@background = "8| #{square_sym} #{square_sym} #{square_sym} #{square_sym} #{square_sym} #{square_sym} #{square_sym} #{square_sym}\n7| #{square_sym} #{square_sym} #{square_sym} #{square_sym} #{square_sym} #{square_sym} #{square_sym} #{square_sym}\n6| #{square_sym} #{square_sym} #{square_sym} #{square_sym} #{square_sym} #{square_sym} #{square_sym} #{square_sym}\n5| #{square_sym} #{square_sym} #{square_sym} #{square_sym} #{square_sym} #{square_sym} #{square_sym} #{square_sym}\n4| #{square_sym} #{square_sym} #{square_sym} #{square_sym} #{square_sym} #{square_sym} #{square_sym} #{square_sym}\n3| #{square_sym} #{square_sym} #{square_sym} #{square_sym} #{square_sym} #{square_sym} #{square_sym} #{square_sym}\n2| #{square_sym} #{square_sym} #{square_sym} #{square_sym} #{square_sym} #{square_sym} #{square_sym} #{square_sym}\n1| #{square_sym} #{square_sym} #{square_sym} #{square_sym} #{square_sym} #{square_sym} #{square_sym} #{square_sym}\n==================\n | a b c d e f g h"
		if board
			@board = board.dup
			return
		end
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

	def print		
		puts place_chessmen
	end

	def reflect_move(move_from, move_to, colour, checking = false) # 1-colour, 2-checking		
		if checking || valid_move?(move_from, move_to, colour)
			chessman = @board.delete(move_from)
			@last_move = [move_from, move_to, chessman]
			@board[move_to] = chessman
			return true
		end
		false
	end

	def valid_move?(move_from, move_to, colour)		
		chessman = @board[move_from]
		return false if chessman.colour != colour
		chessman.valid_move?(move_from, move_to, @board)
	end

	def checkmate?(colour) # colour of the current player
		colour_enemy = Chessman.get_enemy_colour(colour)
		enemy_king_position = get_king_position(colour_enemy)
		enemy_king = @board[enemy_king_position]

		# condition 1
		move = enemy_king.get_valid_move(enemy_king_position, @board)
		condition1 = move ? false : true

		# condition 2: the threat can be eliminated
		condition2 = true
		if @last_move
			checking_chessman = @last_move[2]
			checking_chessman_position = @last_move[1]
			loyal_chessmen = get_loyal_chessmen(colour_enemy)
			threat_can_be_eliminated = false
			loyal_chessmen.each do |position, chessman|
				board = Board.new(@board)
				board.reflect_move(position, checking_chessman_position, colour_enemy)
				result = !board.check?(colour)
				threat_can_be_eliminated ||= result
			end
			condition2 = !threat_can_be_eliminated
		end

		# condition 3: interposing a piece between the checking piece and the king
		condition3 = true
		if @last_move			
			checking_chessman = @last_move[2]
			checking_chessman_position = @last_move[1]
			loyal_chessmen_without_king = get_loyal_chessmen(colour_enemy)
			loyal_chessmen_without_king.delete(get_king_position(colour_enemy))
			can_be_blocked = false
			case 
			when checking_chessman.class == Rook
				diff_in_rows = checking_chessman_position[0] - enemy_king_position[0]
				diff_in_columns = checking_chessman_position[1].ord - enemy_king_position[1].ord

				rank_move = diff_in_rows.abs > 0 && diff_in_columns == 0
				file_move = diff_in_rows == 0 && diff_in_columns.abs > 0
				case
				when rank_move
					sign = - diff_in_rows / diff_in_rows.abs
					(diff_in_rows.abs - 1).times do |i|
						current_square = [checking_chessman_position[0] + (i + 1) * sign, checking_chessman_position[1]]
						loyal_chessmen_without_king.each do |position, chessman|
							board = Board.new(@board)
							board.reflect_move(position, current_square, colour_enemy)
							result = !board.check?(colour)
							can_be_blocked ||= result
						end
					end
				when file_move
					sign = - diff_in_columns / diff_in_columns.abs
					(diff_in_columns.abs - 1).times do |i|
						current_square = [checking_chessman_position[0], (checking_chessman_position[1].ord + (i + 1) * sign).chr]
						loyal_chessmen_without_king.each do |position, chessman|
							board = Board.new(@board)
							board.reflect_move(position, current_square, colour_enemy)
							can_be_blocked = true if chessman.valid_move?(position, current_square, @board)
							result = !board.check?(colour)
							can_be_blocked ||= result
						end
					end
				end
			when checking_chessman.class == Bishop
				diff_in_columns = (checking_chessman_position[1].ord - enemy_king_position[1].ord).abs
				rank_sign = enemy_king_position[0] <=> checking_chessman_position[0]
				file_sign = enemy_king_position[1] <=> checking_chessman_position[1]
				(diff_in_columns - 1).times do |i|
					current_square = [checking_chessman_position[0] + (i + 1) * rank_sign, (checking_chessman_position[1].ord + (i + 1) * file_sign).chr]
					loyal_chessmen_without_king.each do |position, chessman|
						board = Board.new(@board)
						board.reflect_move(position, current_square, colour_enemy)
						result = !board.check?(colour)
						can_be_blocked ||= result
					end
				end
			when checking_chessman.class == Queen
				diff_in_rows = checking_chessman_position[0] - enemy_king_position[0]
				diff_in_columns = checking_chessman_position[1].ord - enemy_king_position[1].ord

				diagonal_move = diff_in_columns.abs == diff_in_rows.abs
				rank_move = diff_in_rows.abs > 0 && diff_in_columns == 0
				file_move = diff_in_rows == 0 && diff_in_columns.abs > 0

				case 
				when diagonal_move
					rank_sign = enemy_king_position[0] <=> checking_chessman_position[0]
					file_sign = enemy_king_position[1] <=> checking_chessman_position[1]
					(diff_in_columns - 1).times do |i|
						current_square = [checking_chessman_position[0] + (i + 1) * rank_sign, (checking_chessman_position[1].ord + (i + 1) * file_sign).chr]
						loyal_chessmen_without_king.each do |position, chessman|
							board = Board.new(@board)
							board.reflect_move(position, current_square, colour_enemy)
							result = !board.check?(colour)
							can_be_blocked ||= result
						end
					end
				when rank_move
					sign = - diff_in_rows / diff_in_rows.abs
					(diff_in_rows.abs - 1).times do |i|
						current_square = [checking_chessman_position[0] + (i + 1) * sign, checking_chessman_position[1]]
						loyal_chessmen_without_king.each do |position, chessman|
							board = Board.new(@board)
							board.reflect_move(position, current_square, colour_enemy)
							result = !board.check?(colour)
							can_be_blocked ||= result
						end
					end
				when file_move						
					sign = - diff_in_columns / diff_in_columns.abs
					(diff_in_columns.abs - 1).times do |i|
						current_square = [checking_chessman_position[0], (checking_chessman_position[1].ord + (i + 1) * sign).chr]
						loyal_chessmen_without_king.each do |position, chessman|
							board = Board.new(@board)
							board.reflect_move(position, current_square, colour_enemy)
							can_be_blocked = true if chessman.valid_move?(position, current_square, @board)
							result = !board.check?(colour)
							can_be_blocked ||= result
						end
					end
				end
			end
			condition3 = !can_be_blocked
		end

		condition1 && condition2 && condition3
	end

	def check?(colour)
		colour_enemy = Chessman.get_enemy_colour(colour)
		enemy_king_position = get_king_position(colour_enemy)
		loyal_chessmen = get_loyal_chessmen(colour)
		check = false
		loyal_chessmen.each do |position, chessman|
			check ||= chessman.valid_move?(position, enemy_king_position, @board)
		end
		check
	end

	private

	def get_loyal_chessmen(colour)
		@board.select do |position, chessman|
			chessman.colour == colour
		end		
	end

	def get_king_position(colour)
		enemy_king = @board.select do |position, chessman|			
			chessman.colour == colour && chessman.is_a?(King)
		end		
		enemy_king.keys[0]
	end

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