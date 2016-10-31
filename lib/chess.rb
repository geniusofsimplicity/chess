require_relative "player.rb"
require_relative "board.rb"

class Chess
	def self.setup
		board = Board.new
		colours = ["white", "black"]
		player1_colour = colours.sample
		player2_colour = colours - [player1_colour]
		player1 = Player.create(player1_colour)
		player2 = Player.create(player2_colour)
		self.new(board, player1, player2)
	end

	def start
		loop do
			@board.print
			puts "Player #{@current_player} (#{@current_player.colour}), it is your turn."		
			move = get_move
			@board.reflect_move(move)
			if @board.end_of_game?
				@board.print
				puts "Player #{@current_player} (#{@current_player.colour}) has won!"
				return
			end
			@current_player = @current_player == @player1 ? @player2 : @player1			
		end
		puts "It is draw."		
	end

	private

	def get_move
		puts "Please, enter the position of the chessman\
					you want to move"
		input = read_user_input		
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