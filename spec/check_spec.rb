# frozen_string_literal: true

require_relative '../lib/models/player'
require_relative '../lib/models/pieces'
require_relative '../lib/game'
require_relative '../lib/check'

##use doubles and mocks??

describe Check do
  let(:game) { Game.new }
  let(:check_if) { Check.new(game) }
  let(:player) { Player.new('', 'black') }
  let(:player2) { Player.new('', 'white') }

  describe "#check?" do
    it "returns true for a bishop checking a king" do
      game.player_move('d2', 'd3', player)
      game.board.row_3[2] = Queen.new('white')
      expect(check_if.check?(player)).to eql true
    end

    it "returns true for a rook checking a king" do
      game.board.row_2[4] = '-'
      game.board.row_5[4] = Rook.new('white')
      expect(check_if.check?(player)).to eql true
    end

    it "returns true for a knight checking a king" do
      game.board.row_3[5] = Knight.new('white')
      expect(check_if.check?(player)).to eql true
    end

    it "returns true for a pawn checking a king" do
      game.board.row_1[4] = '-'
      game.board.row_8[4] = '-'
      game.board.row_3[3] = King.new('white')
      game.board.row_6[3] = King.new('black')
      expect(check_if.check?(player)).to eql true
      expect(check_if.check?(player2)).to eql true
    end
  end

  describe "#check_mate?" do
    it "should return true if checkmate" do
      king = King.new('black')
      queen = Queen.new('white')
      game.set_piece('e1', '-')
      game.set_piece('a3', king)
      game.set_piece('b5', queen)
      expect(check_if.check_mate?(player)).to eql true
    end
  end

end