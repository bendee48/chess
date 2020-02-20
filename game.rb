# frozen_string_literal: true

require './board'
require './player'
require './validation'

class Game
  include Validation

  attr_accessor :board, :player1, :player2

  def initialize
    @board = Board.new
    @player1 = nil
    @player2 = nil
  end

  def play
    puts 'Chess.'
    player_setup
    # testing
    players = [player1, player2].cycle
    loop do
      player = players.next
      board.display_board
      make_move(player)
    end
  end

  def player_move(start, finish, player)
    start_piece = return_piece(start)
    if ChessPiece === start_piece
      start_piece = start_piece.name
    else
      puts 'No piece there.'
    end

    case start_piece
    when 'pawn'
      possible_moves = possible_pawn_moves(start, player)
      move_validated_piece(start, finish, possible_moves)
    when 'rook'
      possible_moves = possible_rook_moves(start, player)
      move_validated_piece(start, finish, possible_moves)
    when 'bishop'
      possible_moves = possible_bishop_moves(start, player)
      move_validated_piece(start, finish, possible_moves)
    when 'queen'
      possible_moves = possible_queen_moves(start, player)
      move_validated_piece(start, finish, possible_moves)
    when 'king'
      possible_moves = possible_king_moves(start, player)
      move_validated_piece(start, finish, possible_moves)
    when 'knight'
      possible_moves = possible_knight_moves(start, player)
      move_validated_piece(start, finish, possible_moves)
    end
  end

  private

  def player_setup
    [1, 2].each do |num|
      validate_name(num)
      if player1.color
        player_color = player1.color == 'black' ? 'white' : 'black'
        player2.color = player_color
        puts "Thanks #{player2.name} you're #{player_color}."
      else
        validate_color(num)
      end
    end
  end

  def make_move(player)
    loop do
      puts "Make your move #{player.name}."
      ans = gets.chomp
      ans = ans.split
      start, finish = ans
      result = player_move(start, finish, player)
      if result.nil?
        redo
      else
        break
      end
    end
  end

  def return_piece(coordinates)
    let, num = coordinates.scan(/[a-z]|\d+/)
    return 'error' unless ('a'..'h') === let && ('1'..'8') === num

    board.return_board[num.to_i - 1][let.ord - 97]
  end

  def move_piece(start, finish)
    start_let, start_num = start.scan(/[a-z]|\d+/)
    finish_let, finish_num = finish.scan(/[a-z]|\d+/)
    board.return_board[finish_num.to_i - 1][finish_let.ord - 97] = return_piece(start)
    board.return_board[start_num.to_i - 1][start_let.ord - 97] = '-'
  end

  def move_validated_piece(start, finish, possible_moves)
    if valid_move?(possible_moves, finish)
      move_piece(start, finish)
    else
      puts 'Sorry, invalid move.'
    end
  end

  def valid_move?(moves, finish)
    moves.include?(finish)
  end

  def possible_pawn_moves(start, player)
    current_let, current_num = start.scan(/[a-z]|\d+/)
    valid_moves = []

    if player.color == 'black'
      one_up = "#{current_let}#{current_num.to_i + 1}"
      two_up = "#{current_let}#{current_num.to_i + 2}"
    else
      one_up = "#{current_let}#{current_num.to_i - 1}"
      two_up = "#{current_let}#{current_num.to_i - 2}"
    end

    valid_moves << one_up if return_piece(one_up) == '-'
    valid_moves << two_up if return_piece(two_up) == '-' && current_num == '2' && player.color == 'black' ||
                             return_piece(two_up) == '-' && current_num == '7' && player.color == 'white'
    valid_moves += pawn_attack_moves(player, current_let, current_num)
  end

  def pawn_attack_moves(player, current_let, current_num)
    attacks = { right: [1, 1], left: [-1, 1] }
    valid_moves = []

    attacks.each do |_, nums|
      let, num = nums
      coord = if player.color == 'black'
                "#{(current_let.ord + let).chr}#{current_num.to_i + num}"
              else
                "#{(current_let.ord - let).chr}#{current_num.to_i - num}"
              end
      piece = return_piece(coord)
      if piece.is_a?(ChessPiece) && piece.color != player.color &&
         piece.name != 'king'
         valid_moves << coord
      end
    end
    valid_moves
  end

  def possible_rook_moves(start, player)
    valid_moves = []

    %w[up down left right].each do |dir|
      current_square = start
      loop do
        current_let, current_num = current_square.scan(/[a-z]|\d+/)
        case dir
        when 'up'
          current_square = "#{current_let}#{current_num.to_i + 1}"
        when 'down'
          current_square = "#{current_let}#{current_num.to_i - 1}"
        when 'left'
          current_square = "#{(current_let.ord - 1).chr}#{current_num}"
        when 'right'
          current_square = "#{(current_let.ord + 1).chr}#{current_num}"
        end

        break if return_piece(current_square) == 'error'

        if return_piece(current_square) == '-'
          (valid_moves << current_square; next)
        end
        (valid_moves << current_square; break) if return_piece(current_square).color != player.color &&
                                                  return_piece(current_square).name != 'king'
        break if return_piece(current_square).color == player.color
      end
    end
    valid_moves
  end

  def possible_bishop_moves(start, player)
    valid_moves = []

    %w[up_right up_left down_left down_right].each do |dir|
      current_square = start
      loop do
        current_let, current_num = current_square.scan(/[a-z]|\d+/)
        case dir
        when 'up_right'
          current_square = "#{(current_let.ord + 1).chr}#{current_num.to_i + 1}"
        when 'up_left'
          current_square = "#{(current_let.ord - 1).chr}#{current_num.to_i + 1}"
        when 'down_left'
          current_square = "#{(current_let.ord - 1).chr}#{current_num.to_i - 1}"
        when 'down_right'
          current_square = "#{(current_let.ord + 1).chr}#{current_num.to_i - 1}"
        end

        break if return_piece(current_square) == 'error'

        if return_piece(current_square) == '-'
          (valid_moves << current_square; next)
        end
        (valid_moves << current_square; break) if return_piece(current_square).color != player.color &&
                                                  return_piece(current_square).name != 'king'
        break if return_piece(current_square).color == player.color
      end
    end
    valid_moves
  end

  def possible_queen_moves(start, player)
    possible_rook_moves(start, player) + possible_bishop_moves(start, player)
  end

  def possible_king_moves(start, player)
    king_moves = {
      up: [0, 1], up_right: [1, 1], right: [1, 0], down_right: [1, -1],
      down: [0, -1], down_left: [-1, -1], left: [-1, 0], up_left: [-1, 1]
    }
    generate_setmoves(start, player, king_moves)
  end

  def possible_knight_moves(start, player)
    knight_moves = {
      up_right1: [2, 1], up_right2: [1, 2], down_right1: [-1, 2], down_right2: [-2, 1],
      left_down1: [-2, -1], left_down2: [-1, -2], up_left1: [1, -2], up_left2: [2, -1]
    }
    generate_setmoves(start, player, knight_moves)
  end

  def generate_setmoves(start, player, moves)
    valid_moves = []

    current_square = start
    current_let, current_num = current_square.scan(/[a-z]|\d+/)

    moves.each do |_, move|
      let, num = move
      coord = "#{(current_let.ord + let).chr}#{current_num.to_i + num}"
      piece = return_piece(coord)
      if piece == '-' || (piece.is_a?(ChessPiece) &&
                           piece.color != player.color && piece.name != 'king')
        valid_moves << coord
      end
    end
    valid_moves
  end
end
