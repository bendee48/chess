class Board
  attr_accessor :board, :col_a, :col_b, :col_c, :col_d,
                :col_e, :col_f, :col_g, :col_h

  def initialize
    create_board
  end

  def create_board
    ("a".."h").each { |let| instance_variable_set("@col_#{let}", Array.new(8)) }
  end

  def return_board
    [col_a, col_b, col_c, col_d, col_e, col_f, col_g, col_h]
  end
  
end