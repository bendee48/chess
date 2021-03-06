# frozen_string_literal: true

require_relative 'moves'

# Class to generate valid moves for a Chess piece from their current position.
class PossibleMoves
  # yields next possble move to block.
  # use block to set break conditions
  def self.create_moves(start, add_to_let, add_to_num)
    letter, number = start.scan(/[a-z]|\d+/)
    loop do
      letter = (letter.ord + add_to_let).chr
      number = number.to_i + add_to_num
      break unless ('a'..'h').include?(letter) && (1..8).include?(number)

      yield("#{letter}#{number}")
    end
  end

  def self.rook(start, player, game)
    valid_moves = []
    movements = Moves.horizontal_vertical

    movements.each do |_, move|
      add_to_let, add_to_num = move
      create_moves(start, add_to_let, add_to_num) do |next_move|
        piece = game.return_piece(next_move)
        (valid_moves << next_move; next) if piece == '-'
        break if break_conditions(player, piece)

        if piece.is_a?(ChessPiece) &&
           piece.color != player.color
          valid_moves << next_move
          break
        end
      end
    end
    valid_moves
  end

  def self.bishop(start, player, game)
    valid_moves = []
    movements = Moves.diagonal

    movements.each do |_, move|
      add_to_let, add_to_num = move
      create_moves(start, add_to_let, add_to_num) do |next_move|
        piece = game.return_piece(next_move)
        (valid_moves << next_move; next) if piece == '-'
        break if break_conditions(player, piece)

        if piece.is_a?(ChessPiece) &&
           piece.color != player.color
          valid_moves << next_move
          break
        end
      end
    end
    valid_moves
  end

  def self.queen(start, player, game)
    rook(start, player, game) + bishop(start, player, game)
  end

  def self.king(start, player, game)
    valid_moves = []
    movements = Moves.diagonal.merge(Moves.horizontal_vertical)

    movements.each do |_, move|
      add_to_let, add_to_num = move
      create_moves(start, add_to_let, add_to_num) do |next_move|
        piece = game.return_piece(next_move)
        # break instead of next for 1 move pieces
        (valid_moves << next_move; break) if piece == '-'
        break if break_conditions(player, piece)

        if piece.is_a?(ChessPiece) &&
           piece.color != player.color
          valid_moves << next_move
          break
        end
      end
    end
    valid_moves
  end

  def self.knight(start, player, game)
    valid_moves = []
    movements = Moves.knight

    movements.each do |_, move|
      add_to_let, add_to_num = move
      create_moves(start, add_to_let, add_to_num) do |next_move|
        piece = game.return_piece(next_move)
        # break instead of next for 1 move pieces
        (valid_moves << next_move; break) if piece == '-'
        break if break_conditions(player, piece)

        if piece.is_a?(ChessPiece) &&
           piece.color != player.color
          valid_moves << next_move
          break
        end
      end
    end
    valid_moves
  end

  def self.pawn(start, player, game)
    valid_moves = []
    movements = Moves.pawn(player)

    movements.each do |_, move|
      add_to_let, add_to_num = move
      current_num = start[1].to_i
      create_moves(start, add_to_let, add_to_num) do |next_move|
        piece = game.return_piece(next_move)
        break if piece != '-'

        if move_two?(piece, current_num, player)
          valid_moves << next_move
          current_num += 1
          next
        end
        valid_moves << next_move
        break
      end
    end
    valid_moves += pawn_attack(start, player, game)
  end

  def self.move_two?(piece, current_num, player)
    piece == '-' && current_num == 2 && player.color == 'black' ||
      piece == '-' && current_num == 7 && player.color == 'white'
  end

  def self.pawn_attack(start, player, game)
    valid_moves = []
    movements = Moves.pawn_attack(player)

    movements.each do |_, move|
      add_to_let, add_to_num = move
      create_moves(start, add_to_let, add_to_num) do |next_move|
        piece = game.return_piece(next_move)
        if piece.is_a?(ChessPiece) && piece.color != player.color &&
           piece.name != 'king'
          valid_moves << next_move
        end
        break
      end
    end
    valid_moves
  end

  def self.break_conditions(player, piece)
    piece.color == player.color ||
      (piece.is_a?(King) && piece.color != player.color)
  end
end
