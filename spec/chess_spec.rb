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

    it "sets pawn default symbol to P" do
      expect(pawn.default_symbol).to eql 'P'
    end
    
    it "sets up pawn with #moves attribute" do
      expect(pawn.moves).to eql nil
    end

    it "sets the correct unicode depending on color" do
      expect(pawn.unicode).not_to eql "\u265F"
    end
  end
end