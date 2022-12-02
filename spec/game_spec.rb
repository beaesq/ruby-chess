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
end