class Player
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def get_move
    puts "Select 'R' to reveal or 'F' to flag, then enter coordinates!"
    puts '(i.e. R 3,5)'
    input = gets.chomp
    until valid_move?(input)
      puts 'Invalid move! Try again'
      input = gets.chomp
    end
    parse_move(input)
  end

  def valid_move?(move)
    if move.length == 5 && move.split.length == 2 &&
       (parse_move(move)[0] != 'R' || parse_move(move)[0] != 'F') &&
       parse_move(move)[1].count == 2
      true
    else
      false
    end
    # return false if move.length != 5
    # return false if move.split.length != 2
    # return false if parse_move(move)[0] != "R" || parse_move(move)[0] != "F"
    # true
  end

  def parse_move(move)
    splitted = move.split
    key = splitted[0].upcase
    coordinates = splitted[1].split(',').map(&:to_i)
    [key, coordinates]
  end
end
