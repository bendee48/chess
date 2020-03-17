# frozen_string_literal: true

require './board'
require './player'
require './validation'
require './moves'
require './save'
require './textable'
require './check'
require './possible_moves'

class Game
  include Validation

  attr_accessor :player1, :player2,
                :last_move, :last_piece_taken,
                :current_player, :loaded_game
  attr_reader   :board

  def initialize
    @board = Board.new
    @player1 = nil
    @player2 = nil
    @current_player = nil
    @last_move = nil
    @last_piece_taken = nil
    @loaded_game = nil
  end

  def start
    Textable::introduction
    answer = gets.chomp.strip.downcase
    Textable::instructions if answer == 'i'
    Textable::load
    answer = gets.chomp.strip.downcase
    if answer == 'load'
      load_game
    else
      new_game
    end
  end

  def load_game
    game = SaveGame::load
    game.loaded_game = true
    game.play
  end

  def new_game
    player_setup
    play
  end

  def play    
    players = load_saved_player
    loop do
      player = players.next
      self.current_player = player
      board.display_board
      @check_if = Check.new(self)
      game_over if @check_if.check_mate?(player)
      puts "You're in check" if @check_if.check?(player)
      make_move(player)
      game_over if @check_if.check_mate?(player)
    end
  end

  def load_saved_player
    if loaded_game && current_player.number == 2
      [player2, player1].cycle
    else
      [player1, player2].cycle
    end
  end

  def game_over
    puts "That's checkmate. Game Over"
    exit(0)
  end

  def player_move(start, finish, player)
    start_piece = validate_player_move(start, player)
   
    case start_piece
    when 'pawn'
      possible_moves = PossibleMoves.pawn(start, player, self)
      move_validated_piece(start, finish, possible_moves)
    when 'rook'
      possible_moves = PossibleMoves.rook(start, player, self)
      move_validated_piece(start, finish, possible_moves)
    when 'bishop'
      possible_moves = PossibleMoves.bishop(start, player, self)
      move_validated_piece(start, finish, possible_moves)
    when 'queen'
      possible_moves = PossibleMoves.queen(start, player, self)
      move_validated_piece(start, finish, possible_moves)
    when 'king'
      possible_moves = PossibleMoves.king(start, player, self)
      move_validated_piece(start, finish, possible_moves)
    when 'knight'
      possible_moves = PossibleMoves.knight(start, player, self)
      move_validated_piece(start, finish, possible_moves)
    end
  end

  # # yields next possble move to block.
  # # use block to set break conditions
  # def create_moves(start, add_to_let, add_to_num)
  #   letter, number = start.scan(/[a-z]|\d+/)
  #   loop do
  #     letter = (letter.ord + add_to_let).chr
  #     number = number.to_i + add_to_num
  #     break unless ('a'..'h').include?(letter) && (1..8).include?(number)
  #     yield("#{letter}#{number}")   
  #   end
  # end

  def move_piece(start, finish)
    start_piece = return_piece(start)
    finish_piece = return_piece(finish)
    self.last_piece_taken = finish_piece
    set_piece(finish, start_piece)
    set_piece(start, '-') 
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
    board.return_board[num.to_i - 1][let.ord - 97]
  end

  def set_piece(coordinates, piece)
    let, num = coordinates.scan(/[a-z]|\d+/)
    board.return_board[num.to_i - 1][let.ord - 97] = piece
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
      answer = gets.chomp
      (save_game; break) if answer == 'save'
      unless valid_format?(answer)
        puts "Invalid format."
        redo
      end
      answer = answer.split
      start, finish = answer
      result = player_move(start, finish, player)
      if result.nil?
        redo
      elsif @check_if.check?(player)
        puts "Can't move there. You're in check."
        reverse_move(last_move)
        redo
      else
        break
      end
    end
  end

  def save_game
    SaveGame::save(self)
    puts "Game saved successfully."
    exit
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

  # def break_conditions(move, player, piece)
  #   piece.color == player.color ||
  #   (piece.is_a?(King) && piece.color != player.color)
  # end

  # def possible_pawn_moves(start, player)
  #   valid_moves = []
  #   movements = Moves.pawn(player)

  #   movements.each do |__, move|
  #     add_to_let, add_to_num = move
  #     current_num = start[1].to_i
  #     create_moves(start, add_to_let, add_to_num ) do |next_move|
  #       piece = return_piece(next_move)
  #       break if piece != '-'
  #       if piece == '-' && current_num == 2 && player.color == 'black' ||
  #          piece = '-' && current_num == 7 && player.color == 'white'
  #          valid_moves << next_move
  #          current_num += 1
  #          next
  #       else
  #         valid_moves << next_move
  #         break
  #       end
  #     end
  #   end
  #   valid_moves += pawn_attack_moves(start, player)
  # end

  # def pawn_attack_moves(start, player)
  #   valid_moves = []
  #   movements = Moves.pawn_attack(player)

  #   movements.each do |__, move|
  #     add_to_let, add_to_num = move
  #     create_moves(start, add_to_let, add_to_num ) do |next_move|
  #       piece = return_piece(next_move)
  #       if piece.is_a?(ChessPiece) && piece.color != player.color &&
  #         piece.name != 'king'
  #         valid_moves << next_move
  #         break
  #       else
  #         break
  #       end
  #     end
  #   end
  #   valid_moves
  # end

  # def possible_rook_moves(start, player)
  #   valid_moves = []
  #   movements = Moves.horizontal_vertical

  #   movements.each do |__, move|
  #     add_to_let, add_to_num = move
  #     create_moves(start, add_to_let, add_to_num ) do |next_move|
  #       piece = return_piece(next_move)
  #       (valid_moves << next_move; next) if piece == '-'
  #       break if break_conditions(next_move, player, piece)
  #       if piece.is_a?(ChessPiece) && 
  #          piece.color != player.color
  #          valid_moves << next_move
  #          break
  #       end
  #     end
  #   end
  #   valid_moves
  # end

  # def possible_bishop_moves(start, player)
  #   valid_moves = []
  #   movements = Moves.diagonal

  #   movements.each do |__, move|
  #     add_to_let, add_to_num = move
  #     create_moves(start, add_to_let, add_to_num ) do |next_move|
  #       piece = return_piece(next_move)
  #       (valid_moves << next_move; next) if piece == '-'
  #       break if break_conditions(next_move, player, piece)
  #       if piece.is_a?(ChessPiece) && 
  #          piece.color != player.color
  #          valid_moves << next_move
  #          break
  #       end
  #     end
  #   end
  #   valid_moves
  # end

  # def possible_queen_moves(start, player)
  #   possible_rook_moves(start, player) + possible_bishop_moves(start, player)
  # end

  # def possible_king_moves(start, player)
  #   valid_moves = []
  #   movements = Moves.diagonal.merge(Moves.horizontal_vertical)

  #   movements.each do |__, move|
  #     add_to_let, add_to_num = move
  #     create_moves(start, add_to_let, add_to_num ) do |next_move|
  #       piece = return_piece(next_move)
  #       #break instead of next for 1 move pieces
  #       (valid_moves << next_move; break) if piece == '-'
  #       break if break_conditions(next_move, player, piece)
  #       if piece.is_a?(ChessPiece) && 
  #          piece.color != player.color
  #          valid_moves << next_move
  #          break
  #       end
  #     end
  #   end
  #   valid_moves
  # end

  # def possible_knight_moves(start, player)
  #   valid_moves = []
  #   movements = Moves.knight

  #   movements.each do |__, move|
  #     add_to_let, add_to_num = move
  #     create_moves(start, add_to_let, add_to_num ) do |next_move|
  #       piece = return_piece(next_move)
  #       #break instead of next for 1 move pieces
  #       (valid_moves << next_move; break) if piece == '-'
  #       break if break_conditions(next_move, player, piece)
  #       if piece.is_a?(ChessPiece) && 
  #          piece.color != player.color
  #          valid_moves << next_move
  #          break
  #       end
  #     end
  #   end
  #   valid_moves
  # end
end
