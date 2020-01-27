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
    # check that coordinates are valid first before generating moves etc
    let, num = start.chars
    start_place = board.return_board[num.to_i - 1][let.ord - 97]

    # returns ^ start piece 
    # what moves it has available and verify the move is valid
    # move piece
  end

  def valid_pawn_move?(start, finish)
    valid_moves = []
    
  end

  def possible_pawn_moves(start, player)
    let, num = start.scan(/[a-z]|\d+/)
    valid_moves = []

    one_up = start.next
    valid_moves << one_up if return_piece(one_up) == "-"

    two_up = one_up.next
    valid_moves << two_up if return_piece(two_up) == "-" && num == "2"

    right_attack = "#{let.next}#{num.next}"
    valid_moves << right_attack if return_piece(right_attack).is_a?(ChessPiece) && 
                                   return_piece(right_attack).name != "king" &&
                                   return_piece(right_attack).color != player.color

    left_attack = "#{(let.ord - 1).chr}#{num.to_i + 1}"
    valid_moves << left_attack if return_piece(left_attack).is_a?(ChessPiece) && 
                                  return_piece(left_attack).name != "king" &&
                                  return_piece(left_attack).color != player.color

    valid_moves
  end

  def return_piece(coordinates)
    let, num = coordinates.scan(/[a-z]|\d+/)
    return "error" unless ("a".."h") === let && ("1".."8") === num
    board.return_board[num.to_i - 1][let.ord - 97]
  end

  
  
end