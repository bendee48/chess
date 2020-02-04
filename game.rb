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
      possible_moves = possible_pawn_moves(start, player)

      if valid_move?(possible_moves, finish)
        move_piece(start, finish)
      else
        puts "Sorry, invalid move."
      end
    when "rook"
      possible_moves = possible_rook_moves(start, player)

      if valid_move?(possible_moves, finish)
        move_piece(start, finish)    
      else
        puts "Sorry, invalid move."    
      end
    when "bishop"
      possible_moves = possible_bishop_moves(start, player)

      if valid_move?(possible_moves, finish)
        move_piece(start, finish)
      else
        puts "Sorry, invalid move."
      end
    when "queen"
      possible_moves = possible_queen_moves(start, player)

      if valid_move?(possible_moves, finish)
        move_piece(start, finish)
      else
        puts "Sorry, invalid move."
      end
    when "king"
      possible_moves = possible_king_moves(start, player)

      if valid_move?(possible_moves, finish)
        move_piece(start, finish)
      else
        puts "Sorry, Invalid move."
      end
    when "knight"
      possible_moves = possible_knight_moves(start, player)

      if valid_move?(possible_moves, finish)
        move_piece(start, finish)
      else
        puts "Sorry, invalid move."
      end
    end 
  end

  private

  def return_piece(coordinates)
    let, num = coordinates.scan(/[a-z]|\d+/)
    return "error" unless ("a".."h") === let && ("1".."8") === num
    board.return_board[num.to_i - 1][let.ord - 97]
  end 

  def move_piece(start, finish)
    start_let, start_num = start.scan(/[a-z]|\d+/)
    finish_let, finish_num = finish.scan(/[a-z]|\d+/)
    board.return_board[finish_num.to_i - 1][finish_let.ord - 97] = return_piece(start)
    board.return_board[start_num.to_i - 1][start_let.ord - 97] = "-"
  end

  def valid_move?(moves, finish)
    moves.include?(finish)
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

  def possible_rook_moves(start, player)
    valid_moves = []

    ['up', 'down', 'left', 'right'].each do |dir|
      current_square = start
      loop do
        current_let, current_num = current_square.scan(/[a-z]|\d+/)
        case dir
        when "up"
          current_square = "#{current_let}#{current_num.to_i + 1}"
        when "down"
          current_square = "#{current_let}#{current_num.to_i - 1}"
        when "left"
          current_square = "#{(current_let.ord - 1).chr}#{current_num}"
        when "right"
          current_square = "#{(current_let.ord + 1).chr}#{current_num}"
        end

        break if return_piece(current_square) == "error"
        (valid_moves << current_square; next) if return_piece(current_square) == "-"
        (valid_moves << current_square; break) if return_piece(current_square).color != player.color &&
                                                  return_piece(current_square).name != "king"
        break if return_piece(current_square).color == player.color
      end
    end
    valid_moves
  end   

  def possible_bishop_moves(start, player)
    valid_moves = []

    ["up_right", "up_left", "down_left", "down_right"].each do |dir|
      current_square = start      
      loop do        
        current_let, current_num = current_square.scan(/[a-z]|\d+/)
        case dir
        when "up_right"
          current_square = "#{(current_let.ord + 1).chr}#{current_num.to_i + 1}"
        when "up_left"
          current_square = "#{(current_let.ord - 1).chr}#{current_num.to_i + 1}"
        when "down_left"
          current_square = "#{(current_let.ord - 1).chr}#{current_num.to_i - 1}"
        when "down_right"
          current_square = "#{(current_let.ord + 1).chr}#{current_num.to_i - 1}"
        end
        
        break if return_piece(current_square) == "error"
        (valid_moves << current_square; next) if return_piece(current_square) == "-"
        (valid_moves << current_square; break) if return_piece(current_square).color != player.color &&
                                                  return_piece(current_square).name != "king"
        break if return_piece(current_square).color == player.color
      end
    end    
    valid_moves
  end

  def possible_queen_moves(start, player)
    possible_rook_moves(start, player) + possible_bishop_moves(start, player)
  end

  def possible_king_moves(start, player)
    valid_moves = []

    current_square = start
    current_let, current_num = current_square.scan(/[a-z]|\d+/)

    moves = { 
      up: "#{current_let}#{current_num.to_i + 1}", 
      up_right: "#{(current_let.ord + 1).chr}#{current_num.to_i + 1}",
      right: "#{(current_let.ord + 1).chr}#{current_num}",
      down_right: "#{(current_let.ord + 1).chr}#{current_num.to_i - 1}",
      down: "#{current_let}#{current_num.to_i - 1}",
      down_left: "#{(current_let.ord - 1).chr}#{current_num.to_i - 1}",
      left: "#{(current_let.ord - 1).chr}#{current_num}",
      up_left: "#{(current_let.ord - 1).chr}#{current_num.to_i + 1}"
    }

    moves.each do |_,move|
      piece = return_piece(move)
      if piece == "-" || ( piece.is_a?(ChessPiece) && 
                           piece.color != player.color && piece.name != "king" )
        valid_moves << move
      end
    end    
    valid_moves
  end

  def possible_knight_moves(start, player)
    valid_moves = []

    current_square = start
    current_let, current_num = current_square.scan(/[a-z]|\d+/)

    moves = [[2,1],[1,2],[-1,2],[-2,1],[-2,-1],[-1,-2],[1,-2],[2,-1]]

    moves.each do |move|
      let, num = move
      coord = "#{(current_let.ord + let).chr}#{current_num.to_i + num}"
      piece = return_piece(coord)

      if piece == "-" || ( piece.is_a?(ChessPiece) && 
                           piece.color != player.color && piece.name != "king" )
        valid_moves << coord
      end
    end
    valid_moves
  end
  
end