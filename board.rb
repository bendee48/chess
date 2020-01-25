require './pieces'

class Board
  attr_accessor :row_1, :row_2, :row_3, :row_4,
                :row_5, :row_6, :row_7, :row_8

  def initialize
    create_board
  end

  def create_board
    (1..8).each { |num| instance_variable_set("@row_#{num}", Array.new(8)) }
  end

  def return_board
    [row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8]
  end

  def display_board
    return_board.reverse_each do |row|
      row = row.map { |piece| piece.unicode if piece.is_a?(ChessPiece) }
      puts " %s %s %s %s %s %s %s %s" % row
    end
    nil
  end

  def populate_board
    populate_royalty
    populate_pawns
  end

  private

  

  def generate_piece(num)
    (1..num).map { yield }
  end

  def populate_royalty
    ['black', 'white'].each do |color|
      [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook].each_with_index do |piece, ind|
        if color == 'black' 
          row_1[ind] = piece.new(color)
        else
          row_8[ind] = piece.new(color)
        end
      end
    end
  end
  
  def populate_pawns
    [row_2, row_7].each do |row|
      row.each_with_index do |_, ind|
        if row == row_2
          row[ind] = Pawn.new('black')
        else
          row[ind] = Pawn.new('white')
        end
      end 
    end
  end

end