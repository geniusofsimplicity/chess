require_relative "player.rb"
require_relative "board.rb"

class Chess
	def self.setup
		board = Board.new
		player1 = Player.create
		player2 = Player.create
		self.new(board, player1, player2)
	end

end