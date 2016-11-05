class Player
	attr_reader :colour
	def self.create(colour)
		puts "Enter your name:"		
		name = gets.chomp
		self.new(name, colour)
	end

	private

	def initialize(name, colour)
		@name = name		
		@colour = colour
	end

	def to_s
		"#{@name} (#{@colour})"
	end
end