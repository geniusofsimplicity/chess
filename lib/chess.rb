require_relative "player.rb"
require_relative "board.rb"

class Chess
	def self.setup
		board = Board.new
		colours = ["white", "black"]
		player1_colour = colours.sample
		player2_colour = colours - [player1_colour]
		player2_colour = player2_colour[0]
		player1 = Player.create(player1_colour)
		player2 = Player.create(player2_colour)
		self.new(board, player1, player2)
	end

	def start
		winner = false
		loop do
			@board.print
			puts "Player #{@current_player}, it is your turn."		
			loop do
				move_from = get_move_start
				move_to = get_move_end
				next if move_from.nil? || move_to.nil?			
				break if @board.reflect_move(move_from, move_to)
			end

			if @board.end_of_game?(@current_player.colour)
				winner = true				
				break				
			end
			@current_player = @current_player == @player1 ? @player2 : @player1			
		end
		if winner
			@board.print
			puts "Player #{@current_player} has won!"
		else
			puts "It is draw."
		end
		
	end

	private

	def get_move_start
		puts "Please, enter the position of the chessman"\
					" you want to move from"
		input = read_user_input #for the sake of testing
		move = []
		digit = input.scan(/[1-8]/)[0]
		letter = input.scan(/[a-h]/)[0]
		move << digit.to_i - 1 if digit
		move << letter if letter
		return move.size == 2 ? move : nil
	end

	def get_move_end
		puts "Please, enter the position of the chessman"\
					" you want to move to"
		input = read_user_input #for the sake of testing		
		move = []
		digit = input.scan(/[1-8]/)[0]
		letter = input.scan(/[a-h]/)[0]
		move << digit.to_i - 1 if digit
		move << letter if letter
		return move.size == 2 ? move : nil
	end

	def read_user_input
		gets.chomp
	end

	def initialize(board, player1, player2)
		@board = board
		@player1 = player1
		@player2 = player2
		@current_player = @player1.colour == "white" ? @player1 : @player2
	end
end

# game = Chess.setup
# game.start