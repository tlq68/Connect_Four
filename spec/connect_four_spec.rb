require 'connect_four.rb'



describe Game do
  let(:player) { Player.new }
  let(:computer) { Computer.new }
  let(:square) { Board.new }
  let(:yellow_circle) { "\u{1F534}".light_yellow }
  let(:green_circle) { "\u{1F534}".green }
  subject(:game) { described_class.new }

  describe '#play' do
    # Not necessary to test this method as it only calls other methods
  end

  describe '#setup_game' do
    # Not necessary to test this method as it only calls other methods
  end

  describe '#gameplay' do
    # Not sure if the if statement needs testing...
  end

  describe '#start_game_message' do
    # Not necessary to test puts method
  end

  describe '#choose_player' do
    # Not necessary to test this method, but #players method should be tested
  end

  describe '#players' do
    context 'when input is 1' do
      it 'creates a player object' do
      expect(Player).to receive(:new)
      game.players(1)
      end
    end

    context 'when input is 2' do
      it 'creates a computer object' do
        expect(Computer).to receive(:new)
        game.players(2)
      end
    end
  end

  describe '#player_symbols_exist?' do
    context 'when both players have a symbol' do
      before do 
        player.symbol = yellow_circle
        computer.symbol = green_circle
      end
      it 'returns false' do
        expect(game.player_symbols_exist?(player, computer)).to be false
      end
    end

    context 'when one player has a symbol' do
      before do
        player.symbol = yellow_circle
      end
      it 'returns false' do
        expect(game.player_symbols_exist?(player, computer)).to be false
      end
    end

    context 'when neither player has a symbol' do
      before do
        player.symbol = nil
        computer.symbol = nil
      end
      it 'returns true' do
        expect(game.player_symbols_exist?(player, computer)).to be true
      end
    end
  end

  describe '#set_tokens' do
    # Not necessary to test, but Player#color_picker needs to be tested
  end

  describe '#same_token_check' do
    # Not necessary to test.
  end

  describe '#reset_symbols' do 
    context 'when triggered' do
      before do
        player.symbol = "\u{1F534}".light_yellow
        computer.symbol = "\u{1F534}".light_yellow
        game.reset_symbols(player, computer)
      end
      it 'resets tokens to nil' do 
        expect(player.symbol).to be nil  
      end
    end
  end

  describe '#show_board_and_tokens' do
    # Not necessary to test #puts
  end

  describe '#board_full?' do
    # Not necessary to test
  end

  describe '#add_turn' do
    # Not necessay to test
  end

  describe '#drawn_game' do
    # Not necessary to test
  end

  describe '#quit' do
    # Not necessary to test
  end
end

