require './board'
require './pieces'

module Textable
  @board = Board.new
  @knight = Knight.new('black')

  def self.introduction
    puts "Welcome to Chess."
    puts "Enter 'i' if you'd like instructions or press return to continue."
  end

  def self.instructions
    puts "The game follows standard Chess rules. " \
     "The aim is to beat your opponent by obtaining checkmate."; sleep 3
    puts "Each row to the board is represented by a number (1-8)."; sleep 3
    puts "Each column to the board is represented by a letter (A-H)."; sleep 3
    puts "To make you're move enter the starting coordinates for the piece you wish to move."; sleep 3
    puts "Followed by a space, and then the end coordinates for the piece you wish to move."; sleep 3
    self.move_piece
    puts "Either player can save and exit the game at any time by entering 'save' " \
      "when prompted to make their move."; sleep 2
    puts "Enjoy!"; sleep 2
  end

  def self.load
    puts "Enter 'load' to resume a previously saved game." 
    puts "Or enter 'new' to start a new game:"
  end

  def self.move_piece
    puts "\nFor example, 'B1 C3' would result in the black knight being moved."; sleep 5
    @board.row_1[1] = '-'
    @board.row_3[2] = @knight
    @board.display_board
    puts
  end
end