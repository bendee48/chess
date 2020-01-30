require './board'
require './player'
require 'pry'

class Game
  attr_accessor :board
  
  def initialize
    @board = Board.new
  end

  def player_move(start, finish, player)
    start_piece = return_piece(start).name

    case start_piece
    when "pawn"
      if valid_pawn_move?(start, finish, player)
        start_let, start_num = start.scan(/[a-z]|\d+/)
        finish_let, finish_num = finish.scan(/[a-z]|\d+/)
        board.return_board[finish_num.to_i - 1][finish_let.ord - 97] = return_piece(start)
        board.return_board[start_num.to_i - 1][start_let.ord - 97] = "-"
      else
        puts "Sorry, invalid move."
      end
    when "rook"
      valid_moves = []

      current_square = start
      loop do #up
        current_square = current_square.next
        (valid_moves << current_square; next) if return_piece(current_square) == "-"
        (valid_moves << current_square; break) if return_piece(current_square).color != player.color &&
                                                  return_piece(current_square).name != "king"
        break if return_piece(current_square).color == player.color
      end
      #down
      current_square = start
      loop do
        current_let, current_num = current_square.scan(/[a-z]|\d+/)
        current_square = "#{current_let}#{current_num.to_i - 1}"
        break if return_piece(current_square) == "error"
        (valid_moves << current_square; next) if return_piece(current_square) == "-"
        (valid_moves << current_square; break) if return_piece(current_square).color != player.color &&
                                                  return_piece(current_square).name != "king"
        break if return_piece(current_square).color == player.color
      end

      #right
      current_square = start
      loop do
        current_let, current_num = current_square.scan(/[a-z]|\d+/)
        current_square = "#{current_let.next}#{current_num}"
        break if return_piece(current_square) == "error"
        (valid_moves << current_square; next) if return_piece(current_square) == "-"
        (valid_moves << current_square; break) if return_piece(current_square).color != player.color &&
                                                  return_piece(current_square).name != "king"
        break if return_piece(current_square).color == player.color
      end

      #left
      current_square = start
      loop do
        current_let, current_num = current_square.scan(/[a-z]|\d+/)
        current_square = "#{(current_let.ord - 1).chr}#{current_num}"
        break if return_piece(current_square) == "error"
        (valid_moves << current_square; next) if return_piece(current_square) == "-"
        (valid_moves << current_square; break) if return_piece(current_square).color != player.color &&
                                                  return_piece(current_square).name != "king"
        break if return_piece(current_square).color == player.color
      end

      if valid_moves.include?(finish)
        start_let, start_num = start.scan(/[a-z]|\d+/)
        finish_let, finish_num = finish.scan(/[a-z]|\d+/)
        board.return_board[finish_num.to_i - 1][finish_let.ord - 97] = return_piece(start)
        board.return_board[start_num.to_i - 1][start_let.ord - 97] = "-"
      end


    end

  end

  private

  def valid_pawn_move?(start, finish, player)
    valid_moves = possible_pawn_moves(start, player)
    valid_moves.include?(finish)    
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