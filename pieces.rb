class ChessPiece
  attr_accessor :name, :moves, :unicode, :color, :default_symbol

  def initialize(name=nil, color=nil, unicode=nil, default_symbol=nil)
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
    @default_symbol = 'p'
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
end

class Knight < ChessPiece
end

class Bishop < ChessPiece
end

class Queen < ChessPiece
end

class King < ChessPiece
end
