# frozen_string_literal: true

require_relative 'models/board'
require_relative 'models/player'
require_relative 'validation'
require_relative 'moves'
require_relative 'save'
require_relative 'textable'
require_relative 'check'
require_relative 'possible_moves'

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
    answer == 'load' ? load_game : new_game
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
    @check_if = Check.new(self)
    loop do
      player = players.next
      self.current_player = player
      board.display_board
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
    exit(0)
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
end
