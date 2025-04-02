class Game
  @@turn_count = 0
  @@winner = ''
  @@board = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]

  def initialize
    puts 'Welcome to Tic Tac Toe!'
    puts 'Player 1, please enter your name:'
    @player_one_name = gets.chomp
    puts 'Player 2, please enter your name:'
    @player_two_name = gets.chomp
    @@board = Array.new(3) { Array.new(3, ' ') }
  end

  # Blank board showing in the console
  def display_board(board)
    puts "\r"
    puts "#{board[0][0]} | #{board[0][1]} | #{board[0][2]}"
    puts "#{board[1][0]} | #{board[1][1]} | #{board[1][2]}"
    puts "#{board[2][0]} | #{board[2][1]} | #{board[2][2]}"
    puts "\r"
  end

  def player_turn(turn)
    if turn.odd?
      player_choice(@player_one_name, 'X')
    else
      player_choice(@player_two_name, 'O')
    end
  end

  
end