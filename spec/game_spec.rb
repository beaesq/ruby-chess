# frozen_string_literal: true

require_relative '../lib/main'

describe Game do
  subject(:new_game) { described_class.new }

  describe '#set_board_start' do
    it 'places all pieces correctly' do
      new_game.set_board_start
      board_array = new_game.instance_variable_get(:@board_array)
      pieces = []
      8.times do |x|
        pieces << board_array[x][0].piece
        pieces << board_array[x][1].piece
        pieces << board_array[x][6].piece
        pieces << board_array[x][7].piece
      end
      expect(pieces).to eq(['♖', '♙', '♟︎', '♜', '♘', '♙', '♟︎', '♞', '♗', '♙', '♟︎', '♝', '♕', '♙', '♟︎', '♛', '♔', '♙', '♟︎', '♚', '♗', '♙', '♟︎', '♝', '♘', '♙', '♟︎', '♞', '♖', '♙', '♟︎', '♜'])
    end
    it 'does not place pieces in empty squares' do
      new_game.set_board_start
      board_array = new_game.instance_variable_get(:@board_array)
      pieces = []
      4.times do |y|
        8.times do |x|
          pieces << board_array[x][y + 2].piece
        end
      end
      expect(pieces).to all(eq(nil))
    end
  end

  describe '#move_piece' do
    context 'when the move is valid' do
      before do
        board_array = new_game.instance_variable_get(:@board_array)
        board_array[1][1].piece = '♖'
        new_game.instance_variable_set(:@board_array, board_array)
        allow(new_game).to receive(:get_move_input).and_return([[1, 1], [3, 4]])
      end

      it 'moves the piece to the correct square' do
        new_game.move_piece
        board_array = new_game.instance_variable_get(:@board_array)
        start_sq = board_array[1][1]
        end_sq = board_array[3][4]
        expect(start_sq.piece).to be_nil
        expect(end_sq.piece).to eq('♖')
      end
    end
  end

  describe '#valid_move?' do
    context 'when the move is valid' do
      before do
        board_array = new_game.instance_variable_get(:@board_array)
        board_array[1][1].piece = '♔'
        new_game.instance_variable_set(:@board_array, board_array)
        allow(new_game).to receive(:get_valid_moves).and_return([[0, 1], [1, 0], [2, 1], [1, 2]])
      end
      it 'returns true' do
        start_coordinates = [1, 1]
        end_coordinates = [1, 2]
        result = new_game.valid_move?(start_coordinates, end_coordinates)
        expect(result).to be true
      end
    end

    context 'when the move is invalid' do
      before do
        board_array = new_game.instance_variable_get(:@board_array)
        board_array[1][1].piece = '♔'
        new_game.instance_variable_set(:@board_array, board_array)
        allow(new_game).to receive(:get_valid_moves).and_return([[0, 1], [1, 0], [2, 1], [1, 2]])
      end
      it 'returns false' do
        start_coordinates = [1, 1]
        end_coordinates = [1, 4]
        result = new_game.valid_move?(start_coordinates, end_coordinates)
        expect(result).to be false
      end
    end
  end

  describe '#empty_square?' do
    context 'when the square is empty' do
      it 'returns true' do
        result = new_game.empty_square?([1, 1])
        expect(result).to be true
      end
    end
    context 'when the square is not empty' do
      before do
        board_array = new_game.instance_variable_get(:@board_array)
        board_array[1][1].piece = '♖'
        new_game.instance_variable_set(:@board_array, board_array)
      end
      it 'returns false' do
        result = new_game.empty_square?([1, 1])
        expect(result).to be false
      end
    end
  end

  describe '#get_pawn_diagonal_moves' do
    context 'when there is an enemy piece diagonal to the pawn' do
      before do
        board_array = new_game.instance_variable_get(:@board_array)
        board_array[4][3].piece = '♚'
        new_game.instance_variable_set(:@board_array, board_array)
      end
      it 'returns the correct moves' do
        start_coordinates = [3, 2]
        color = 'white'
        valid_moves = new_game.get_pawn_diagonal_moves(start_coordinates[0], start_coordinates[1], color)
        expect(valid_moves).to match_array([[4, 3]])
      end
    end
    context 'when there is a friendly piece diagonal to the pawn' do
      before do
        board_array = new_game.instance_variable_get(:@board_array)
        board_array[3][5].piece = '♚'
        new_game.instance_variable_set(:@board_array, board_array)
      end
      it 'returns the correct moves' do
        start_coordinates = [4, 6]
        color = 'black'
        valid_moves = new_game.get_pawn_diagonal_moves(start_coordinates[0], start_coordinates[1], color)
        expect(valid_moves).to match_array([])
      end
    end
    context 'when there are no pieces diagonal to the pawn' do
      it 'returns the correct moves' do
        start_coordinates = [7, 7]
        color = 'black'
        valid_moves = new_game.get_pawn_diagonal_moves(start_coordinates[0], start_coordinates[1], color)
        expect(valid_moves).to match_array([])
      end
    end
  end

  describe '#get_pawn_moves' do
    context 'when there are no pieces in the way' do
      it 'returns the correct moves from the starting square' do
        start_coordinates = [1, 6]
        color = 'black'
        valid_moves = new_game.get_pawn_moves(start_coordinates[0], start_coordinates[1], color)
        expect(valid_moves).to match_array([[1, 5], [1, 4]])
      end
      it 'returns the correct moves from a non-starting square' do
        start_coordinates = [1, 4]
        color = 'white'
        valid_moves = new_game.get_pawn_moves(start_coordinates[0], start_coordinates[1], color)
        expect(valid_moves).to match_array([[1, 5]])
      end
    end
    context 'when there is an enemy piece diagonal to the pawn' do
      it 'returns the correct moves from a starting square' do
        board_array = new_game.instance_variable_get(:@board_array)
        board_array[1][2].piece = '♚'
        new_game.instance_variable_set(:@board_array, board_array)
        start_coordinates = [0, 1]
        color = 'white'
        valid_moves = new_game.get_pawn_moves(start_coordinates[0], start_coordinates[1], color)
        expect(valid_moves).to match_array([[0, 2], [0, 3], [1, 2]])
      end
      it 'returns the correct moves from a non-starting square' do
        board_array = new_game.instance_variable_get(:@board_array)
        board_array[6][4].piece = '♔'
        new_game.instance_variable_set(:@board_array, board_array)
        start_coordinates = [7, 5]
        color = 'black'
        valid_moves = new_game.get_pawn_moves(start_coordinates[0], start_coordinates[1], color)
        expect(valid_moves).to match_array([[7, 4], [6, 4]])
      end
    end
    context 'when there is an enemy piece in front' do
      it 'returns the correct moves' do
        board_array = new_game.instance_variable_get(:@board_array)
        board_array[1][2].piece = '♚'
        new_game.instance_variable_set(:@board_array, board_array)
        start_coordinates = [1, 1]
        color = 'white'
        valid_moves = new_game.get_pawn_moves(start_coordinates[0], start_coordinates[1], color)
        expect(valid_moves).to match_array([])
      end
    end
    context 'when there is a friendly piece in front' do
      it 'returns the correct moves' do
        board_array = new_game.instance_variable_get(:@board_array)
        board_array[4][2].piece = '♚'
        new_game.instance_variable_set(:@board_array, board_array)
        start_coordinates = [4, 3]
        color = 'black'
        valid_moves = new_game.get_pawn_moves(start_coordinates[0], start_coordinates[1], color)
        expect(valid_moves).to match_array([])
      end
    end
    context 'when en passant is possible' do
      xit 'returns the correct moves' do
      end
    end
  end

  describe '#get_king_moves' do
    context 'when there are no pieces in the way' do
      it 'returns the correct moves' do
        start_coordinates = [1, 7]
        color = 'black'
        valid_moves = new_game.get_king_moves(start_coordinates[0], start_coordinates[1], color)
        expect(valid_moves).to match_array([[2, 7], [1, 6], [0, 7], [0, 6], [2, 6]])
      end
    end
    context 'when there is an enemy piece to capture' do
      before do
        board_array = new_game.instance_variable_get(:@board_array)
        board_array[5][3].piece = '♔'
        new_game.instance_variable_set(:@board_array, board_array)
      end
      it 'returns the correct moves' do
        start_coordinates = [4, 4]
        color = 'black'
        valid_moves = new_game.get_king_moves(start_coordinates[0], start_coordinates[1], color)
        expect(valid_moves).to match_array([[3, 5], [4, 5], [5, 5], [5, 4], [5, 3], [4, 3], [3, 3], [3, 4]])
      end
    end
    context 'when there is a friendly piece in the way' do
      before do
        board_array = new_game.instance_variable_get(:@board_array)
        board_array[5][3].piece = '♜'
        new_game.instance_variable_set(:@board_array, board_array)
      end
      it 'returns the correct moves' do
        start_coordinates = [4, 4]
        color = 'black'
        valid_moves = new_game.get_king_moves(start_coordinates[0], start_coordinates[1], color)
        expect(valid_moves).to match_array([[3, 5], [4, 5], [5, 5], [5, 4], [4, 3], [3, 3], [3, 4]])
      end
    end
    context 'when castling is possible' do
      xit 'returns the correct moves' do
        # checks if rook is still in original square
      end
    end
  end

  describe '#get_queen_moves' do
    context 'when there are no pieces in the way' do
      it 'returns the correct moves' do
        start_coordinates = [0, 7]
        color = 'white'
        valid_moves = new_game.get_queen_moves(start_coordinates[0], start_coordinates[1], color)
        correct_moves = [[0, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [1, 6], [2, 5], [3, 4], [4, 3], [5, 2], [6, 1], [7, 0], [1, 7], [2, 7], [3, 7], [4, 7], [5, 7], [6, 7], [7, 7]]
        expect(valid_moves).to match_array(correct_moves)
      end
    end
    context 'when there is an enemy piece to capture' do
      before do
        board_array = new_game.instance_variable_get(:@board_array)
        board_array[2][4].piece = '♚'
        new_game.instance_variable_set(:@board_array, board_array)
      end
      it 'returns the correct moves' do
        start_coordinates = [4, 6]
        color = 'white'
        valid_moves = new_game.get_queen_moves(start_coordinates[0], start_coordinates[1], color)
        correct_moves = [[2, 4],  [3, 7], [4, 7], [5, 7], [0, 6], [1, 6], [2, 6], [3, 6], [5, 6], [6, 6], [7, 6], [3, 5], [4, 5], [4, 4], [4, 3], [4, 2], [4, 1], [4, 0], [5, 5], [6, 4], [7, 3]]
        expect(valid_moves).to match_array(correct_moves)
      end
    end
    context 'when there is a friendly piece in the way' do
      before do
        board_array = new_game.instance_variable_get(:@board_array)
        board_array[2][4].piece = '♔'
        new_game.instance_variable_set(:@board_array, board_array)
      end
      it 'returns the correct moves' do
        start_coordinates = [4, 6]
        color = 'white'
        valid_moves = new_game.get_queen_moves(start_coordinates[0], start_coordinates[1], color)
        correct_moves = [[3, 7], [4, 7], [5, 7], [0, 6], [1, 6], [2, 6], [3, 6], [5, 6], [6, 6], [7, 6], [3, 5], [4, 5], [4, 4], [4, 3], [4, 2], [4, 1], [4, 0], [5, 5], [6, 4], [7, 3]]
        expect(valid_moves).to match_array(correct_moves)
      end
    end
  end

  describe '#get_knight_moves' do
    context 'when there are no pieces in the way' do
      it 'returns the correct moves' do
        start_coordinates = [1, 5]
        color = 'black'
        valid_moves = new_game.get_knight_moves(start_coordinates[0], start_coordinates[1], color)
        correct_moves = [[0, 7], [2, 7], [3, 6], [3, 4], [2, 3], [0, 3]]
        expect(valid_moves).to match_array(correct_moves)
      end
    end
    context 'when there is an enemy piece to capture' do
      before do
        board_array = new_game.instance_variable_get(:@board_array)
        board_array[2][4].piece = '♔'
        new_game.instance_variable_set(:@board_array, board_array)
      end
      it 'returns the correct moves' do
        start_coordinates = [4, 5]
        color = 'black'
        valid_moves = new_game.get_knight_moves(start_coordinates[0], start_coordinates[1], color)
        correct_moves = [[3, 7], [5, 7], [6, 6], [6, 4], [5, 3], [3, 3], [2, 4], [2, 6]]
        expect(valid_moves).to match_array(correct_moves)
      end
    end
    context 'when there is a friendly piece in the way' do
      before do
        board_array = new_game.instance_variable_get(:@board_array)
        board_array[2][4].piece = '♚'
        new_game.instance_variable_set(:@board_array, board_array)
      end
      it 'returns the correct moves' do
        start_coordinates = [4, 5]
        color = 'black'
        valid_moves = new_game.get_knight_moves(start_coordinates[0], start_coordinates[1], color)
        correct_moves = [[3, 7], [5, 7], [6, 6], [6, 4], [5, 3], [3, 3], [2, 6]]
        expect(valid_moves).to match_array(correct_moves)
      end
    end
  end

  describe '#get_bishop_moves' do
    context 'when there are no pieces in the way' do
      it 'returns the correct moves' do
        start_coordinates = [0, 7]
        color = 'black'
        valid_moves = new_game.get_bishop_moves(start_coordinates[0], start_coordinates[1], color)
        correct_moves = [[1, 6], [2, 5], [3, 4], [4, 3], [5, 2], [6, 1], [7, 0]]
        expect(valid_moves).to match_array(correct_moves)
      end
    end
    context 'when there is an enemy piece to capture' do
      before do
        board_array = new_game.instance_variable_get(:@board_array)
        board_array[2][4].piece = '♔'
        new_game.instance_variable_set(:@board_array, board_array)
      end
      it 'returns the correct moves' do
        start_coordinates = [4, 6]
        color = 'black'
        valid_moves = new_game.get_bishop_moves(start_coordinates[0], start_coordinates[1], color)
        correct_moves = [[2, 4], [3, 7], [5, 7], [3, 5], [5, 5], [6, 4], [7, 3]]
        expect(valid_moves).to match_array(correct_moves)
      end
    end
    context 'when there is a friendly piece in the way' do
      before do
        board_array = new_game.instance_variable_get(:@board_array)
        board_array[2][4].piece = '♚'
        new_game.instance_variable_set(:@board_array, board_array)
      end
      it 'returns the correct moves' do
        start_coordinates = [4, 6]
        color = 'black'
        valid_moves = new_game.get_bishop_moves(start_coordinates[0], start_coordinates[1], color)
        correct_moves = [[3, 7], [5, 7], [3, 5], [5, 5], [6, 4], [7, 3]]
        expect(valid_moves).to match_array(correct_moves)
      end
    end
  end

  describe '#get_rook_moves' do
    context 'when there are no pieces in the way' do
      it 'returns the correct moves' do
        start_coordinates = [0, 7]
        color = 'white'
        valid_moves = new_game.get_rook_moves(start_coordinates[0], start_coordinates[1], color)
        correct_moves = [[0, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [1, 7], [2, 7], [3, 7], [4, 7], [5, 7], [6, 7], [7, 7]]
        expect(valid_moves).to match_array(correct_moves)
      end
    end
    context 'when there is an enemy piece to capture' do
      before do
        board_array = new_game.instance_variable_get(:@board_array)
        board_array[2][4].piece = '♔'
        new_game.instance_variable_set(:@board_array, board_array)
      end
      it 'returns the correct moves' do
        start_coordinates = [2, 3]
        color = 'black'
        valid_moves = new_game.get_rook_moves(start_coordinates[0], start_coordinates[1], color)
        correct_moves = [[2, 4], [0, 3], [1, 3], [3, 3], [4, 3], [5, 3], [6, 3], [7, 3], [2, 0], [2, 1], [2, 2]]
        expect(valid_moves).to match_array(correct_moves)
      end
    end
    context 'when there is a friendly piece blocking the way' do
      before do
        board_array = new_game.instance_variable_get(:@board_array)
        board_array[2][4].piece = '♔'
        new_game.instance_variable_set(:@board_array, board_array)
      end
      it 'returns the correct moves' do
        start_coordinates = [2, 3]
        color = 'white'
        valid_moves = new_game.get_rook_moves(start_coordinates[0], start_coordinates[1], color)
        correct_moves = [[0, 3], [1, 3], [3, 3], [4, 3], [5, 3], [6, 3], [7, 3], [2, 0], [2, 1], [2, 2]]
        expect(valid_moves).to match_array(correct_moves)
      end
    end
  end

  describe '#get_move_input' do
    context 'when given three invalid moves and one valid move' do
      before do
        board_array = new_game.instance_variable_get(:@board_array)
        board_array[2][4].piece = '♔'
        new_game.instance_variable_set(:@board_array, board_array)
        allow(new_game).to receive(:gets).and_return('9', '4', '4', '3', '5', '8', '8', '3', '5', '4', '5')
        allow(new_game).to receive(:empty_square?).and_return(true, false)
        allow(new_game).to receive(:valid_move?).and_return(false, true)
      end
      it 'asks to input a move four times' do
        expect(new_game).to receive(:print).with('Please enter valid coordinates >:(').once
        expect(new_game).to receive(:print).with("That square is empty! you can't move nothing").once
        expect(new_game).to receive(:print).with('Please enter a valid move!').once
        expect(new_game).to receive(:print_move_input).exactly(6).times
        expect(new_game).to receive(:print_coordinate_input).exactly(11).times
        result = new_game.get_move_input
        expect(result).to eq([[2, 4], [3, 4]])
      end
    end
  end

  describe '#game_loop' do
    context 'when four turns are done then the game ends through checkmate' do
      subject(:win_game) { described_class.new }
      let(:player_a) { instance_double(Player, name: 'Yves', color: 'white') }
      let(:player_b) { instance_double(Player, name: 'Chuu', color: 'black') }

      before do
        allow(win_game).to receive(:game_draw?).and_return(false)
        allow(win_game).to receive(:checkmate?).and_return(false,false, false, true)
        win_game.instance_variable_set(:@current_player, player_a)
        win_game.instance_variable_set(:@player_a, player_a)
        win_game.instance_variable_set(:@player_b, player_b)
        allow(win_game).to receive(:display_board)
        allow(win_game).to receive(:move_piece)
      end
      it 'loops four times only' do
        expect(win_game).to receive(:display_board).exactly(4).times
        expect(win_game).to receive(:move_piece).exactly(4).times
        win_game.game_loop
      end
      it 'has Player B as the winner' do
        win_game.game_loop
        current_player = win_game.instance_variable_get(:@current_player)
        expect(current_player.name).to eq('Chuu')
      end
    end
    context 'when three turns are done then the game ends in a draw' do
      subject(:win_game) { described_class.new }
      let(:player_a) { instance_double(Player, name: 'Yves', color: 'white') }
      let(:player_b) { instance_double(Player, name: 'Chuu', color: 'black') }

      before do
        allow(win_game).to receive(:game_draw?).and_return(false, false, false, true)
        allow(win_game).to receive(:checkmate?).and_return(false)
        win_game.instance_variable_set(:@current_player, player_a)
        win_game.instance_variable_set(:@player_a, player_a)
        win_game.instance_variable_set(:@player_b, player_b)
        allow(win_game).to receive(:display_board)
        allow(win_game).to receive(:move_piece)
      end
      it 'loops three times only' do
        expect(win_game).to receive(:display_board).exactly(3).times
        expect(win_game).to receive(:move_piece).exactly(3).times
        win_game.game_loop
      end
    end
  end

  describe '#check?' do
    subject(:check_game) { described_class.new }
    let(:player_a) { instance_double(Player, name: 'Yves', color: 'white') }
    let(:player_b) { instance_double(Player, name: 'Chuu', color: 'black') }

    context 'when the player is in check' do
      before do
        board_array = check_game.instance_variable_get(:@board_array)
        board_array[3][3].piece = '♙'
        board_array[1][2].piece = '♔'
        board_array[4][4].piece = '♚'
        check_game.instance_variable_set(:@board_array, board_array)
        check_game.instance_variable_set(:@current_player, player_b)
        check_game.instance_variable_set(:@player_a, player_a)
        check_game.instance_variable_set(:@player_b, player_b)
        # allow(check_game).to receive(:find_king).and_return([4, 4])
      end
      it 'returns true' do
        current_player = check_game.instance_variable_get(:@current_player)
        expect(check_game.check?(current_player)).to be true
      end
    end

    context 'when the player is not in check' do
      before do
        board_array = check_game.instance_variable_get(:@board_array)
        board_array[3][2].piece = '♙'
        board_array[6][1].piece = '♙'
        board_array[1][2].piece = '♔'
        board_array[1][3].piece = '♖'
        board_array[3][7].piece = '♗'
        board_array[7][1].piece = '♘'
        board_array[4][4].piece = '♚'
        check_game.instance_variable_set(:@board_array, board_array)
        check_game.instance_variable_set(:@current_player, player_b)
        check_game.instance_variable_set(:@player_a, player_a)
        check_game.instance_variable_set(:@player_b, player_b)
      end
      it 'returns false' do
        current_player = check_game.instance_variable_get(:@current_player)
        expect(check_game.check?(current_player)).to be false
      end
    end
  end

  describe '#checkmate?' do
    subject(:check_game) { described_class.new }
    let(:player_a) { instance_double(Player, name: 'Yves', color: 'white') }
    let(:player_b) { instance_double(Player, name: 'Chuu', color: 'black') }

    context 'when the current player has been checkmated' do
      before do
        board_array = check_game.instance_variable_get(:@board_array)
        board_array[5][0].piece = '♕'
        board_array[6][2].piece = '♔'
        board_array[7][0].piece = '♚'
        check_game.instance_variable_set(:@board_array, board_array)
        check_game.instance_variable_set(:@current_player, player_b)
        check_game.instance_variable_set(:@player_a, player_a)
        check_game.instance_variable_set(:@player_b, player_b)
        # allow(check_game).to receive(:all_moves_in_check?).and_return(true)
      end
      it 'returns true' do
        board_copy = check_game.instance_variable_get(:@board_array)
        current_player = check_game.instance_variable_get(:@current_player)
        expect(check_game.checkmate?(current_player)).to be true
        expect(check_game.instance_variable_get(:@board_array)).to eq(board_copy)
      end
    end
    context 'when the current player is only in check but not checkmated' do
      before do
        board_array = check_game.instance_variable_get(:@board_array)
        board_array[3][3].piece = '♙'
        board_array[2][3].piece = '♖'
        board_array[1][2].piece = '♔'
        board_array[4][4].piece = '♚'
        check_game.instance_variable_set(:@board_array, board_array)
        check_game.instance_variable_set(:@current_player, player_b)
        check_game.instance_variable_set(:@player_a, player_a)
        check_game.instance_variable_set(:@player_b, player_b)
      end
      it 'returns false' do
        current_player = check_game.instance_variable_get(:@current_player)
        expect(check_game.checkmate?(current_player)).to be false
      end
    end
    context 'when the current player is neither in check nor checkmated' do
      before do
        board_array = check_game.instance_variable_get(:@board_array)
        board_array[3][2].piece = '♙'
        board_array[1][2].piece = '♔'
        board_array[4][4].piece = '♚'
        check_game.instance_variable_set(:@board_array, board_array)
        check_game.instance_variable_set(:@current_player, player_b)
        check_game.instance_variable_set(:@player_a, player_a)
        check_game.instance_variable_set(:@player_b, player_b)
      end
      it 'returns false' do
        current_player = check_game.instance_variable_get(:@current_player)
        expect(check_game.checkmate?(current_player)).to be false
      end
    end
    context 'when the player is stalemated' do
      before do
        board_array = check_game.instance_variable_get(:@board_array)
        board_array[6][5].piece = '♕'
        board_array[0][0].piece = '♔'
        board_array[7][7].piece = '♚'
        check_game.instance_variable_set(:@board_array, board_array)
        check_game.instance_variable_set(:@current_player, player_b)
        check_game.instance_variable_set(:@player_a, player_a)
        check_game.instance_variable_set(:@player_b, player_b)
      end
      it 'returns false' do
        current_player = check_game.instance_variable_get(:@current_player)
        expect(check_game.checkmate?(current_player)).to be false
      end
    end
  end

  describe '#all_moves_in_check?' do
    subject(:check_game) { described_class.new }
    let(:player_a) { instance_double(Player, name: 'Yves', color: 'white') }
    let(:player_b) { instance_double(Player, name: 'Chuu', color: 'black') }

    context 'when all moves are in check' do
      before do
        board_array = check_game.instance_variable_get(:@board_array)
        board_array[5][0].piece = '♕'
        board_array[6][2].piece = '♔'
        board_array[7][0].piece = '♚'
        check_game.instance_variable_set(:@board_array, board_array)
        check_game.instance_variable_set(:@current_player, player_b)
        check_game.instance_variable_set(:@player_a, player_a)
        check_game.instance_variable_set(:@player_b, player_b)
      end
      it 'returns true' do
        current_player = check_game.instance_variable_get(:@current_player)
        start_coordinates = [7, 0]
        valid_moves = [[6, 0], [6, 1], [7, 1]]
        expect(check_game.all_moves_in_check?(start_coordinates, valid_moves, current_player)).to be true
      end
      it 'does not affect the actual board array' do
        board_array_copy = check_game.instance_variable_get(:@board_array)
        current_player = check_game.instance_variable_get(:@current_player)
        start_coordinates = [7, 0]
        valid_moves = [[6, 0], [6, 1], [7, 1]]
        check_game.all_moves_in_check?(start_coordinates, valid_moves, current_player)
        expect(check_game.instance_variable_get(:@board_array)).to eq(board_array_copy)
      end
    end
    context 'when not all moves are in check' do
      before do
        board_array = check_game.instance_variable_get(:@board_array)
        board_array[3][3].piece = '♙'
        board_array[1][2].piece = '♔'
        board_array[4][4].piece = '♚'
        check_game.instance_variable_set(:@board_array, board_array)
        check_game.instance_variable_set(:@current_player, player_b)
        check_game.instance_variable_set(:@player_a, player_a)
        check_game.instance_variable_set(:@player_b, player_b)
      end
      it 'returns false' do
        current_player = check_game.instance_variable_get(:@current_player)
        start_coordinates = [4, 4]
        valid_moves = [[3, 4], [3, 3], [4, 3], [5, 3], [5, 4], [5, 5], [4, 5], [3, 5]]
        expect(check_game.all_moves_in_check?(start_coordinates, valid_moves, current_player)).to be false
      end
      it 'does not affect the actual board array' do
        board_array_copy = check_game.instance_variable_get(:@board_array)
        current_player = check_game.instance_variable_get(:@current_player)
        start_coordinates = [4, 4]
        valid_moves = [[3, 4], [3, 3], [4, 3], [5, 3], [5, 4], [5, 5], [4, 5], [3, 5]]
        check_game.all_moves_in_check?(start_coordinates, valid_moves, current_player)
        expect(check_game.instance_variable_get(:@board_array)).to eq(board_array_copy)
      end
    end
  end

  describe '#game_draw?' do
    subject(:draw_game) { described_class.new }
    let(:player_a) { instance_double(Player, name: 'Yves', color: 'white') }
    let(:player_b) { instance_double(Player, name: 'Chuu', color: 'black') }

    context 'when player is stalemated' do
      before do
        board_array = draw_game.instance_variable_get(:@board_array)
        board_array[5][6].piece = '♕'
        board_array[0][0].piece = '♔'
        board_array[7][7].piece = '♚'
        draw_game.instance_variable_set(:@board_array, board_array)
        draw_game.instance_variable_set(:@current_player, player_b)
        draw_game.instance_variable_set(:@player_a, player_a)
        draw_game.instance_variable_set(:@player_b, player_b)
      end
      xit 'returns true' do
        expect(draw_game.game_draw?).to be true
      end
    end
  end

  describe '#find_king' do
    subject(:king_game) { described_class.new }
    let(:player_a) { instance_double(Player, name: 'Yves', color: 'white') }
    let(:player_b) { instance_double(Player, name: 'Chuu', color: 'black') }

    before do
      board_array = king_game.instance_variable_get(:@board_array)
      board_array[6][5].piece = '♕'
      board_array[0][0].piece = '♔'
      board_array[7][7].piece = '♚'
      king_game.instance_variable_set(:@board_array, board_array)
      king_game.instance_variable_set(:@current_player, player_b)
      king_game.instance_variable_set(:@player_a, player_a)
      king_game.instance_variable_set(:@player_b, player_b)
    end
    it 'returns the correct coordinates' do
      current_player = king_game.instance_variable_get(:@current_player)
      coordinates = [7, 7]
      expect(king_game.find_king(current_player)).to eq(coordinates)
    end
  end

  describe '#get_winner' do
    subject(:win_game) { described_class.new }
    let(:player_a) { instance_double(Player, name: 'Yves', color: 'white') }
    let(:player_b) { instance_double(Player, name: 'Chuu', color: 'black') }
    context 'when Player B has been checkmated' do
      before do
        win_game.instance_variable_set(:@current_player, player_b)
        win_game.instance_variable_set(:@player_a, player_a)
        win_game.instance_variable_set(:@player_b, player_b)
      end
      it 'returns Player A' do
        expect(win_game.get_winner).to eq(player_a)
      end
    end
    context 'when Player A has been checkmated' do
      before do
        win_game.instance_variable_set(:@current_player, player_a)
        win_game.instance_variable_set(:@player_a, player_a)
        win_game.instance_variable_set(:@player_b, player_b)
      end
      it 'returns Player B' do
        expect(win_game.get_winner).to eq(player_b)
      end
    end
  end
end
