# frozen_string_literal: true

# square nodes
class Square
  def initialize(coordinates, parent = nil)
    @coordinates = coordinates
    @x = coordinates[0]
    @y = coordinates[1]
    @children = []
    @parent = parent
    @piece = nil
  end

  attr_accessor :coordinates, :x, :y, :children, :parent, :piece
end
