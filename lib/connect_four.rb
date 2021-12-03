# frozen_string_literal: true

require 'colorize'

class Game
  attr_accessor :turn_counter, :board, :player1, :player2

  def play
    setup_game
    gameplay
    drawn_game
    quit
  end

  def setup_game
    system('clear') || system('cls')
    @board = Board.new
    @board.create_board
    start_game_message
    @turn_counter = 0
    choose_player
    @player1.set_name('Player1')
    @player2.set_name('Player2')
    set_tokens(player) until player_symbols_exist?(player1, player2)
    same_token_check(player1, player2)
    puts "\nYou can enter " + 'q'.light_red + ' at any time during the game to ' + 'quit'.red
    puts "\nPress 'Enter' to continue"
    gets.chomp
  end

  def gameplay
    while !board_full?
      system('clear') || system('cls')
      show_board_and_tokens
      puts "Turn #{@turn_counter + 1}".light_green
      current_player = which_turn(@player1, @player2)
      column_selection = current_player.column_selection
      break if column_selection == 'q'

      if @board.set_row(column_selection).between?(0, 6)
        add_turn
        @board.change_space(column_selection, current_player.symbol)
        @board.win(current_player)
      end
    end
  end

  def start_game_message
    puts '--------------------------------------------------------------------------'
    puts "\nWelcome to " + 'Connect 4'.light_yellow + '! The goal is in the name.'
    puts 'You want to ' + 'connect four of your tokens'.cyan + ' in a row horizontally, vertically' + "\nor diagonally to win!"
    puts "\nDuring the game, you will select a column (" + '1-7'.light_red + ') to drop in your token.'
    puts "\n--------------------------------------------------------------------------"
  end

  def choose_player
    player_input = 0
    puts 'Who is playing?'.light_magenta

    until player_input == 1 || player_input == 2
      puts "\nWill the first participant be a " + 'human'.green + ' (enter ' + '1'.green + ') or a ' + 'computer'.light_yellow + ' (enter ' + '2'.light_yellow + ')?'
      player_input = gets.chomp.to_i
    end
    @player1 = players(player_input)

    player_input = 0
    until player_input == 1 || player_input == 2
      puts "\nWill the second participant be a " + 'human'.green + ' (enter ' + '1'.green + ') or a ' + 'computer'.light_yellow + ' (enter ' + '2'.light_yellow + ')?'
      player_input = gets.chomp.to_i
    end
    @player2 = players(player_input)
  end

  def players(player_selection)
    return Player.new if player_selection == 1
    return Computer.new if player_selection == 2
  end

  def player_symbols_exist?(player1, player2)
    player1.symbol.nil? && player2.symbol.nil?
  end

  def set_tokens(player)
    input_player1 = 0
    until input_player1.between?(1, 16)
      player.display_colors
      input_player1 = gets.chomp.to_i
    end
    player.color_picker(input_player1) 
  end

  def same_token_check(player1, player2)
    while player1.symbol == player2.symbol
      unless player_symbols_exist?(player1, player2)
        reset_symbols(player1, player2)
      end
      set_tokens(player1)
      set_tokens(player2)
    end
  end

  def reset_symbols(player1, player2)
    player1.symbol = nil
    player2.symbol = nil
    puts "\nThe player tokens cannot be the same.".yellow
    puts 'Please choose again.'.light_green
  end

  def show_board_and_tokens
    @board.display_board
    puts "#{@player1.name}'s token #{@player1.symbol}"
    puts "#{@player2.name}'s token #{@player2.symbol}"
  end

  def board_full?
    @turn_counter >= 42
  end

  def which_turn(player1, player2)
    @turn_counter.even? ? player1 : player2
  end

  def add_turn
    @turn_counter += 1
  end

  def drawn_game
    puts 'The board is full and it seems to be a draw!'
  end

  def quit 
    puts 'Thanks for playing!'
    exit
  end
end

