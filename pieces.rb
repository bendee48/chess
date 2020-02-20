# frozen_string_literal: true

class ChessPiece
  attr_accessor :name, :moves, :unicode, :color, :default_symbol

  def initialize(name = nil, color = nil, unicode = nil, default_symbol = nil)
    @name = name
    @moves = nil
    @unicode = unicode
    @color = color
    @default_symbol = default_symbol
  end
  # default_symbol inplace of unicode
end

class Pawn < ChessPiece
  def initialize(color)
    @name = 'pawn'
    @default_symbol = 'P'
    @color = color
    set_unicode(color)
  end

  def set_unicode(color)
    case color
    when 'black'
      self.unicode = "\u2659"
    when 'white'
      self.unicode = "\u265F"
    end
  end
end

class Rook < ChessPiece
  def initialize(color)
    @name = 'rook'
    @default_symbol = 'R'
    @color = color
    set_unicode(color)
  end

  def set_unicode(color)
    case color
    when 'black'
      self.unicode = "\u2656"
    when 'white'
      self.unicode = "\u265C"
    end
  end
end

class Knight < ChessPiece
  def initialize(color)
    @name = 'knight'
    @default_symbol = 'K'
    @color = color
    set_unicode(color)
  end

  def set_unicode(color)
    case color
    when 'black'
      self.unicode = "\u2658"
    when 'white'
      self.unicode = "\u265E"
    end
  end
end

class Bishop < ChessPiece
  def initialize(color)
    @name = 'bishop'
    @default_symbol = 'B'
    @color = color
    set_unicode(color)
  end

  def set_unicode(color)
    case color
    when 'black'
      self.unicode = "\u2657"
    when 'white'
      self.unicode = "\u265D"
    end
  end
end

class Queen < ChessPiece
  def initialize(color)
    @name = 'queen'
    @default_symbol = 'Q'
    @color = color
    set_unicode(color)
  end

  def set_unicode(color)
    case color
    when 'black'
      self.unicode = "\u2655"
    when 'white'
      self.unicode = "\u265B"
    end
  end
end

class King < ChessPiece
  def initialize(color)
    @name = 'king'
    @default_symbol = 'K'
    @color = color
    set_unicode(color)
  end

  def set_unicode(color)
    case color
    when 'black'
      self.unicode = "\u2654"
    when 'white'
      self.unicode = "\u265A"
    end
  end
end
