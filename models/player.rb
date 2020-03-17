# frozen_string_literal: true

class Player
  attr_accessor :name, :color, :number

  def initialize(name, color = nil, number = nil)
    @name = name
    @color = color
    @number = number
  end
end
