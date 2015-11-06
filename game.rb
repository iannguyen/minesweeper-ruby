require_relative 'board'
require_relative 'tile'
require_relative 'player'

class Game
  attr_reader :board, :player

  def initialize(player, board)
    @player = player
    @board = board
  end

  def get_move
    process_move(player.get_move)
  end

  def process_move(parsed)
    action = parsed[0]
    position = parsed[1]
    action == 'R' ? board.reveal(position) : board.flag(position)
    if action == 'R' && board[*position].revealed
      puts 'Position already revealed.'
    elsif action == 'F' && board[*position].value.is_a?(Integer)
      puts 'Can only flag unrevealed positions.'
    end
  end

  def over?
    board.over?
  end

  def display
    board.render
  end

  def run
    display
    until over?
      get_move
      display
    end
    if board.win?
      puts 'YOU WIN!!! B)'
    else
      puts 'YOU LOSE!!! =('
    end
  end
end

if $PROGRAM_NAME == __FILE__
  b = Board.new(10)
  david = Player.new('David')
  Game.new(david, b).run
end
