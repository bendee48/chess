require './pieces'

class Board
  attr_accessor :board, :col_a, :col_b, :col_c, :col_d,
                :col_e, :col_f, :col_g, :col_h

  def initialize
    create_board
  end

  def create_board
    ("a".."h").each { |let| instance_variable_set("@col_#{let}", Array.new(8)) }
  end

  def return_board
    [col_a, col_b, col_c, col_d, col_e, col_f, col_g, col_h]
  end

  def populate_board
    rooks = generate_piece(2) { Rook.new('rook', 'black', '\u265C', 'R') }
    knights = generate_piece(2) { Knight.new('knight', 'black', '\u265E', 'K') }
    bishops = generate_piece(2) { Bishop.new('bishop', 'black', '\u265D', 'B') }
    queen = generate_piece(1) { Queen.new('queen', 'black', '\u265B', 'Q') }
    king = generate_piece(1) { King.new('king', 'black', '\u265A', 'K') }
    pawns = generate_piece(8) { Pawn.new('pawn', 'black', '\u265F', 'P') }

  end

  private

  def generate_piece(num)
    (1..num).map { yield }
  end
  
end