describe Board do 
  subject(:square) { described_class.new }
  let(:player) { Player.new }
  let(:computer) { Computer.new }
  let(:yellow_circle) { "\u{1F534}".light_yellow }
  let(:green_circle) { "\u{1F534}".green }

  describe '#free_space?' do
    context 'when space is blank' do
      before do 
        square.create_board
      end
      it 'returns true' do
        check_space = square.free_space?(3, 2)
        expect(check_space).to be true
      end
    end
  end

  describe '#change_space' do
    context 'when space is available' do
      before do
        square.create_board
        player_input = 3
        player.symbol = yellow_circle
        square.change_space(player_input, player.symbol)
      end
      it 'changes space to player token' do
        game_board = square.instance_variable_get(:@board)
        selected_square = game_board[5][3]
        expect(selected_square).to eq(yellow_circle)
      end
    end

    context 'when spaces in column are filled' do
      before do
        square.create_board
        player_input = 3
        player.symbol = yellow_circle
        square.change_space(player_input, player.symbol)
        square.change_space(player_input, player.symbol)
      end

      it 'fills the correct space' do
        game_board = square.instance_variable_get(:@board)
        selected_square = game_board[4][3]
        expect(selected_square).to eq(yellow_circle)
      end
    end

    context 'when spaces in other columns are filled' do
      before do
        square.create_board
        input3 = 3
        input4 = 4
        input5 = 5
        player.symbol = yellow_circle
        computer.symbol = green_circle
        square.change_space(input3, player.symbol)
        square.change_space(input3, computer.symbol)
        square.change_space(input3, computer.symbol)
        square.change_space(input3, computer.symbol)
        square.change_space(input3, player.symbol)
        square.change_space(input4, player.symbol)
        square.change_space(input4, computer.symbol)
        square.change_space(input4, computer.symbol)
        square.change_space(input4, player.symbol)
        square.change_space(input5, player.symbol)
      end

      it 'fills the correct space' do
        game_board = square.instance_variable_get(:@board)
        selected_square = game_board[2][3]
        expect(selected_square).to eq(green_circle)
      end
    end
  end

  describe '#set_row' do
    context 'when row is empty' do
      before do
        square.create_board
      end
      it 'sets the row to 5' do
        column = 4
        expect(square.set_row(column)).to eq(5)
      end
    end

    context 'when three spaces are filled in a column' do
      before do
        square.create_board
        column3 = 3
        player.symbol = yellow_circle
        square.change_space(column3, player.symbol)
        square.change_space(column3, player.symbol)
        square.change_space(column3, player.symbol)
      end
      it 'sets the row to 2' do
        column = 3
        expect(square.set_row(column)).to eq(2)
      end
    end

    context 'when column is full' do
      before do
        square.create_board
        column3 = 3
        player.symbol = yellow_circle
        square.change_space(column3, player.symbol)
        square.change_space(column3, player.symbol)
        square.change_space(column3, player.symbol)
        square.change_space(column3, player.symbol)
        square.change_space(column3, player.symbol)
        square.change_space(column3, player.symbol)
      end
      it 'returns -1' do
        column = 3
        expect(square.set_row(column)).to eq(-1)
      end
    end
  end

  describe '#win' do
    # Not necessary to test, but the individual win methods should be tested
  end

  describe '#win_vertical?' do
    context 'when vertical four-in-a-row' do
      before do
        square.create_board
        player.symbol = yellow_circle
        square.change_space(3, player.symbol)
        square.change_space(3, player.symbol)
        square.change_space(3, player.symbol)
        square.change_space(3, player.symbol)
        square.display_board
      end
      it 'returns true' do
        selected_line = square.win_vertical?(player.symbol)
        expect(selected_line).to be true
      end
    end

    context 'when four-in-a-row wraps around' do
      before do
        square.create_board
        player.symbol = yellow_circle
        computer.symbol = green_circle
        square.change_space(3, player.symbol)
        square.change_space(3, computer.symbol)
        square.change_space(3, computer.symbol)
        square.change_space(3, player.symbol)
        square.change_space(3, player.symbol)
        square.change_space(3, player.symbol)
        square.display_board
      end
      it 'returns false' do
        selected_line = square.win_vertical?(player.symbol)
        expect(selected_line).to be false
      end
    end
  end

  describe '#win_horizontal?' do
    context 'when horizontal four-in-a-row' do
      before do
        square.create_board
        player.symbol = yellow_circle
        square.change_space(3, player.symbol)
        square.change_space(4, player.symbol)
        square.change_space(5, player.symbol)
        square.change_space(6, player.symbol)
        square.display_board
      end
      it 'returns true' do
        selected_line = square.win_horizontal?(player.symbol)
        expect(selected_line).to be true
      end
    end

    context 'when four-in-a-row wraps around' do
      before do
        square.create_board
        player.symbol = yellow_circle
        square.change_space(0, player.symbol)
        square.change_space(1, player.symbol)
        square.change_space(2, player.symbol)
        square.change_space(6, player.symbol)
        square.display_board
      end
      it 'returns false' do
        selected_line = square.win_horizontal?(player.symbol)
        expect(selected_line).to be false
      end
    end
  end

  describe '#win_left_diagonal?' do
    context 'when left diagonal four-in-a-row' do
      before do
        square.create_board
        player.symbol = yellow_circle
        computer.symbol = green_circle
        square.change_space(6, player.symbol)
        square.change_space(5, computer.symbol)
        square.change_space(5, player.symbol)
        square.change_space(4, computer.symbol)
        square.change_space(4, computer.symbol)
        square.change_space(4, player.symbol)
        square.change_space(3, computer.symbol)
        square.change_space(3, computer.symbol)
        square.change_space(3, computer.symbol)
        square.change_space(3, player.symbol)
        square.display_board
      end
      it 'returns true' do
        selected_line = square.win_left_diagonal?(player.symbol)
        expect(selected_line).to be true
      end
    end

    context 'when four-in-a-row wraps around' do
      before do
        square.create_board
        player.symbol = yellow_circle
        computer.symbol = green_circle
        square.change_space(6, player.symbol)
        square.change_space(6, player.symbol)
        square.change_space(6, player.symbol)
        square.change_space(6, player.symbol)
        square.change_space(6, player.symbol)
        square.change_space(6, player.symbol)
        square.change_space(5, player.symbol)
        square.change_space(5, player.symbol)
        square.change_space(5, player.symbol)
        square.change_space(5, player.symbol)
        square.change_space(5, player.symbol)
        square.change_space(5, player.symbol)
        square.change_space(4, player.symbol)
        square.change_space(4, player.symbol)
        square.change_space(4, player.symbol)
        square.change_space(4, player.symbol)
        square.change_space(4, player.symbol)
        square.change_space(4, player.symbol)
        square.change_space(2, player.symbol)
        square.change_space(2, player.symbol)
        square.change_space(2, player.symbol)
        square.change_space(2, player.symbol)
        square.change_space(2, player.symbol)
        square.change_space(2, player.symbol)
        square.change_space(1, player.symbol)
        square.change_space(1, player.symbol)
        square.change_space(1, player.symbol)
        square.change_space(1, player.symbol)
        square.change_space(1, player.symbol)
        square.change_space(1, player.symbol)
        square.change_space(0, player.symbol)
        square.change_space(0, player.symbol)
        square.change_space(0, player.symbol)
        square.change_space(0, player.symbol)
        square.change_space(0, player.symbol)
        square.change_space(0, player.symbol)
        square.display_board
      end
      it 'returns false' do
        selected_line = square.win_left_diagonal?(player.symbol)
        expect(selected_line).to be false
      end
    end

    context 'when starting from the top row' do
      before do
        square.create_board
        player.symbol = yellow_circle
        computer.symbol = green_circle
        square.change_space(6, player.symbol)
        square.change_space(6, player.symbol)
        square.change_space(6, player.symbol)
        square.change_space(5, computer.symbol)
        square.change_space(5, computer.symbol)
        square.change_space(5, computer.symbol)
        square.change_space(5, player.symbol)
        square.change_space(4, computer.symbol)
        square.change_space(4, computer.symbol)
        square.change_space(4, computer.symbol)
        square.change_space(4, computer.symbol)
        square.change_space(4, player.symbol)
        square.change_space(3, computer.symbol)
        square.change_space(3, computer.symbol)
        square.change_space(3, computer.symbol)
        square.change_space(3, computer.symbol)
        square.change_space(3, computer.symbol)
        square.change_space(3, player.symbol)
        square.display_board
      end
      it 'returns true' do
        selected_line = square.win_left_diagonal?(player.symbol)
        expect(selected_line).to be true
      end
    end
  end

  describe '#win_right_diagonal' do
    context 'when right diagonal four-in-a-row' do
      before do
        square.create_board
        player.symbol = yellow_circle
        computer.symbol = green_circle
        square.change_space(3, player.symbol)
        square.change_space(4, computer.symbol)
        square.change_space(4, player.symbol)
        square.change_space(5, computer.symbol)
        square.change_space(5, computer.symbol)
        square.change_space(5, player.symbol)
        square.change_space(6, computer.symbol)
        square.change_space(6, computer.symbol)
        square.change_space(6, computer.symbol)
        square.change_space(6, player.symbol)
        square.display_board
      end
      it 'returns true' do
        selected_line = square.win_right_diagonal?(player.symbol)
        expect(selected_line).to be true
      end
    end
  end

  context 'when four-in-a-row wraps around' do
    before do
      square.create_board
      player.symbol = yellow_circle
      computer.symbol = green_circle
      square.change_space(6, player.symbol)
      square.change_space(6, computer.symbol)
      square.change_space(5, computer.symbol)
      square.change_space(5, player.symbol)
      square.change_space(1, player.symbol)
      square.change_space(1, player.symbol)
      square.change_space(1, computer.symbol)
      square.change_space(1, computer.symbol)
      square.change_space(1, player.symbol)
      square.change_space(0, computer.symbol)
      square.change_space(0, computer.symbol)
      square.change_space(0, computer.symbol)
      square.change_space(0, player.symbol)
      square.change_space(0, computer.symbol)
      square.change_space(0, player.symbol)
      square.display_board
    end
    it 'returns false' do
      selected_line = square.win_right_diagonal?(computer.symbol)
      expect(selected_line).to be false
    end
  end

  context 'when diagonal ends on top row' do
    before do
      square.create_board
      player.symbol = yellow_circle
      computer.symbol = green_circle
      square.change_space(3, player.symbol)
      square.change_space(3, player.symbol)
      square.change_space(3, player.symbol)
      square.change_space(4, computer.symbol)
      square.change_space(4, computer.symbol)
      square.change_space(4, computer.symbol)
      square.change_space(4, player.symbol)
      square.change_space(5, computer.symbol)
      square.change_space(5, computer.symbol)
      square.change_space(5, computer.symbol)
      square.change_space(5, computer.symbol)
      square.change_space(5, player.symbol)
      square.change_space(6, computer.symbol)
      square.change_space(6, computer.symbol)
      square.change_space(6, computer.symbol)
      square.change_space(6, computer.symbol)
      square.change_space(6, computer.symbol)
      square.change_space(6, player.symbol)
      square.display_board
    end
    it 'returns true' do
      selected_line = square.win_right_diagonal?(player.symbol)
      expect(selected_line).to be true
    end
  end
end

describe Player do 
  subject(:player) { described_class.new }
  describe '#color_picker' do 
    context 'when color is given' do 
      before do 
        player.color_picker('8')
      end
      it 'sets player color' do
        expect(player.symbol).to eq("\u{1F534}".light_yellow)
      end
    end
  end
end

describe Computer do 

end
