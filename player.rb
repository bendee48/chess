# frozen_string_literal: true

class Player
  attr_accessor :name, :color

  def initialize(name, color = nil)
    @name = name
    @color = color
  end
end
