# frozen_string_literal: true

require './board'
require './player'
require './validation'

class Game
  include Validation

  attr_accessor :board, :player1, :player2,
                :check, :checkmate, :check_moves,
                :last_move, :last_piece_taken

  def initialize
    @board = Board.new
    @player1 = nil
    @player2 = nil
    @last_move = nil
    @last_piece_taken = nil
    # @check = nil
    @checkmate = nil
    # @check_moves = []
  end

  def play
    puts 'Chess.'
    player_setup
    players = [player1, player2].cycle
    loop do
      player = players.next
      board.display_board
      game_over if check_mate?(player)
      puts "You're in check" if check?(player)
      make_move(player)
      game_over if check_mate?(player)
    end
  end

  def game_over
    puts "Game Over"
    "game over"
  end

  def check?(player)
    #refactor with blocks
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
    # knight check
    knight_check = {
      up_right1: [2, 1], up_right2: [1, 2], down_right1: [-1, 2], down_right2: [-2, 1],
      left_down1: [-2, -1], left_down2: [-1, -2], up_left1: [1, -2], up_left2: [2, -1]
    }
    knight_check.each do |_, move|
      create_moves(king_coords, *move) do |next_move|
        piece = return_piece(next_move)
        break if piece == '-'
        break if piece.is_a?(ChessPiece) && piece.color == player.color
        return true if %w(knight).include?(piece.name) && piece.color != player.color
      end
    end
    # pawn attack check
    if player.color == 'black'
      pawn_check = { right: [1, 1], left: [-1, 1] }
    else
      pawn_check = { right: [-1, -1], left: [1, -1] }
    end
    pawn_check.each do |_, move|
      create_moves(king_coords, *move) do |next_move|
        piece = return_piece(next_move)
        break if piece == '-'
        break if piece.is_a?(ChessPiece) && piece.color == player.color
        return true if %w(pawn).include?(piece.name) && piece.color != player.color
      end
    end
    return false
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

  def check_mate?(player)
    board.return_board.each_with_index do |row, ind|
      row.each_with_index do |sq, i|
        next if !sq.is_a?(ChessPiece)
        next if sq.color != player.color
        case sq.name
        when 'pawn'
          start = return_coords([i, ind])
          possible_moves = possible_pawn_moves(start, player)
          possible_moves.each do |finish|
            move_piece(start, finish)
            if !check?(player)
              reverse_move([start, finish])
              return false
            end
            reverse_move([start, finish])
          end
        when 'rook'
          start = return_coords([i, ind])
          possible_moves = possible_rook_moves(start, player) 
          possible_moves.each do |finish|
            move_piece(start, finish)
            if !check?(player)
              reverse_move([start, finish])
              return false
            end
            reverse_move([start, finish])
          end
        when 'bishop'
          start = return_coords([i, ind])
          possible_moves = possible_bishop_moves(start, player)
          possible_moves.each do |finish|
            move_piece(start, finish)
            if !check?(player)
              reverse_move([start, finish])
              return false
            end
            reverse_move([start, finish])
          end
        when 'queen'
          start = return_coords([i, ind])
          possible_moves = possible_queen_moves(start, player)
          possible_moves.each do |finish|
            move_piece(start, finish)
            if !check?(player)
              reverse_move([start, finish])
              return false
            end
            reverse_move([start, finish])
          end
        when 'king'
          start = return_coords([i, ind])
          possible_moves = possible_king_moves(start, player)
          possible_moves.each do |finish|
            move_piece(start, finish)
            if !check?(player)
              reverse_move([start, finish])
              return false
            end
            reverse_move([start, finish])
          end
        when 'knight'
          start = return_coords([i, ind])
          possible_moves = possible_knight_moves(start, player)
          possible_moves.each do |finish|
            move_piece(start, finish)
            if !check?(player)
              reverse_move([start, finish])
              return false
            end
            reverse_move([start, finish])
          end
        end
      end
    end
    return true
  end

  def player_move(start, finish, player)
    start_piece = validate_player_move(start, player)
   
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
      elsif check?(player)
        puts "Can't move there. You're in check."
        reverse_move(last_move)
        redo
      else
        break
      end
    end
  end
  
  def reverse_move(move)
    finish, start = move
    start_piece = return_piece(start)
    finish_piece = return_piece(finish)
    set_piece(finish, start_piece)
    set_piece(start, last_piece_taken)
  end

  def return_piece(coordinates)
    let, num = coordinates.scan(/[a-z]|\d+/)
    # return 'error' unless ('a'..'h') === let && ('1'..'8') === num
    board.return_board[num.to_i - 1][let.ord - 97]
  end

  def move_piece(start, finish)
    start_piece = return_piece(start)
    finish_piece = return_piece(finish)
    self.last_piece_taken = finish_piece
    set_piece(finish, start_piece)
    set_piece(start, '-') 
  end

  def set_piece(coordinates, piece)
    let, num = coordinates.scan(/[a-z]|\d+/)
    board.return_board[num.to_i - 1][let.ord - 97] = piece
  end

  def move_validated_piece(start, finish, possible_moves)
    if valid_move?(possible_moves, finish)
      move_piece(start, finish)
      self.last_move = [start, finish]
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
      current_num = start[1].to_i
      create_moves(start, add_to_let, add_to_num ) do |next_move|
        piece = return_piece(next_move)
        break if piece != '-'
        if piece == '-' && current_num == 2 && player.color == 'black' ||
           piece = '-' && current_num == 7 && player.color == 'white'
           valid_moves << next_move
           current_num += 1
           next
        else
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
