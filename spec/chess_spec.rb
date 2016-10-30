require "chess.rb"
require "player.rb"
require "board.rb"

describe Chess do
	describe ".setup" do
		context "instantiating itself" do			
			let(:game){ Chess.setup }

			it do
				expect(Chess).to receive(:new).once
				game
			end

			it do
				expect(game).to be_an_instance_of(Chess)
			end

			it "setting up players" do						
				expect(game.instance_variable_get(:@player1)).to be_an_instance_of(Player)
				expect(game.instance_variable_get(:@player2)).to be_an_instance_of(Player)
			end

			it "setting up board" do
				expect(game.instance_variable_get(:@board)).to be_an_instance_of(Board)
			end
		end
	end	
end