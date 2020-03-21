# frozen_string_literal: true

require_relative '../lib/models/pieces'

describe ChessPiece do
  context "#initialize" do
    describe "sets up Pawn object correctly" do
      let(:pawn) { Pawn.new("black") }

      it "sets Pawn piece color" do
        expect(pawn.color).to eql 'black'
      end

      it "sets up Pawn with #moves attribute" do
        expect(pawn.moves).to eql nil
      end

      it "sets the correct unicode depending on color" do
        expect(pawn.unicode).not_to eql "\u265F"
      end
    end

    describe "sets up Knight object correctly" do
      let(:knight) { Knight.new('white') }

      it "sets Knight default_symbol to K" do
        expect(knight.default_symbol).to eql 'K'
      end
    end

    describe "sets up Queen object correctly" do
      let(:queen) { Queen.new('black') }

      it "sets the correct name" do
        expect(queen.color).to eql 'black'
      end

      it "sets the correct unicode" do
        expect(queen.unicode).to eql "\u2655"
      end
    end
  end
end