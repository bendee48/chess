# frozen_string_literal: true

# Class to model a player.
class Player
  attr_accessor :name, :color, :number

  def initialize(name, color = nil, number = nil)
    @name = name
    @color = color
    @number = number
  end
end
