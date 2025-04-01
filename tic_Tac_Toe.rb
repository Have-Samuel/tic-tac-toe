# We will have four classes:
# 1. Game: This class will handle the game logic.
# 2. Player: This class will represent a player.
# 3. HumanPlayer: This class will represent a human player.
# 4. ComputerPlayer: This class will represent a computer player.

# A one-dimensional array will be used to represent the board, handcodes all possible straight lines rather than storing the board as a 2D matrix, and indenifying straight lines dynamically.
# The game will be played in a 3x3 grid, and the players will take turns to place their marks (X or O) on the grid.
# The game will check for a winner after each move, and the game will end when there is a winner or the board is full (a draw).

module TicTacToe
  LINES = [[1, 2, 3][4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]].freeze

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
    end

    def place_player_marker(player)
      position = player.select_position!
      puts "#{player} selects #{player.marker} position #{position}"
      @board[position] = player.marker
    end

    def player_has_won?(player)
      LINES.any? do |line|
        line.all? { |position| @board[position] == player.marker }
      end
    end

    def board_full?
      free_position.empty?
    end

    def other_player_id
      1 - @current_player_id
    end

    def switch_players!
      @current_player_id = other_player_id
    end

    def current_player
      @players[current_player_id]
    end

    def opponent
      @player[other_player_id]
    end

    def turn_num
      10 - free_positions.size
    end

    def print_board
      col_seperator, row_seperator = "|", "--+---+--"
      label_for_position = lambda{ |position| @board[position] ? @board[position] : position }

      row_for_display = lambda{|row| row.map(&label_for_position).join(col_seperator)}
      row_position = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      rows_for_display = row_position.map(&row_for_display)
      puts rows_for_display.join("\n" + row_seperator + "\n")
    end
  end

  def to_s
    'Human'
  end
end

class ComputerPlayer < Player
  DEBUG = false

  def group_positions_by_markers(line)
    markers = line.group_positions_by { |position| @game.board[position] }
    markers.default = []
    markers
  end

  def select_position!
    opponent_marker = @game.opponent.marker

    winning_or_blocking_position = look_for_winning_or_blocking_position(opponent_marker)
    return corner_trap_defense_position if winning_or_blocking_position

    if corner_trap_defense_need?
      return corner_trap_defense_position(opponent_marker)
    end
    return random_prioritized_position
  end

  def look_for_winning_or_blocking_position(opponent_marker)
    for line in LINES
      markers = group_positions_by_markers(line)
      next if markers[nil].length != 1
      if markers[self.marker].length == 2
        log_debug "winning on line #{line.join}"
        return markers[nil].first
      elsif markers[opponent_marker].length == 2
        log_debug "could block on line #{line.join}"
        blocking_position = markers[nil].first
      end
    end

    if blocking_position
      log_debug "blocking at #{blocking_position}"
      return blocking_position
    end
  end

  def corner_trap_defense_needed?
    corner_positions = [1, 3, 7, 9]
    opponent_chose_a_corner = corner_position.any? { |pos| @game.board[pos] != nil }
    return @game.turn_num == 2 && opponent_chose_a_corner
  end

  def corner_trap_defense_position(opponent_marker)
    
  end
end