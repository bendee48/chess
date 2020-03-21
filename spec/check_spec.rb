# frozen_string_literal: true

require_relative '../lib/models/player'
require_relative '../lib/models/pieces'
require_relative '../lib/game'
require_relative '../lib/check'

##use doubles and mocks??

describe Check do
  let(:game) { Game.new }
  let(:check_if) { Check.new(game) }
  let(:player1) { Player.new('', 'black') }
  let(:player2) { Player.new('', 'white') }

  describe "#check?" do
    context "Player2 checks Player1" do
      it "returns true for a bishop checking a king" do
        game.set_piece('c8', '-')
        game.set_piece('d2', '-')
        game.set_piece('c3', Bishop.new('white'))
        expect(check_if.check?(player1)).to eql true
      end
    
      it "returns true for a rook checking a king" do
        game.set_piece('e2', '-')
        game.set_piece('h8', '-')
        game.set_piece('f5', Rook.new('white'))
        game.player_move('f5', 'e5', player2)
        expect(check_if.check?(player1)).to eql true
      end
    
      it "returns true for a knight checking a king" do
        game.set_piece('g8', '-')
        game.set_piece('g5', Knight.new('white'))
        game.player_move('g5', 'f3', player2)
        expect(check_if.check?(player1)).to eql true
      end
    
      it "returns true for a pawn checking a king" do
        game.set_piece('e1', '-')
        game.set_piece('e8', '-')
        game.set_piece('f4', King.new('black'))
        game.set_piece('c5', King.new('white'))
        game.player_move('d2', 'd4', player1)
        game.player_move('g7', 'g5', player2)
        expect(check_if.check?(player1)).to eql true
        expect(check_if.check?(player2)).to eql true
      end
    end
    
    context "Player1 moves into check" do
      before(:each) do
        game.set_piece('e1', '-')
        game.set_piece('e3', King.new('black'))
      end
    
      it "returns true for Bishop checking King" do
        game.set_piece('c8', '-')
        game.set_piece('a6', Bishop.new('white'))
        expect(check_if.check?(player1)).to eql false
        game.player_move('e3', 'd3', player1)
        expect(check_if.check?(player1)).to eql true
      end
    
      it "returns true for Queen checking King" do
        game.set_piece('d8', '-')
        game.set_piece('d6', Queen.new('white'))
        expect(check_if.check?(player1)).to eql false
        game.player_move('e3', 'd3', player1)
        expect(check_if.check?(player1)).to eql true
      end
    
      it "returns true for Rook checking King" do
        game.set_piece('h8', '-')
        game.set_piece('f6', Rook.new('white'))
        expect(check_if.check?(player1)).to eql false
        game.player_move('e3', 'f3', player1)
        expect(check_if.check?(player1)).to eql true
      end
    
      it "returns true for Pawn checking King" do
        game.player_move('f7', 'f5', player2)
        expect(check_if.check?(player1)).to eql false
        game.player_move('e3', 'e4', player1)
        expect(check_if.check?(player1)).to eql true
      end
    end

    describe "#check? isn't triggered incorrectly" do
      context "piece blocks check" do
        it "returns false for player piece blocking Bishop check" do
          game.set_piece('c8', '-')
          game.set_piece('c3', Bishop.new('white'))
          expect(check_if.check?(player1)).to eql false
        end

        it "returns false for opposition piece blocking Bishop check" do
          game.set_piece('c8', '-')
          game.set_piece('c7', '-')
          game.set_piece('b4', Bishop.new('white'))
          game.set_piece('c3', Pawn.new('white'))
          expect(check_if.check?(player1)).to eql false
        end

        it "returns false for opposition piece blocking Rook check" do
          game.set_piece('h8', '-')
          game.set_piece('h7', '-')
          game.set_piece('e2', '-')
          game.set_piece('e5', Rook.new('white'))
          game.set_piece('e4', Pawn.new('white'))
          expect(check_if.check?(player1)).to eql false
        end

        it "returns false for opposition piece blocking Queen check" do
          game.set_piece('h8', '-')
          game.set_piece('h7', '-')
          game.set_piece('e1', '-')
          game.set_piece('g5', Queen.new('white'))
          game.set_piece('f5', Pawn.new('white'))
          game.set_piece('b5', King.new('black'))
          expect(check_if.check?(player1)).to eql false
        end

        it "returns false for a Knight being 2 moves away" do
          game.set_piece('g8', '-')
          game.set_piece('g5', Knight.new('white'))
          expect(check_if.check?(player1)).to eql false
        end

        it "returns false for a pawn attack being 2 moves away" do
          game.set_piece('e1', '-')
          game.set_piece('e8', '-')
          game.set_piece('f4', King.new('black'))
          game.set_piece('c5', King.new('white'))
          game.player_move('h7', 'h6', player2)
          game.player_move('a2', 'a3', player1)
          expect(check_if.check?(player1)).to eql false
        end
      end
    end
  end

  describe "#check_mate?" do
    it "should return true if checkmate" do
      king = King.new('black')
      queen = Queen.new('white')
      game.set_piece('e1', '-')
      game.set_piece('d8', '-')
      game.set_piece('a3', king)
      game.set_piece('b5', queen)
      game.board.display_board
      expect(check_if.check_mate?(player1)).to eql true
    end
  end
end

