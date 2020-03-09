# frozen_string_literal: true

require './pieces'

class Board
  attr_accessor :row_1, :row_2, :row_3, :row_4,
                :row_5, :row_6, :row_7, :row_8

  def initialize
    create_board
    populate_board
  end

  def return_board
    [row_1, row_2, row_3, row_4, row_5, row_6, row_7, row_8]
  end

  def display_board
    num = 8
    puts "\n    a b c d e f g h"
    puts
    return_board.reverse_each do |row|
      row = row.map { |piece| piece.is_a?(ChessPiece) ? piece.unicode : piece }
      puts sprintf(" #{num}  %s %s %s %s %s %s %s %s  #{num}", *row)
      num -= 1
    end
    puts
    puts "    a b c d e f g h\n"
  end

  private

  def create_board
    (1..8).each do |num| 
      instance_variable_set("@row_#{num}", Array.new(8, '-'))
    end
  end

  def populate_board
    populate_royalty
    populate_pawns
  end

  def generate_piece(num)
    (1..num).map { yield }
  end

  def populate_royalty
    pieces = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    %w[black white].each do |color|
      pieces.each_with_index do |piece, ind|
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
        row[ind] = if row == row_2
                     Pawn.new('black')
                   else
                     Pawn.new('white')
                   end
      end
    end
  end

  # add default symbol method
end
