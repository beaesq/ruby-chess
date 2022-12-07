# frozen_string_literal: true

require_relative '../lib/main'

describe Game do
  subject (:new_game) { described_class.new }

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

  describe '#get_pawn_moves' do
    context 'when there is no enemy piece diagonal to the pawn' do
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
        board_array[1][2].piece = '♔'
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
    context 'when en passant is possible' do
      xit 'returns the correct moves' do
      end
    end
  end

  describe '#get_king_moves' do
    it 'returns the correct moves' do
      start_coordinates = [1, 7]
      color = 'black'
      valid_moves = new_game.get_king_moves(start_coordinates[0], start_coordinates[1], color)
      expect(valid_moves).to match_array([[2, 7], [1, 6], [0, 7]])
    end
    context 'when castling is possible' do
      xit 'returns the correct moves' do
        # checks if rook is still in original square
      end
    end
    context 'when there is an enemy piece to capture' do
      
    end
    context 'when there is a friendly piece in the way' do
      
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
        start_coordinates = [0, 7]
        color = 'white'
        valid_moves = new_game.get_queen_moves(start_coordinates[0], start_coordinates[1], color)
        correct_moves = []
        expect(valid_moves).to match_array(correct_moves)
        # start here! finish converting the other pieces
      end
    end
    context 'when there is a friendly piece in the way' do
      
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
end
