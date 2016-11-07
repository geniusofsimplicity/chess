class Chessman
	attr_reader :colour
	@@colours = ["white", "black"]
	def initialize(colour)
		@colour = colour
	end

	def self.colours
		@@colours		
	end

	def self.get_enemy_colour(loyal_colour)
		(@@colours - [loyal_colour])[0]
	end
end