class Board
  attr_accessor :symbol, :board

  BLANK_CIRCLE = "\u{1F534}"

  def create_board
    @board = Array.new(6) { Array.new(7) { BLANK_CIRCLE } }
  end

  def format_board(board)
    puts '  ----------------------'
    board.each do |row|
      puts " | #{row.to_a.join(' ')} |"
    end
    puts '  |  |______________|  |'
    puts '  |__|______________|__|'
  end

  def display_board
    format_board(@board)
  end

  def select_space(row, column)
    [row, column] 
  end

  def change_space(column, symbol)
    row = set_row(column)
    select_space(row, column)
    @board[row][column] = symbol
  end

  def set_row(input)
    decrementer = 0
    while decrementer <= 5
      break if free_space?(5 - decrementer, input) == true

      decrementer += 1
    end
    5 - decrementer
  end

  def free_space?(row, column)
    return false unless row.between?(0, 6)

    @board[row][column] == BLANK_CIRCLE
  end

  def win(player)
    system('clear') || system('cls')
    display_board
    if win_vertical?(player.symbol) || win_horizontal?(player.symbol) || win_left_diagonal?(player.symbol) || win_right_diagonal?(player.symbol)
      puts "Hurray! #{player.name} won!".light_yellow
      exit
    end
  end

  def win_vertical?(symbol)
    (0..5).each do |row|
      (0..6).each do |column|
        next if row < 3
          vertical_win = @board[row][column] == symbol && @board[row - 1][column] == symbol && @board[row - 2][column] == symbol && @board[row - 3][column] == symbol
          return vertical_win if vertical_win == true
      end
    end
    false
  end

  def win_horizontal?(symbol)
    (0..5).each do |row|
      (0..6).each do |column|
        next if column < 4
          horizontal_win = @board[row][column] == symbol && @board[row][column - 1] == symbol && @board[row][column - 2] == symbol && @board[row][column - 3] == symbol
          return horizontal_win if horizontal_win == true
      end
    end
    false
  end

  def win_left_diagonal?(symbol)
    (0...5).each do |row|
      (0..6).each do |column|
        break if row > 2
        break if column > 3
        left_diagonal_win =  @board[row][column] == symbol && @board[row + 1][column + 1] == symbol && @board[row + 2][column + 2] == symbol && @board[row + 3][column + 3] == symbol
        return left_diagonal_win if left_diagonal_win == true
      end
    end
    false
  end

  def win_right_diagonal?(symbol)
    (0..5).each do |row|
      (0..6).each do |column|
        next if (row + 3) >= 6
        next if (column - 3) < 0
          right_diagonal_win = @board[row][column] == symbol && @board[row + 1][column - 1] == symbol && @board[row + 2][column - 2] == symbol && @board[row + 3][column - 3] == symbol          
          return right_diagonal_win if right_diagonal_win == true
      end
    end
    false
  end
end

class Player 
  attr_accessor :symbol, :name

  COLOR_HASH = {  '1' => "\u{1F534}".blue, 
                  '2' => "\u{1F534}".light_blue, 
                  '3' => "\u{1F534}".red, 
                  '4' => "\u{1F534}".light_red, 
                  '5' => "\u{1F534}".green, 
                  '6' => "\u{1F534}".light_green, 
                  '7' => "\u{1F534}".yellow, 
                  '8' => "\u{1F534}".light_yellow, 
                  '9' => "\u{1F534}".cyan, 
                  '10' => "\u{1F534}".light_cyan, 
                  '11' => "\u{1F534}".magenta, 
                  '12' => "\u{1F534}".light_magenta, 
                  '13' => "\u{1F534}".white, 
                  '14' => "\u{1F534}".light_white, 
                  '15' => "\u{1F534}".black, 
                  '16' => "\u{1F534}".light_black 
                }
  
  def initialize(symbol = nil, name = '')
    @symbol = symbol
    @name = name
  end

  def set_name(participant)
    until name != ''
      puts "Enter a name for #{participant}".light_green
      self.name = gets.chomp 
    end
  end

  def display_colors
    puts "\nChoose a color #{self.name}".light_green
    COLOR_HASH.each do |key, color|
      puts "#{key}: #{color}" if key.to_i > 10
      puts " #{key}: #{color}" if key.to_i < 10
    end
  end

  def color_picker(input)
    input = input.to_s
    self.symbol = COLOR_HASH[input]
  end

  def column_selection
    puts "It's time to choose a column, #{self.name}. Select 1-7".light_green
    input = gets.chomp
    while !input.to_i.between?(1, 7) || input.downcase == 'q'
      return input.downcase if input.downcase == 'q'

      puts 'Please choose a valid column'
      input = gets.chomp
    end

    input.to_i - 1
  end
end

class Computer < Player
  attr_accessor :symbol, :name

  def initialize(symbol = nil, name = '')
    @symbol = symbol
    @name = name
  end

  def set_name(participant)
    super
  end

  def display_colors
    super
  end

  def color_picker(input)
    super
  end

  def column_selection
    puts "It's #{name}'s turn".light_yellow
    num = rand(0..6)
    puts "The computer chose column #{num + 1}".light_yellow
    input = gets.chomp
    return input.downcase if input.downcase == 'q'

    num
  end
end

game = Game.new

game.play
