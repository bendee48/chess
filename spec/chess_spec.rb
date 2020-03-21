# frozen_string_literal: true

require_relative '../lib/models/pieces'
require_relative '../lib/game'
require_relative '../lib/models/player'
require_relative '../lib/check'

#change tests to use set piece & integration test
describe Game do
  let(:game) { Game.new }
  let(:player1) { Player.new('Dave', 'black') }
  let(:player2) { Player.new('Emma', 'white') }

  # describe "#player_setup" do
  #   it "sets up players with correct names" do
  #     allow(game).to receive(:gets).and_return("Ben", "black", "emma")
  #     game.play
  #     expect(game.player1).to eql "Ben"
  #     expect(game.player2).to eql "Emma"
  #   end

  # it "sets up players with their correct colours" do
  #   allow(game).to receive(:gets).and_return("Ben", "black", "emma")
  #   game.play
  #   expect(game.player1.color).to eql 'black'
  #   expect(game.player2.color).to eql 'white'
  #   # end
  # end
  context "#player_moves" do
    describe '#with Pawn' do
      it '1 up and replaces the previous square with a dash' do
        game.player_move('a2', 'a3', player1)
        expect(game.board.row_2[0]).to eql '-'
        expect(game.board.row_3[0]).to be_a Pawn
      end

      it 'up 2 if starting from row 2' do
        game.player_move('b2', 'b4', player1)
        expect(game.board.row_2[1]).to eql '-'
        expect(game.board.row_4[1]).to be_a Pawn
      end

      it 'takes a piece diagonally right' do
        game.player_move('b2', 'b4', player1)
        game.player_move('b4', 'b5', player1)
        game.player_move('b5', 'b6', player1)
        game.player_move('b6', 'c7', player1)
        expect(game.board.row_6[1]).to eql '-'
        expect(game.board.row_7[2]).to be_a Pawn
      end

      it "isn't allowed to move up if the square is occupied" do
        allow(game).to receive(:puts).and_return(nil)
        game.player_move('b2', 'b4', player1)
        game.player_move('b4', 'b5', player1)
        game.player_move('b5', 'b6', player1)
        game.player_move('b6', 'b7', player1)
        expect(game.board.row_6[1]).to be_a Pawn
      end

      it "isn't allowed to move sideways" do
        allow(game).to receive(:puts).and_return(nil)
        game.player_move('f2', 'f3', player1)
        game.player_move('f3', 'g3', player1)
        expect(game.board.row_3[6]).to eql '-'
        expect(game.board.row_3[5]).to be_a Pawn
      end

      it 'recognises invalid moves' do
        expect { game.player_move('a2', 'b2', player1) }.to output("Sorry, invalid move.\n").to_stdout
      end
    end

    describe '#with white pawn' do
      let(:player_white) { Player.new('Mark', 'white') }
      let(:pawn) { Pawn.new('white') }

      it 'moves down the board 1 square' do
        game.player_move('d7', 'd6', player_white)
        expect(game.board.row_7[3]).to eql '-'
        expect(game.board.row_6[3]).to be_a Pawn
      end

      it 'moves down the board 2 squares' do
        game.player_move('e7', 'e5', player_white)
        expect(game.board.row_7[4]).to eql '-'
        expect(game.board.row_5[4]).to be_a Pawn
      end

      it "takes a black piece to it's right" do
        game.set_piece('d3', pawn)
        game.player_move('d3', 'c2', player_white)
        expect(game.board.row_3[3]).to eql '-'
        expect(game.board.row_2[2]).to eql pawn
      end

      it "isn't allowed to move down if square is taken" do
        allow(game).to receive(:puts).and_return(nil)
        game.set_piece('d3', pawn)
        game.player_move('d3', 'd2', player_white)
        expect(game.board.row_3[3]).to eql pawn
        expect(game.board.row_2[3].color).to eql 'black'
      end
    end

    describe 'with a Rook' do
      let(:rook) { Rook.new('black') }
      before(:each) { game.set_piece('d4', rook) }

      it 'moves up more than 1 square' do
        game.player_move('d4', 'd6', player1)
        expect(game.board.row_4[3]).to eql '-'
        expect(game.board.row_6[3]).to eql rook
      end

      it 'moves down more than 1 square' do
        game.player_move('d4', 'd6', player1)
        game.player_move('d6', 'd3', player1)
        expect(game.board.row_6[3]).to eql '-'
        expect(game.board.row_3[3]).to eql rook
      end

      it 'moves right more than 1 square' do
        game.player_move('d4', 'g4', player1)
        expect(game.board.row_4[3]).to eql '-'
        expect(game.board.row_4[6]).to eql rook
      end

      it 'moves left more than 1 square' do
        game.player_move('d4', 'b4', player1)
        expect(game.board.row_4[3]).to eql '-'
        expect(game.board.row_4[1]).to eql rook
      end

      it "isn't allowed to move past it's own pieces" do
        allow(game).to receive(:puts).and_return(nil)
        game.player_move('d4', 'd2', player1)
        expect(game.board.row_4[3]).to eql rook
        expect(game.board.row_2[3]).to be_a Pawn
      end

      it "takes an opponent's piece" do
        game.player_move('d4', 'd7', player1)
        expect(game.board.row_4[3]).to eql '-'
        expect(game.board.row_7[3]).to eql rook
      end

      it "doesn't take the opponent's king" do
        allow(game).to receive(:puts).and_return(nil)
        king = King.new('white')
        game.set_piece('e4', king)
        game.player_move('d4', 'e4', player1)
        expect(game.board.row_4[3]).to eql rook
        expect(game.board.row_4[4]).to eql king
      end
    end

    describe 'with Bishop' do
      let(:bishop) { Bishop.new('black') }
      before(:each) { game.set_piece('d3', bishop) }

      it 'moves diagonally up and right more than 1 square' do
        game.player_move('d3', 'g6', player1)
        expect(game.board.row_3[3]).to eql '-'
        expect(game.board.row_6[6]).to eql bishop
      end

      it 'moves diagonally up and left more than 1 square' do
        game.player_move('d3', 'a6', player1)
        expect(game.board.row_3[3]).to eql '-'
        expect(game.board.row_6[0]).to eql bishop
      end

      it 'moves diagonally down and left more than 1 square' do
        game.player_move('d3', 'g6', player1)
        game.player_move('g6', 'e4', player1)
        expect(game.board.row_6[6]).to eql '-'
        expect(game.board.row_4[4]).to eql bishop
      end

      it 'moves diagonally down and right more than 1 square' do
        game.player_move('d3', 'a6', player1)
        game.player_move('a6', 'c4', player1)
        expect(game.board.row_6[0]).to eql '-'
        expect(game.board.row_4[2]).to eql bishop
      end

      it "isn't allowed to move past it's own pieces" do
        allow(game).to receive(:puts).and_return(nil)
        game.player_move('d3', 'f1', player1)
        expect(game.board.row_3[3]).to eql bishop
      end

      it "takes an opponent's piece" do
        game.player_move('d3', 'h7', player1)
        expect(game.board.row_3[3]).to eql '-'
        expect(game.board.row_7[7]).to eql bishop
      end

      it "doesn't take the opponents king" do
        allow(game).to receive(:puts).and_return(nil)
        king = King.new('white')
        game.set_piece('e4', king)
        game.player_move('d3', 'e4', player1)
        expect(game.board.row_3[3]).to eql bishop
        expect(game.board.row_4[4]).to eql king
      end
    end

    describe 'with a Queen' do
      let(:queen) { Queen.new('black') }
      before(:each) { game.set_piece('d4', queen) }

      it 'moves up vertically more than 1 square' do
        game.player_move('d4', 'd6', player1)
        expect(game.board.row_4[3]).to eql '-'
        expect(game.board.row_6[3]).to eql queen
      end

      it 'moves up diagonally right more than 1 square' do
        game.player_move('d4', 'f6', player1)
        expect(game.board.row_4[3]).to eql '-'
        expect(game.board.row_6[5]).to eql queen
      end

      it 'moves right horizontally more than 1 square' do
        game.player_move('d4', 'g4', player1)
        expect(game.board.row_4[3]).to eql '-'
        expect(game.board.row_4[6]).to eql queen
      end

      it 'moves down diagonally right more than 1 square' do
        game.player_move('d4', 'e5', player1)
        game.player_move('e5', 'g3', player1)
        expect(game.board.row_5[4]).to eql '-'
        expect(game.board.row_3[6]).to eql queen
      end

      it 'moves down more than 1 square' do
        game.player_move('d4', 'd5', player1)
        game.player_move('d5', 'd3', player1)
        expect(game.board.row_5[3]).to eql '-'
        expect(game.board.row_3[3]).to eql queen
      end

      it 'moves down diagonally left more than 1 square' do
        game.player_move('d4', 'd5', player1)
        game.player_move('d5', 'b3', player1)
        expect(game.board.row_5[3]).to eql '-'
        expect(game.board.row_3[1]).to eql queen
      end

      it 'moves left horizontally more than 1 square' do
        game.player_move('d4', 'a4', player1)
        expect(game.board.row_4[3]).to eql '-'
        expect(game.board.row_4[0]).to eql queen
      end

      it 'moves up diagonally left more than 1 square' do
        game.player_move('d4', 'b6', player1)
        expect(game.board.row_4[3]).to eql '-'
        expect(game.board.row_6[1]).to eql queen
      end

      it "isn't allowed to move past it's own pieces" do
        allow(game).to receive(:puts).and_return(nil)
        game.player_move('d4', 'b2', player1)
        expect(game.board.row_4[3]).to eql queen
      end

      it 'takes an opponents piece' do
        game.player_move('d4', 'd7', player1)
        expect(game.board.row_4[3]).to eql '-'
        expect(game.board.row_7[3]).to eql queen
      end

      it "doesn't take the opponents King" do
        allow(game).to receive(:puts).and_return(nil)
        king = King.new('white')
        game.set_piece('e5', king)
        game.player_move('d4', 'e5', player1)
        expect(game.board.row_4[3]).to eql queen
        expect(game.board.row_5[4]).to eql king
      end
    end

    describe 'with a King' do
      let(:king) { King.new('black') }
      before(:each) { game.set_piece('d4', king) }

      it 'moves up 1 square' do
        game.player_move('d4', 'd5', player1)
        expect(game.board.row_4[3]).to eql '-'
        expect(game.board.row_5[3]).to eql king
      end

      it 'moves diagonally up right 1 square' do
        game.player_move('d4', 'e5', player1)
        expect(game.board.row_4[3]).to eql '-'
        expect(game.board.row_5[4]).to eql king
      end

      it 'moves right 1 square' do
        game.player_move('d4', 'e4', player1)
        expect(game.board.row_4[3]).to eql '-'
        expect(game.board.row_4[4]).to eql king
      end

      it 'moves diagonally down right 1 square' do
        game.player_move('d4', 'e3', player1)
        expect(game.board.row_4[3]).to eql '-'
        expect(game.board.row_3[4]).to eql king
      end

      it 'moves down 1 square' do
        game.player_move('d4', 'd3', player1)
        expect(game.board.row_4[3]).to eql '-'
        expect(game.board.row_3[3]).to eql king
      end

      it 'moves diagonally down left 1 square' do
        game.player_move('d4', 'c3', player1)
        expect(game.board.row_4[3]).to eql '-'
        expect(game.board.row_3[2]).to eql king
      end

      it 'moves up 1 square' do
        game.player_move('d4', 'c4', player1)
        expect(game.board.row_4[3]).to eql '-'
        expect(game.board.row_4[2]).to eql king
      end

      it 'moves diagonally up left 1 square' do
        game.player_move('d4', 'c5', player1)
        expect(game.board.row_4[3]).to eql '-'
        expect(game.board.row_5[2]).to eql king
      end

      it "isn't allowed to move past it's own pieces" do
        allow(game).to receive(:puts).and_return(nil)
        game.player_move('d4', 'd3', player1)
        game.player_move('d3', 'd2', player1)
        expect(game.board.row_3[3]).to eql king
      end

      it 'takes an opponents piece' do
        game.player_move('d4', 'd5', player1)
        game.player_move('d5', 'd6', player1)
        game.player_move('d6', 'c7', player1)
        expect(game.board.row_6[3]).to eql '-'
        expect(game.board.row_7[2]).to eql king
      end

      it "doesn't take the opponent's King" do
        allow(game).to receive(:puts).and_return(nil)
        white_king = King.new('white')
        game.set_piece('e4', white_king)
        game.player_move('d4', 'e4', player1)
        expect(game.board.row_4[3]).to eql king
        expect(game.board.row_4[4]).to eql white_king
      end

      it "can't move more than 1 square" do
        allow(game).to receive(:puts).and_return(nil)
        game.player_move("d4", "d6", player1)
        expect(game.board.row_6[3]).to eql '-'
      end
    end

    describe 'with a Knight' do
      let(:knight) { Knight.new('black') }
      before(:each) do
        game.set_piece('d4', knight)
        game.board.row_2.map! { |_sq| sq = '-' }
      end

      it 'moves 2 up, 1 right' do
        game.player_move('d4', 'e6', player1)
        expect(game.board.row_4[3]).to eql '-'
        expect(game.board.row_6[4]).to eql knight
      end

      it 'moves 2 right, 1 up' do
        game.player_move('d4', 'f5', player1)
        expect(game.board.row_4[3]).to eql '-'
        expect(game.board.row_5[5]).to eql knight
      end

      it 'moves 2 right, 1 down' do
        game.player_move('d4', 'f3', player1)
        expect(game.board.row_4[3]).to eql '-'
        expect(game.board.row_3[5]).to eql knight
      end

      it 'moves 1 right, 2 down' do
        game.player_move('d4', 'e2', player1)
        expect(game.board.row_4[3]).to eql '-'
        expect(game.board.row_2[4]).to eql knight
      end

      it 'moves 1 left, 2 down' do
        game.player_move('d4', 'c2', player1)
        expect(game.board.row_4[3]).to eql '-'
        expect(game.board.row_2[2]).to eql knight
      end

      it 'moves 2 left, 1 down' do
        game.player_move('d4', 'b3', player1)
        expect(game.board.row_4[3]).to eql '-'
        expect(game.board.row_3[1]).to eql knight
      end

      it 'moves 2 left, 1 up' do
        game.player_move('d4', 'b5', player1)
        expect(game.board.row_4[3]).to eql '-'
        expect(game.board.row_5[1]).to eql knight
      end

      it 'moves 1 left, 2 up' do
        game.player_move('d4', 'c6', player1)
        expect(game.board.row_4[3]).to eql '-'
        expect(game.board.row_6[2]).to eql knight
      end

      it "it jumps over it's own pieces" do
        game.board.row_2.map! { |_sq| sq = Pawn.new('black') }
        game.player_move('b1', 'c3', player1)
        expect(game.board.row_1[1]).to eql '-'
        expect(game.board.row_3[2]).to be_a Knight
      end

      it "takes an opponent's piece" do
        game.player_move('d4', 'f5', player1)
        game.player_move('f5', 'e7', player1)
        expect(game.board.row_5[5]).to eql '-'
        expect(game.board.row_7[4]).to eql knight
      end

      it "doesn't take the opponent's King" do
        allow(game).to receive(:puts).and_return(nil)
        game.player_move('d4', 'b5', player1)
        game.player_move('b5', 'd6', player1)
        game.player_move('d6', 'e8', player1)
        expect(game.board.row_6[3]).to eql knight
        expect(game.board.row_8[4]).to be_a King
      end
    end
  end
end