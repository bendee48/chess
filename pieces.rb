class ChessPiece

  def initialize(name=nil, color=nil, unicode=nil, default=nil)
    @name = name
    @moves = nil
    @unicode = unicode
    @color = color
    @default = default
  end

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
