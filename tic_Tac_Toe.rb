# We will have four classes:
# 1. Game: This class will handle the game logic.
# 2. Player: This class will represent a player.
# 3. HumanPlayer: This class will represent a human player.
# 4. ComputerPlayer: This class will represent a computer player.

# A one-dimensional array will be used to represent the board, handcodes all possible straight lines rather than storing the board as a 2D matrix, and indenifying straight lines dynamically.
# The game will be played in a 3x3 grid, and the players will take turns to place their marks (X or O) on the grid.
# The game will check for a winner after each move, and the game will end when there is a winner or the board is full (a draw).

module TicTacToe
  LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]].freeze

  class Game
    def initialize(player_1_class, player_2_class)
      @board = Array.new(10) # We ignore index 0 for convenience
      @current_player_id = 0
      @players = [player_1_class.new(self, 'x'), player_2_class]
      puts "#{current_player} goes first"
    end
    attr_reader :board, :current_player_id

    def play
      loop do
        place_player_marker(current_player)

        if player_has_won?(current_player)
          puts "#{current_player} wins!"
          print_board
          return
        elsif board_full?
          puts "It's a draw."
          print_board
          return
        end

        switch_players!
      end
    end

    def free_positions
      (1..9).select { |position| @board[position].nil? }
      # This means that if the position is nil, it is free and anyone can play there
    end

    def place_player_marker(player)
      position = player.select_position!
      puts "#{player} selects #{player.marker} position #{position}"
      @board[position] = player.marker
    end
    # This code above is used to place the player's marker on the board at the selected position.
    # The select_position! method is called on the player object, which will either be a human or a computer player.
    # The selected position is then marked with the player's marker (X or O) on the board.

    def player_has_won?(player)
      LINES.any? do |line|
        line.all? { |position| @board[position] == player.marker }
      end
    end
    # This code checks if the player has won by checking if any of the lines (rows, columns, diagonals) contain all three of the player's markers.
    # The any? method returns true if at least one of the lines contains all three markers.
    # The all? method checks if all the positions in the line are equal to the player's marker.
    # If the player has won, the method returns true; otherwise, it returns false.
    # The LINES constant contains all the possible winning lines in the game.
    # The method iterates through each line and checks if all the positions in that line are occupied by the player's marker.
    # If a winning line is found, the method returns true; otherwise, it returns false.
    # The player_has_won? method is called after each player's move to check if they have won the game.
    # If a player has won, the game ends and a message is displayed indicating the winner.
    # The method uses the any? method to check if any of the lines contain all three of the player's markers.

    def board_full?
      free_position.empty?
    end
    # This code checks if the board is full by checking if there are any free positions left on the board.

    def other_player_id
      1 - @current_player_id
    end
    # This code calculates the ID of the other player by subtracting the current player's ID from 1.
    # The current player ID is either 0 or 1, so the other player ID will be the opposite value.
    # For example, if the current player ID is 0, the other player ID will be 1, and vice versa.
    # This is used to switch between players during the game.
    # The other_player_id method is used to determine which player is not currently taking their turn.
    # This is useful for checking the opponent's marker and making strategic decisions during the game.
    # The other_player_id method is called when the game needs to check the opponent's marker or make decisions based on the opponent's moves.
    # For example, when the computer player is looking for a winning or blocking position, it needs to know the opponent's marker to make the right move.
    # The other_player_id method is also used to switch between players during the game.
    # The switch_players! method is called after each player's turn to switch the current player to the other player.
    # This is done by updating the @current_player_id instance variable to the other player's ID.

    def switch_players!
      @current_player_id = other_player_id
    end
    # The switch_players! method is used to switch the current player after each turn.
    # This code switches the current player by updating the @current_player_id instance variable to the other player's ID.

    def current_player
      @players[current_player_id]
    end
    # This code retrieves the current player object from the @players array using the current_player_id.
    # The current_player method is used to get the player who is currently taking their turn.
    # This is useful for placing the player's marker on the board and checking if they have won.
    # The current_player method is called when the game needs to place the player's marker on the board or check if they have won.
    # For example, when the game starts, the current_player method is called to determine which player goes first.
    # The current_player method is also used to switch between players during the game.

    def opponent
      @players[other_player_id]
    end
    # This code retrieves the opponent player object from the @players array using the other_player_id.
    # The opponent method is used to get the player who is not currently taking their turn.
    # This is useful for checking the opponent's marker and making strategic decisions during the game.
    # The opponent method is called when the game needs to check the opponent's marker or make decisions based on the opponent's moves.
    # For example, when the computer player is looking for a winning or blocking position, it needs to know the opponent's marker to make the right move.

    def turn_num
      10 - free_positions.size
    end
    # This code calculates the current turn number by subtracting the number of free positions from 10.
    # The turn_num method is used to keep track of the current turn number in the game.
    # This is useful for determining the current player's turn and checking if the game is over.
    # The turn_num method is called after each player's move to update the turn number.
    # The turn_num method is also used to check if the game is over.

    def print_board
      col_seperator = '|'
      row_seperator = '--+---+--'
      label_for_position = lambda{ |position| @board[position] || position }
      # This code defines a lambda function that takes a position as an argument and returns the marker at that position on the board.
      # If the position is empty (nil), it returns the position number instead.
      # The label_for_position lambda function is used to display the current state of the board.
      # The print_board method uses the label_for_position lambda function to display the current state of the board.

      row_for_display = lambda{|row| row.map(&label_for_position).join(col_seperator)}
      row_position = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      rows_for_display = row_position.map(&row_for_display)
      puts rows_for_display.join("\n#{row_seperator}\n")
    end
  end
  # This code defines the Game class, which handles the game logic.
  # The Game class has methods to initialize the game, play the game, place player markers, check for a winner, check if the board is full, switch players, and print the board.
  # The Game class also has methods to get the current player, opponent, and turn number.
  # The Game class uses a one-dimensional array to represent the board and handcodes all possible straight lines rather than storing the board as a 2D matrix.
  # The Game class also defines a constant LINES that contains all the possible winning lines in the game.
  # The Game class uses the LINES constant to check for a winner after each move.

  class Player
    def initialize(game, marker)
      @game = game
      @marker = marker
    end
    attr_reader :marker
  end

  class HumanPlayer < Player
    def select_position!
      @game.print_board
      loop do
        print "Select your #{@marker} position: "
        selection = gets.to_i
        # This code prompts the user to select a position for their marker and reads the input from the console.

        return selection if @game.free_positions.include?(selection)

        # This code checks if the selected position is free (not occupied by another marker).

        puts "Position #{selection} is not available. Try again."
      end
    end

    def to_s
      'Human'
    end
  end
  # This code defines the HumanPlayer class, which represents a human player.

  class ComputerPlayer < Player
    DEBUG = false
    # Set to true to see debug messages

    def group_positions_by_markers(line)
      markers = line.group_positions_by { |position| @game.board[position] }
      markers.default = []
      markers
    end
    # This code groups the positions in a line by their markers (X or O) using the group_by method.
    # The group_positions_by_markers method takes a line (array of positions) as an argument and returns a hash where the keys are the markers and the values are arrays of positions occupied by that marker.

    def select_position!
      opponent_marker = @game.opponent.marker
      log_debug "opponent marker is #{opponent_marker}"
      # This code retrieves the opponent's marker from the game object.
      # The select_position! method is called to select a position for the computer player's marker.
      # The opponent_marker variable is used to check for winning or blocking positions.

      winning_or_blocking_position = look_for_winning_or_blocking_position(opponent_marker)
      return corner_trap_defense_position if winning_or_blocking_position

      return corner_trap_defense_position(opponent_marker) if corner_trap_defense_need?

      random_prioritized_position
    end

    def look_for_winning_or_blocking_position(opponent_marker)
      LINES.each do |line|
        markers = group_positions_by_markers(line)
        next if markers[nil].length != 1

        if markers[marker].length == 2
          log_debug "winning on line #{line.join}"
          return markers[nil].first
        elsif markers[opponent_marker].length == 2
          log_debug "could block on line #{line.join}"
          markers[nil].first
        end
      end

      return unless blocking_position

      log_debug "blocking at #{blocking_position}"
      blocking_position
    end

    def corner_trap_defense_needed?
      corner_positions = [1, 3, 7, 9]
      opponent_chose_a_corner = corner_positions.any? { |pos| !@game.board[pos].nil? }
      @game.turn_num == 2 && opponent_chose_a_corner
    end

    def corner_trap_defense_position(opponent_marker)
      # if you respond in the center or the opposite corner, the opponent can force you to lose
      log_debug 'defending against corner start by playing adjacent'
      # playing in an adjacent corner could also be safe, but would require more logic later on
      opponent_position = @game.board.find_index { |marker| marker == opponent_marker }
      safe_response = {1 => [2, 4], 3 => [2, 6], 7 => [4, 8], 9 => [6, 8] }
      return safe_response[opponent_position].sample
    end

    def random_prioritized_position
      log_debug "picking random position, favouring center and then corners"
      ([5] + [1, 3, 7, 9].shuffle + [2, 4, 6, 8].shuffle).find do |pos|
        @game.free_positions.include?(pos)
      end
    end

    def log_debug(message)
      puts "#{self}: #{message}" if DEBUG
    end

    def to_s
      "Computer#{@game.current_player_id}"
    end
  end
end

include TicTacToe

Game.new(ComputerPlayer, ComputerPlayer).play
puts
players_with_human = [Human_player, ComputerPlayer].shuffle
Game.new(*players_with_human).play