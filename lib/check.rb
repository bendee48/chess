require_relative 'moves'
require_relative 'possible_moves'

class Check
  attr_reader :game

  def initialize(game)
    @game = game
  end

  def check?(player)
    king_coords = return_coords(find_king(player))
    checks = check_directions(player)
    checks.each do |key, check|
      check.each do |_, move|
        PossibleMoves.create_moves(king_coords, *move) do |next_move|
          piece = game.return_piece(next_move)
          if [:knight, :pawn_attack].include?(key)
            break if piece == '-'
          else
            next if piece == '-'
          end
          break if piece.is_a?(ChessPiece) && piece.color == player.color
          return true if check_booleans(piece, key, player)
        end
      end
    end
    return false
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

  def check_booleans(piece, key, player)
    (%w(bishop queen).include?(piece.name) && 
      piece.color != player.color && key == :diagonal) ||
      (%w(rook queen).include?(piece.name) && 
      piece.color != player.color && key == :horiz_vert) ||
      (%w(knight).include?(piece.name) && 
      piece.color != player.color && key == :knight) ||
      (%w(pawn).include?(piece.name) && 
      piece.color != player.color && key == :pawn_attack)
  end

  def check_directions(player)
    {
      diagonal: Moves.diagonal, horiz_vert: Moves.horizontal_vertical, 
      knight: Moves.knight, pawn_attack: Moves.pawn_attack(player)              
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
    num = num + 1
    "#{let}#{num}"
  end

  def move_stops_check?(indices, piece, player)
    start = return_coords(indices)
    possible_moves = PossibleMoves.send("#{piece}", start, player, game)
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
end