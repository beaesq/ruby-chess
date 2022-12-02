# frozen_string_literal: true

require_relative '../lib/main'

describe Player do
  subject(:new_player) { described_class.new('white', 'Yves') }
  # describe '#set_pieces' do
  #   it 'set the correct tokens' do
  #     new_player.set_pieces
  #     # colors = new_player.pieces.map.values_at(:color)
  #     # expect(colors).to all(eq('white'))
  #   end
  #   it 'set the correct coordinates' do
  #     new_player.set_pieces
  #     # colors = new_player.pieces.map.values_at(:color)
  #     # expect(colors).to all(eq('white'))
  #   end
  end
end