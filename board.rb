require_relative 'tile'

class Board
  attr_reader :grid, :bomb_count

  def initialize(bomb_count, grid = Board.default_grid)
    @bomb_count = bomb_count
    @grid = Array.new(grid) { Array.new(grid) }
    populate_board
  end

  def self.default_grid
    @grid = Array.new(9) { Array.new(9) }
  end

  def render
    print '    '
    (0..grid.length - 1).each do |num|
      print "#{num.to_s.colorize(:yellow)}  "
    end
    puts
    grid.each_with_index do |row, idx|
      print "#{idx.to_s.colorize(:yellow)}  "
      p row
    end
  end

  def [](row, col)
    grid[row][col]
  end

  def []=(row, col, val)
    grid[row][col] = val
  end

  def populate_board
    grid.each do |row|
      row.map! do |_square|
        square = Tile.new(0)
      end
    end
    drop_bombs
    grid.each_with_index do |row, row_idx|
      row.each_with_index do |_square, col_idx|
        assign_num([row_idx, col_idx])
      end
    end
  end

  def drop_bombs
    placed_bombs = []
    until placed_bombs.length == bomb_count
      coordinate = [rand(0..grid.length - 1), rand(0..grid.length - 1)]
      unless placed_bombs.include?(coordinate)
        self[*coordinate].bomb = true
        self[*coordinate].value = nil
        placed_bombs << coordinate
      end
    end
  end

  def adjacent_additions
    additions = []
    (-1..1).each do |num1|
      (-1..1).each do |num2|
        additions << [num1, num2] unless [num1, num2] == [0, 0]
      end
    end
    additions
  end

  def adjacent_squares(pos)
    x = pos[0]
    y = pos[1]
    adjacent_squares = []
    adjacent_additions.each do |arr|
      adjacent_squares << [x + arr[0], y + arr[1]]
    end
    adjacent_squares.reject do |squares|
      squares.any? { |pos| pos < 0 || pos > grid.length - 1 }
    end
  end

  def assign_num(pos)
    adjacent_squares(pos).each do |square|
      if self[*square].bomb
        next if self[*pos].bomb
        self[*pos].value += 1
      end
    end
  end

  def reveal(pos)
    tile = self[*pos]
    return if tile.revealed
    tile.revealed = true

    if tile.value == 0
      adjacent_squares(pos).each do |square|
        # neighbor_tile = self[*square]
        # don't need this line anymore
        reveal(square)
      end
    end
  end

  def flag(pos)
    tile = self[*pos]
    if !tile.flagged && !tile.value.is_a?(Integer)
      tile.flagged = true
      # tile.value = nil
    else
      tile.flagged = false
      # tile.value = 0
    end
  end

  def lose?
    grid.flatten.any? { |tile| tile.bomb && tile.revealed }
  end

  def win?
    over? && !lose?
  end

  def over?
    return true if lose?
    bombs = grid.flatten.reject { |tile| tile.bomb == false }
    return true if bombs.all?(&:flagged)
    no_bombs = grid.flatten - bombs
    return true if no_bombs.all?(&:revealed)
    false
  end
end
