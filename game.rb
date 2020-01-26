require './board'
require './player'

class Game
  attr_accessor :board
  
  def initialize
    @board = Board.new
  end

  def move(start, finish)
    # 2 sets of coordinates 
    # check to see what piece is in that start position
    # eg "a1 a3"
    let, num = start.chars
    board.return_board[num.to_i - 1][let.ord - 97]
    # returns ^ start piece 
    # what moves it has available and verify the move is valid
    # move piece
  end
  
end