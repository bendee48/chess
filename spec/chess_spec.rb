require './pieces'
require './game'
require './player'

describe "ChessPiece" do
  describe "initialize sets up Pawn object correctly" do
    let(:pawn) { Pawn.new('black') }

    it "sets pawn piece color" do
      expect(pawn.color).to eql 'black'
    end

    it "sets up pawn with #moves attribute" do
      expect(pawn.moves).to eql nil
    end

    it "sets the correct unicode depending on color" do
      expect(pawn.unicode).not_to eql "\u265F"
    end
  end

  describe "initialize sets up knight object correctly" do
    let(:knight) { Knight.new('white') }

    it "sets knight default_symbol to K" do
      expect(knight.default_symbol).to eql "K"
    end

  end

  describe "initialize sets up queen object correctly" do
    let(:queen) { Queen.new('black') }

    it "sets the correct name" do
      expect(queen.color).to eql 'black'
    end

    it "sets the correct unicode" do
      expect(queen.unicode).to eql "\u2655"
    end
  end
end

describe "Game" do
  let(:game) { Game.new }
  let(:player) { Player.new("Dave", "black") }

  describe "#player_move with Pawn" do
    it "moves a pawn 1 up and replaces the previous square with a dash" do
      game.player_move("a2", "a3", player)
      expect(game.board.row_2[0]).to eql "-"
      expect(game.board.row_3[0]).to be_a Pawn 
    end

    it "moves a pawn up 2 if starting from row 2" do
      game.player_move("b2", "b4", player)
      expect(game.board.row_2[1]).to eql "-"
      expect(game.board.row_4[1]).to be_a Pawn 

    end

    it "takes a piece diagonally right of a pawn" do
      game.player_move("b2", "b4", player)
      game.player_move("b4", "b5", player)
      game.player_move("b5", "b6", player)
      game.player_move("b6", "c7", player)
      expect(game.board.row_6[1]).to eql "-"
      expect(game.board.row_7[2]).to be_a Pawn 
    end

    it "doesn't allow a pawn to move up if the square is occupied" do
      game.player_move("b2", "b4", player)
      game.player_move("b4", "b5", player)
      game.player_move("b5", "b6", player)
      game.player_move("b6", "b7", player)
      expect(game.board.row_6[1]).to be_a Pawn
    end

    it "isn't allowed to move sideways" do
      game.player_move("f2", "f3", player)
      game.player_move("f3", "g3", player)
      expect(game.board.row_3[6]).to eql "-"
      expect(game.board.row_3[5]).to be_a Pawn
    end

    it "recognises invalid moves" do
      expect { game.player_move("a2", "b2", player) }.to output("Sorry, invalid move.\n").to_stdout
    end

  end

  describe "#player_move with a Rook" do
    let(:rook) { Rook.new("black") }
    before(:each) { game.board.row_4[3] = rook }

    it "moves up more than 1 square" do
      game.player_move("d4", "d6", player)
      expect(game.board.row_4[3]).to eql "-"
      expect(game.board.row_6[3]).to eql rook
    end

    it "moves down more than 1 square" do
      game.player_move("d4", "d6", player)
      game.player_move("d6", "d3", player)
      expect(game.board.row_6[3]).to eql "-"
      expect(game.board.row_3[3]).to eql rook
    end

    it "moves right more than 1 square" do
      game.player_move("d4", "g4", player)
      expect(game.board.row_4[3]).to eql "-"
      expect(game.board.row_4[6]).to eql rook
    end

    it "moves left more than 1 square" do
      game.player_move("d4", "b4", player)
      expect(game.board.row_4[3]).to eql "-"
      expect(game.board.row_4[1]).to eql rook
    end

    it "isn't allowed to move past it's own pieces" do
      game.player_move("d4", "d2", player)
      expect(game.board.row_4[3]).to eql rook
      expect(game.board.row_2[3]).to be_a Pawn
    end

    it "takes an opponents piece" do
      game.player_move("d4", "d7", player)
      expect(game.board.row_4[3]).to eql "-"
      expect(game.board.row_7[3]).to eql rook
    end

    it "doesn't take the opponents king" do
      king = King.new("white")
      game.board.row_4[4] = king
      game.player_move("d4", "e4", player)
      expect(game.board.row_4[3]).to eql rook
      expect(game.board.row_4[4]).to eql king
    end

  end
end