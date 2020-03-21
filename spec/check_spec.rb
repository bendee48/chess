# frozen_string_literal: true

require_relative '../lib/models/player'
require_relative '../lib/models/pieces'
require_relative '../lib/game'
require_relative '../lib/check'

describe Check do
  let(:game) { Game.new }
  let(:check_if) { Check.new(game) }
  let(:player1) { Player.new('', 'black') }
  let(:player2) { Player.new('', 'white') }
  let(:pawn_white) { Pawn.new('white') }
  let(:knight_white) { Knight.new('white') }
  let(:rook_white) { Rook.new('white') }
  let(:bishop_white) { Bishop.new('white') }
  let(:queen_white) { Queen.new('white') }
  let(:king_white) { King.new('white') }
  let(:king_black) { King.new('black') }

  describe '#check?' do
    context 'Player2 checks Player1' do
      it 'returns true for a Bishop checking a King' do
        game.set_piece('c8', '-')
        game.set_piece('d2', '-')
        game.set_piece('c3', bishop_white)
        expect(check_if.check?(player1)).to eql true
      end

      it 'returns true for a Rook checking a King' do
        game.set_piece('e2', '-')
        game.set_piece('h8', '-')
        game.set_piece('f5', rook_white)
        game.player_move('f5', 'e5', player2)
        expect(check_if.check?(player1)).to eql true
      end

      it 'returns true for a Knight checking a King' do
        game.set_piece('g8', '-')
        game.set_piece('g5', knight_white)
        game.player_move('g5', 'f3', player2)
        expect(check_if.check?(player1)).to eql true
      end

      it 'returns true for a Pawn checking a King' do
        game.set_piece('e1', '-')
        game.set_piece('e8', '-')
        game.set_piece('f4', king_black)
        game.set_piece('c5', king_white)
        game.player_move('d2', 'd4', player1)
        game.player_move('g7', 'g5', player2)
        expect(check_if.check?(player1)).to eql true
        expect(check_if.check?(player2)).to eql true
      end

      it 'returns true for a King checking a King' do
        game.set_piece('e1', '-')
        game.set_piece('e8', '-')
        game.set_piece('d4', king_black)
        game.set_piece('e6', king_white)
        game.player_move('e6', 'd5', player2)
        expect(check_if.check?(player1)).to eql true
      end
    end

    context 'Player1 moves into check' do
      before(:each) do
        game.set_piece('e1', '-')
        game.set_piece('e3', king_black)
      end

      it 'returns true for Bishop checking King' do
        game.set_piece('c8', '-')
        game.set_piece('a6', bishop_white)
        expect(check_if.check?(player1)).to eql false
        game.player_move('e3', 'd3', player1)
        expect(check_if.check?(player1)).to eql true
      end

      it 'returns true for Queen checking King' do
        game.set_piece('d8', '-')
        game.set_piece('d6', queen_white)
        expect(check_if.check?(player1)).to eql false
        game.player_move('e3', 'd3', player1)
        expect(check_if.check?(player1)).to eql true
      end

      it 'returns true for Rook checking King' do
        game.set_piece('h8', '-')
        game.set_piece('f6', rook_white)
        expect(check_if.check?(player1)).to eql false
        game.player_move('e3', 'f3', player1)
        expect(check_if.check?(player1)).to eql true
      end

      it 'returns true for Pawn checking King' do
        game.player_move('f7', 'f5', player2)
        expect(check_if.check?(player1)).to eql false
        game.player_move('e3', 'e4', player1)
        expect(check_if.check?(player1)).to eql true
      end
    end

    describe "#check? isn't triggered incorrectly" do
      context 'piece blocks check' do
        it 'returns false for player piece blocking Bishop check' do
          game.set_piece('c8', '-')
          game.set_piece('c3', knight_white)
          expect(check_if.check?(player1)).to eql false
        end

        it 'returns false for opposition piece blocking Bishop check' do
          game.set_piece('c8', '-')
          game.set_piece('c7', '-')
          game.set_piece('b4', knight_white)
          game.set_piece('c3', pawn_white)
          expect(check_if.check?(player1)).to eql false
        end

        it 'returns false for opposition piece blocking Rook check' do
          game.set_piece('h8', '-')
          game.set_piece('h7', '-')
          game.set_piece('e2', '-')
          game.set_piece('e5', rook_white)
          game.set_piece('e4', pawn_white)
          expect(check_if.check?(player1)).to eql false
        end

        it 'returns false for opposition piece blocking Queen check' do
          game.set_piece('h8', '-')
          game.set_piece('h7', '-')
          game.set_piece('e1', '-')
          game.set_piece('g5', queen_white)
          game.set_piece('f5', pawn_white)
          game.set_piece('b5', king_black)
          expect(check_if.check?(player1)).to eql false
        end

        it 'returns false for a Knight being 2 moves away' do
          game.set_piece('g8', '-')
          game.set_piece('g5', knight_white)
          expect(check_if.check?(player1)).to eql false
        end

        it 'returns false for a Pawn attack being 2 moves away' do
          game.set_piece('e1', '-')
          game.set_piece('e8', '-')
          game.set_piece('f4', king_black)
          game.set_piece('c5', king_white)
          game.player_move('h7', 'h6', player2)
          game.player_move('a2', 'a3', player1)
          expect(check_if.check?(player1)).to eql false
        end

        it 'returns false for a King attack being 2 moves away' do
          game.set_piece('e1', '-')
          game.set_piece('e8', '-')
          game.set_piece('e3', king_black)
          game.set_piece('e5', king_white)
          expect(check_if.check?(player1)).to eql false
        end
      end
    end
  end

  describe '#check_mate?' do
    context 'King is in check' do
      it 'should return true if checkmate' do
        game.set_piece('e1', '-')
        game.set_piece('d8', '-')
        game.set_piece('a8', '-')
        game.set_piece('a3', king_black)
        game.set_piece('b5', queen_white)
        game.set_piece('a5', rook_white)
        expect(check_if.check_mate?(player1)).to eql true
      end
    end

    context "King isn't in check" do
      it 'should return true if checkmate' do
        game.board.empty
        game.set_piece('a1', king_black)
        game.set_piece('b3', queen_white)
        expect(check_if.check_mate?(player1)).to eql true
      end
    end
  end
end
