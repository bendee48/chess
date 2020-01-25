require './pieces'

describe "#Test" do
  it "is a test" do
    expect(true).to eql true
  end
end

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