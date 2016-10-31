require "chess.rb"
require "player.rb"
require "board.rb"

describe Chess do
	describe ".setup" do
		context "instantiating itself" do			
			let(:block_console) do
				allow(Object).to receive(:gets).and_return("Bob", "Nick")
				allow(Object).to receive(:puts){}
			end
			let(:game) do
				block_console
				Chess.setup
			end

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

	describe "#get_move" do
		let(:player1) do
			player1 = double("player 1")
			allow(player1).to receive(:colour){ "white" }
			player1
		end
		let(:player2) do
			player2 = double("player 2")
			allow(player2).to receive(:colour){ "black" }
			player2
		end
		let(:game) do			
			board = Board.new
			game = Chess.new(player1, player2, board)
			game
		end
		#TODO: check all possibilities instead of random ones
		context "resolving positively" do 
			it do
				allow(game).to receive(:read_user_input){ [(1..8).to_a.sample, ("a".."h").to_a.sample].shuffle.join }
				expect(game.send(:get_move)).to be_an_instance_of Array
			end
		end
		context "resolving negatively" do 
			it do
				allow(game).to receive(:read_user_input){ [(9..100).to_a.sample, ("k".."z").to_a.sample].shuffle.join }
				expect(game.send(:get_move)).to be_nil
			end
		end
	end
end