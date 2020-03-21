# frozen_string_literal: true

require_relative 'moves'
require_relative 'possible_moves'

class Check
  attr_reader :game

  def initialize(game)
    @game = game
  end

  def check?(player)
    king_coords = return_coords(find_king(player))
    directions = check_directions(player)
    directions.each do |path_key, direction|
      direction.each do |_dir_name, move_nums|
        PossibleMoves.create_moves(king_coords, *move_nums) do |next_move|
          piece = game.return_piece(next_move)
          break if one_move?(piece, path_key)
          next if piece == '-'
          break if piece.color == player.color
          if is_check?(path_key, piece)
            return true
          else
            break
          end
        end
      end
    end
    false
  end

  def check_mate?(player)
    game.board.return_board.each_with_index do |row, ind|
      row.each_with_index do |sq, i|
        next unless sq.is_a?(ChessPiece)
        next unless sq.color == player.color

        piece = sq.name

        case piece
        when 'pawn'
          return false if move_stops_check?([i, ind], piece, player)
        when 'rook'
          return false if move_stops_check?([i, ind], piece, player)
        when 'bishop'
          return false if move_stops_check?([i, ind], piece, player)
        when 'queen'
          return false if move_stops_check?([i, ind], piece, player)
        when 'king'
          return false if move_stops_check?([i, ind], piece, player)
        when 'knight'
          return false if move_stops_check?([i, ind], piece, player)
        end
      end
    end
    true
  end

  def check_directions(player)
    {
      diagonal: Moves.diagonal, horiz_vert: Moves.horizontal_vertical,
      knight: Moves.knight, pawn_attack: Moves.pawn_attack(player),
      king: Moves.king
    }
  end

  def find_king(player)
    game.board.return_board.each_with_index do |row, ind|
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
    num += 1
    "#{let}#{num}"
  end

  def move_stops_check?(indices, piece, player)
    start = return_coords(indices)
    possible_moves = PossibleMoves.send(piece.to_s, start, player, game)
    possible_moves.each do |finish|
      game.move_piece(start, finish)
      unless check?(player)
        game.reverse_move([start, finish])
        return true
      end
      game.reverse_move([start, finish])
    end
    false
  end

  private

  def one_move?(piece, path_key)
    piece == '-' && (path_key == :knight ||
      path_key == :pawn_attack ||
      path_key == :king)
  end

  def is_check?(path_key, piece)
    path_key == :diagonal && %w[bishop queen].include?(piece.name) ||
      path_key == :horiz_vert && %w[rook queen].include?(piece.name) ||
      path_key == :knight && %w[knight].include?(piece.name) ||
      path_key == :pawn_attack && %w[pawn].include?(piece.name) ||
      path_key == :king && %w[king].include?(piece.name)
  end
end
