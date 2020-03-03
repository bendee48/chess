# frozen_string_literal: true

require './board'
require './player'
require './validation'

class Game
  include Validation

  attr_accessor :board, :player1, :player2,
                :check, :check_mate, :check_moves

  def initialize
    @board = Board.new
    @player1 = nil
    @player2 = nil
    # @check = nil
    # @checkmate = nil
    # @check_moves = []
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

  def check?(player)
    king_coords = return_coords(find_king(player))
    # diagonal check
    diagonal_check = { up_right: [1, 1], up_left: [-1, 1], down_left: [-1, -1], down_right: [1, -1] }
    diagonal_check.each do |__, move|
      create_moves(king_coords, *move) do |next_move|
        piece = return_piece(next_move)
        next if piece == '-'
        break if piece.is_a?(ChessPiece) && piece.color == player.color
        return true if %w(bishop queen).include?(piece.name) && piece.color != player.color
      end
    end
    # horizontal and vertical check
    horiz_vert_check = { up: [0, 1], down: [0, -1], left: [-1, 0], right: [1, 0] }
    horiz_vert_check.each do |__, move|
      create_moves(king_coords, *move) do |next_move|
        piece = return_piece(next_move)
        next if piece == '-'
        break if piece.is_a?(ChessPiece) && piece.color == player.color
        return true if %w(rook queen).include?(piece.name) && piece.color != player.color
      end
    end
    false
  end

  def find_king(player)
    board.return_board.each_with_index do |row, ind|
      let = row.find_index do |piece| 
              next unless piece.is_a?(ChessPiece)
              piece.is_a?(King) && piece.color == player.color
            end
      return [let, ind] if let
    end
  end

  def return_coords(indices)
    let, num = indices
    let = (let + 97).chr
    num = num + 1
    "#{let}#{num}"
  end

  def check_mate?
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

  #yields next possble move to block
  def create_moves(start, add_to_let, add_to_num)
    letter, number = start.scan(/[a-z]|\d+/)
    loop do
      letter = (letter.ord + add_to_let).chr
      number = number.to_i + add_to_num
      break if !('a'..'h').include?(letter) || !(1..8).include?(number)
      yield("#{letter}#{number}")   
    end
  end

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

  def break_conditions(move, player, piece)
    piece.color == player.color ||
    (piece.is_a?(King) && piece.color != player.color)
  end

  def possible_pawn_moves(start, player)
    valid_moves = []
    if player.color == 'black'
      moves = { up: [0, 1] }
    else
      moves = { down: [0, -1] }
    end

    moves.each do |__, move|
      add_to_let, add_to_num = move
      create_moves(start, add_to_let, add_to_num ) do |next_move|
        piece = return_piece(next_move)
        break if piece != '-'
        if piece == '-'
          valid_moves << next_move
          next
        elsif piece == '-' && current_num == '2' && player.color == 'black' ||
              piece == '-' && current_num == '7' && player.color == 'white'
          valid_moves << next_move
          break
        end
      end
    end
    valid_moves += pawn_attack_moves(start, player)
  end

  def pawn_attack_moves(start, player)
    valid_moves = []
    if player.color == 'black'
      moves = { right: [1, 1], left: [-1, 1] }
    else
      moves = { right: [-1, -1], left: [1, -1] }
    end

    moves.each do |__, move|
      add_to_let, add_to_num = move
      create_moves(start, add_to_let, add_to_num ) do |next_move|
        piece = return_piece(next_move)
        if piece.is_a?(ChessPiece) && piece.color != player.color &&
          piece.name != 'king'
          valid_moves << next_move
          break
        else
          break
        end
      end
    end
    valid_moves
  end

  def possible_rook_moves(start, player)
    valid_moves = []
    moves = { up: [0, 1], down: [0, -1], left: [-1, 0], right: [1, 0] }

    moves.each do |__, move|
      add_to_let, add_to_num = move
      create_moves(start, add_to_let, add_to_num ) do |next_move|
        piece = return_piece(next_move)
        (valid_moves << next_move; next) if piece == '-'
        break if break_conditions(next_move, player, piece)
        if piece.is_a?(ChessPiece) && 
           piece.color != player.color
           valid_moves << next_move
           break
        end
      end
    end
    valid_moves
  end

  def possible_bishop_moves(start, player)
    valid_moves = []
    moves = { up_right: [1, 1], up_left: [-1, 1], down_left: [-1, -1], down_right: [1, -1] }

    moves.each do |__, move|
      add_to_let, add_to_num = move
      create_moves(start, add_to_let, add_to_num ) do |next_move|
        piece = return_piece(next_move)
        (valid_moves << next_move; next) if piece == '-'
        break if break_conditions(next_move, player, piece)
        if piece.is_a?(ChessPiece) && 
           piece.color != player.color
           valid_moves << next_move
           break
        end
      end
    end
    valid_moves
  end

  def possible_queen_moves(start, player)
    possible_rook_moves(start, player) + possible_bishop_moves(start, player)
  end

  def possible_king_moves(start, player)
    valid_moves = []
    moves = {
      up: [0, 1], up_right: [1, 1], right: [1, 0], down_right: [1, -1],
      down: [0, -1], down_left: [-1, -1], left: [-1, 0], up_left: [-1, 1]
    }

    moves.each do |__, move|
      add_to_let, add_to_num = move
      create_moves(start, add_to_let, add_to_num ) do |next_move|
        piece = return_piece(next_move)
        #break instead of next for 1 move pieces
        (valid_moves << next_move; break) if piece == '-'
        break if break_conditions(next_move, player, piece)
        if piece.is_a?(ChessPiece) && 
           piece.color != player.color
           valid_moves << next_move
           break
        end
      end
    end
    valid_moves
  end

  def possible_knight_moves(start, player)
    valid_moves = []
    moves = {
      up_right1: [2, 1], up_right2: [1, 2], down_right1: [-1, 2], down_right2: [-2, 1],
      left_down1: [-2, -1], left_down2: [-1, -2], up_left1: [1, -2], up_left2: [2, -1]
    }

    moves.each do |__, move|
      add_to_let, add_to_num = move
      create_moves(start, add_to_let, add_to_num ) do |next_move|
        piece = return_piece(next_move)
        #break instead of next for 1 move pieces
        (valid_moves << next_move; break) if piece == '-'
        break if break_conditions(next_move, player, piece)
        if piece.is_a?(ChessPiece) && 
           piece.color != player.color
           valid_moves << next_move
           break
        end
      end
    end
    valid_moves
  end
end
