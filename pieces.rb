class ChessPiece

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
