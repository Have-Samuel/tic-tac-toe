class Game
  @@turn_count = 1
  @@winner = ''

  def initialize
    puts 'Welcome to Tic Tac Toe!'
    puts 'Player 1, please enter your name:'
    # Still with the @ symbol, but not an instance variable, these are class variables
    @player_one_name = gets.chomp
    puts 'Player 2, please enter your name:'
    @player_two_name = gets.chomp
    @board = Array.new(3) { Array.new(3, '_') }
  end

  # Blank board showing in the console
  def display_board(board)
    puts "\r"
    puts "#{board[0][0]} | #{board[0][1]} | #{board[0][2]}"
    puts "#{board[1][0]} | #{board[1][1]} | #{board[1][2]}"
    puts "#{board[2][0]} | #{board[2][1]} | #{board[2][2]}"
    puts "\r"
  end

  # Player_turn functionality
  def player_turn(turn)
    if turn
      player_choice(@player_one_name, 'O')
    else
      player_choice(@player_two_name, 'X')
    end
  end

  def player_choice(player, symbol)
    puts "#{player}, Please enter your coordinate seperated by a space:"
    input = gets.chomp
    input_array = input.split
    coord_one = input_array[0].to_i
    coord_two = input_array[1].to_i

    # Loop until the user input in valid - has space, btn the coordinates are between 0 and 2
    # and the coordinates are not already taken on the board
    until input.include?(' ') && coord_one.between?(0, 2) && coord_two.between?(0, 2) && @board[coord_one][coord_two] == '_'
      # @board[coord_one][coord_two] == ' ' => Checks whether the coordinates are still empty
      puts 'Invalid input. Please enter your coordinates for an empty space in the grid:'
      input = gets.chomp
      input_array = input.split
      coord_one = input_array[0].to_i
      coord_two = input_array[1].to_i
    end

    add_to_board(coord_one, coord_two, symbol)
  end

  def add_to_board(coord_one, coord_two, symbol)
    @board[coord_one][coord_two] = symbol
    @@turn_count += 1
  end

  # Check 3 across
  def three_across
    @board.each do |i|
      if i.all? { |j| j == 'X' }
        @@winner = @player_one_name
        @@turn_count = 10
      elsif i.all? { |j| j == 'O' }
        @@winner = @player_two_name
        @@turn_count = 10
      end
    end
  end

  # Check 3 down
  def three_down
    flat = @board.flatten
    # Flatten the board and check if any of the columns have 3 in a row
    flat.each_with_index do |v, i|
      if v == 'X' && flat[i + 3] == 'X' && flat[i + 6] == 'X'
        @@winner = @player_one_name
        @@turn_count = 10
      elsif v == 'O' && flat[i + 3] == 'O' && flat[i + 6] == 'O'
        @@winner = @player_two_name
        @@turn_count = 10
      end
    end
  end

  # Check 3 diagonal
  def three_diagonal
    center_val = @board[1][1]
    # return unless %w[X O].include?(center_val)
    return unless %w[X O].include?(center_val)

    if @board[0][0] == center_val && @board[2][2] == center_val
      # @@winner = @player_one_name if center_val == 'X'
      # @@winner = @player_two_name if center_val == 'O'
      @@winner = center_val
      @@turn_count = 10
    elsif @board[0][2] == center_val && @board[2][0] == center_val
      # @@winner = @player_one_name if center_val == 'O'
      # @@winner = @player_two_name if center_val == 'X'
      @@winner = center_val
      @@turn_count = 10
    end
  end

  def declare_result(symbol)
    # Another way using lambda
    case symbol
    when 'O'
      puts "#{@player_one_name} wins the game!"
    when 'X'
      puts "#{@player_two_name} wins the game!"
    else
      puts "It's a draw!"
    end
  end

  def play_game
    puts "\r\n"
    puts 'Here is your empty battlefield:'
    display_board(@board)

    until @player_one_name == 'O' && @player_two_name == 'X'
      puts "\r\n"
      player_turn(@@turn_count)
      three_across
      three_down
      three_diagonal
      display_board(@board)
    end

    declare_result(@@winner)
  end
end

# Instructions
puts 'Welcome to Tic Tac Toe!, The rules are as expected, but choosing placement requires coordinates.'
puts 'Each turn, Enter two numbers with a space, per the grid layout below:'
puts "\r\n"
puts '0 0 | 0 1 | 0 2'
puts '1 0 | 1 1 | 1 2'
puts '2 0 | 2 1 | 2 2'
puts "\r\n"

# Instantiate the game and execute play game
game = Game.new
game.play_game
