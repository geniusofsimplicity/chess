class Chessman
	attr_reader :colour, :move_count	
	@@colours = ["white", "black"]
	def initialize(colour)
		@colour = colour
		@move_count = 0
	end

	def self.colours
		@@colours		
	end

	def increase_move_count
		@move_count += 1		
	end

	def self.get_enemy_colour(loyal_colour)
		(@@colours - [loyal_colour])[0]
	end
end