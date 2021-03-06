# frozen_string_literal: true

# Class to model a Chess piece.
class ChessPiece
  attr_accessor :name, :moves, :color, :default_symbol

  def initialize(name = nil, color = nil, unicode = nil, default_symbol = nil)
    @name = name
    @moves = nil
    @unicode = unicode
    @color = color
    @default_symbol = default_symbol
  end

  def unicode
    color == 'black' ? @unicode_black : @unicode_white
  end
end

# Class to model a Pawn
class Pawn < ChessPiece
  def initialize(color)
    @name = 'pawn'
    @default_symbol = 'P'
    @color = color
    @unicode_black = "\u2659"
    @unicode_white = "\u265F"
  end
end

# Class to model a Rook
class Rook < ChessPiece
  def initialize(color)
    @name = 'rook'
    @default_symbol = 'R'
    @color = color
    @unicode_black = "\u2656"
    @unicode_white = "\u265C"
  end
end

# Class to model a Knight
class Knight < ChessPiece
  def initialize(color)
    @name = 'knight'
    @default_symbol = 'K'
    @color = color
    @unicode_black = "\u2658"
    @unicode_white = "\u265E"
  end
end

# Class to model a Bishop
class Bishop < ChessPiece
  def initialize(color)
    @name = 'bishop'
    @default_symbol = 'B'
    @color = color
    @unicode_black = "\u2657"
    @unicode_white = "\u265D"
  end
end

# Class to model a Queen
class Queen < ChessPiece
  def initialize(color)
    @name = 'queen'
    @default_symbol = 'Q'
    @color = color
    @unicode_black = "\u2655"
    @unicode_white = "\u265B"
  end
end

# Class to model a King
class King < ChessPiece
  def initialize(color)
    @name = 'king'
    @default_symbol = 'K'
    @color = color
    @unicode_black = "\u2654"
    @unicode_white = "\u265A"
  end
end
