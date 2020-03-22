# frozen_string_literal: true

# Class that models piece movement
class Moves
  def self.pawn(player)
    if player.color == 'black'
      { up: [0, 1] }
    else
      { down: [0, -1] }
    end
  end

  def self.pawn_attack(player)
    if player.color == 'black'
      { right: [1, 1], left: [-1, 1] }
    else
      { right: [-1, -1], left: [1, -1] }
    end
  end

  def self.diagonal
    @diagonal ||= {
      up_right: [1, 1], up_left: [-1, 1],
      down_left: [-1, -1], down_right: [1, -1]
    }
  end

  def self.horizontal_vertical
    @horizontal_vertical ||= {
      up: [0, 1], down: [0, -1], left: [-1, 0], right: [1, 0]
    }
  end

  def self.knight
    @knight ||= {
      up_right1: [2, 1], up_right2: [1, 2],
      down_right1: [-1, 2], down_right2: [-2, 1],
      left_down1: [-2, -1], left_down2: [-1, -2],
      up_left1: [1, -2], up_left2: [2, -1]
    }
  end

  def self.king
    @king ||= diagonal.merge(horizontal_vertical)
  end
end
