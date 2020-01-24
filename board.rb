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

  def populate_board
    rooks = generate_piece(2) { Rook.new('rook', 'black', '\u265C', 'R') }
    knights = generate_piece(2) { Knight.new('knight', 'black', '\u265E', 'K') }
    bishops = generate_piece(2) { Bishop.new('bishop', 'black', '\u265D', 'B') }
    queen = generate_piece(1) { Queen.new('queen', 'black', '\u265B', 'Q') }
    king = generate_piece(1) { King.new('king', 'black', '\u265A', 'K') }
    pawns = generate_piece(8) { Pawn.new('pawn', 'black', '\u265F', 'P') }

    ['rook', 'knight', 'bishop'].each { |x| row_1[0] = 'rook' }

  end

  private

  def generate_piece(num)
    (1..num).map { yield }
  end
  
end