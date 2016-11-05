class Chessman
	attr_reader :colour
	@@colours = ["white", "black"]
	def initialize(colour)
		@colour = colour
	end

	def self.colours
		@@colours		
	end
end