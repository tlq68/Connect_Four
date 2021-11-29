# frozen_string_literal: true

require 'colorize'

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

  def select_space(row, column)
    display_board
    [row, column] 
  end

  def change_space(column, symbol)
    row = set_row(column)
    select_space(row, column)
    @board[row][column] = symbol
  end

  def display_board
    format_board(@board)
  end

  def set_row(input)
    decrementer = 0

    while decrementer <= 6

      break if free_space?(5 - decrementer, input) == true
      decrementer += 1
    end
    5 - decrementer
  end

  def free_space?(row, column)
    return false if !row.between?(0, 6)
    @board[row][column] == BLANK_CIRCLE
  end

  def win(symbol)
    display_board
    exit if win_vertical?(symbol) || win_horizontal?(symbol) || win_left_diagonal?(symbol) || win_right_diagonal?(symbol)
  end

  def win_vertical?(symbol)
    (0..5).each do |row|
      (0..6).each do |column|
        begin
          vertical_win = @board[row][column] == symbol && @board[row - 1][column] == symbol && @board[row - 2][column] == symbol && @board[row - 3][column] == symbol
          
        rescue NoMethodError
          
        end
          return vertical_win if vertical_win == true
      end
    end
    false
  end

  def win_horizontal?(symbol)
    (0..5).each do |row|
      (0..6).each do |column|
        begin
          horizontal_win = @board[row][column] == symbol && @board[row][column - 1] == symbol && @board[row][column - 2] == symbol && @board[row][column - 3] == symbol
          
        rescue NoMethodError
          
        end
          return horizontal_win if horizontal_win == true
      end
    end
    false
  end

  def win_left_diagonal?(symbol)
    (0...5).each do |row|
      (0..6).each do |column|
        begin
        left_diagonal_win =  @board[row][column] == symbol && @board[row + 1][column + 1] == symbol && @board[row + 2][column + 2] == symbol && @board[row + 3][column + 3] == symbol
          
        rescue NoMethodError
          
        end

        return left_diagonal_win if left_diagonal_win == true
      end
    end
    false
  end

  def win_right_diagonal?(symbol)
    (0..5).each do |row|
      (0..6).each do |column|
        begin
          right_diagonal_win = @board[row][column] == symbol && @board[row + 1][column - 1] == symbol && @board[row + 2][column - 2] == symbol && @board[row + 3][column - 3] == symbol
          
        rescue NoMethodError
          
        end

          return right_diagonal_win if right_diagonal_win == true
      end
    end
    false
  end
end

class Player 
  attr_accessor :symbol

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
  
  def initialize(symbol = nil)
    @symbol = symbol
  end

  def display_colors(name = nil)
    puts "\nChoose a color #{name}".light_green
    COLOR_HASH.each do |x, y|
      puts "#{x}: #{y}" if x.to_i > 10
      puts " #{x}: #{y}" if x.to_i < 10
    end
  end

  def color_picker(input)
    input = input.to_s
    self.symbol = COLOR_HASH[input]
  end

  def column_selection
    input = gets.chomp
    while !input.to_i.between?(1, 7) || input.downcase == 'q'
      puts 'Please choose a valid column'
      input = gets.chomp
    end
    input.to_i - 1
  end
end

class Computer < Player
  attr_accessor :symbol

  def initialize(symbol = nil)
    @symbol = symbol
  end

  def display_colors(name = nil)
    super
  end

  def color_picker(input)
    super
  end

  def column_selection
    puts "It's the computer's turn".green
    gets.chomp
    num = rand(0..6)
    puts "The computer chose column #{num + 1}".light_yellow
    num
  end
end

class Game
  attr_accessor :turn_counter, :board, :player1, :player2

  def play
    setup_game
    while !board_full?
      current_player = which_turn(@player1, @player2)
      column_selection = current_player.column_selection
      quit(column_selection)
      
      if @board.set_row(column_selection).between?(0, 6)
        add_turn
        @board.change_space(column_selection, current_player.symbol)

        @board.win(current_player.symbol)
      else
        puts 'Please choose an unfilled column'.cyan
      end
      @board.display_board

      puts "What is this?".yellow
      
      puts @turn_counter, "Turns".green
    end
    # The next thing we need to do is set up a turn tracker.
    # This will determine who is actually playing.
    # Then we need to add the board display after every selection.
    # We will need to use the select space method to actually select a space.
  end

  def setup_game
    @board = Board.new
    @board.format_board(board.create_board)
    start_game_message
    @turn_counter = 0
    start_game_message
    @player1 = choose_player_one
    @player2 = choose_player_two
    set_tokens(player1, player2) until player_symbols_exist?(player1, player2)
    same_token_check(player1, player2)
    puts "Player 1 token #{player1.symbol}"
    puts "Player 2 token #{player2.symbol}"
  end
  
  def set_tokens(player1, player2)
    input_player1 = 0
    while !input_player1.between?(1, 16)
      player1.display_colors('Player 1')
      input_player1 = gets.chomp.to_i
    end
    player1.color_picker(input_player1) 

    input_player2 = 0
    while !input_player2.between?(1, 16)
      player2.display_colors('Player 2')
      input_player2 = gets.chomp.to_i
    end
    player2.color_picker(input_player2)
  end

  def player_symbols_exist?(player1, player2)
    player1.symbol.nil? && player2.symbol.nil?
  end

  def players(player_selection)
    return Player.new if player_selection == 1
    return Computer.new if player_selection == 2
  end

  def choose_player_one
    input_player1 = 0
    until valid_player_choice_input(input_player1)
      puts "\nWill Player 1 be a human or a computer?"

      input_player1 = gets.chomp.to_i
    end
    players(input_player1) 
  end

  def choose_player_two
    input_player2 = 0
    until valid_player_choice_input(input_player2)
      puts 'Will Player 2 be a human or a computer?'
      input_player2 = gets.chomp.to_i
    end
    players(input_player2) 
  end

  def same_token_check(player1, player2)
    while player1.symbol == player2.symbol
      puts 'did we make it here?'
      reset_symbols(player1, player2) if !player_symbols_exist?(player1, player2)
      break if !player1.symbol.nil? && !player2.symbol.nil?
      set_tokens(player1, player2)
    end
  end

  def reset_symbols(player1, player2)
      player1.symbol = nil
      player2.symbol = nil
      puts "\nThe player tokens cannot be the same.".yellow
      puts 'Please choose again.'.light_green
  end

  def start_game_message
    puts 'Welcome to Connect 4! The goal is in the name.'
    puts 'You want to connect four of your tokens in a row horizontally, vertically or diagonally.'
    puts "\n During the game, you will select a column 1-7 to drop in your token"
    puts "But first, who is playing?"
  end

  def select_participants
    puts 'Who is going to play?'
    puts 'Select "1" for human.'
    puts 'Select "2" for computer.'
  end

  def valid_column_input(input)
    input.between?(1..7)
  end

  def valid_player_choice_input(input)
    input == 1 || input == 2
  end

  def add_turn
    @turn_counter += 1
  end

  def board_full?
    @turn_counter >= 42
  end

  def which_turn(player1, player2)
    @turn_counter.even? ? player1 : player2
  end

  def quit(input)
    exit if input == 'q'
  end
end

game = Game.new

game.play
