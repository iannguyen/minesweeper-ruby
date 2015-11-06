require 'colorize'

class Tile
  attr_accessor :value, :bomb, :flagged, :value, :revealed

  def initialize(value)
    @revealed = false
    @bomb = false
    @flagged = false
    @value = value
  end

  def inspect
    if flagged
      'f'
    elsif revealed
      if bomb
        'KABOOM!!!'.colorize(:red)
      elsif value == 0
        '_'
      elsif value != 0
        "#{value}".colorize(:green)
      end
    else
      '*'.colorize(:blue)
    end
  end

  def flag
    value = 'f'
  end
end
