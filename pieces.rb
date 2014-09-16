# coding: utf-8

class Piece

  PIECE_CHARACTERS = {
    :white => {
      :pawn => '♙',
      :king => '♔',
      :queen => '♕',
      :rook => '♖',
      :bishop => '♗',
      :knight => '♘'},
    :black => {
      :pawn => '♟',
      :king => '♚',
      :queen => '♛',
      :rook => '♜',
      :bishop => '♝',
      :knight => '♞'}
      }

  attr_reader :display_character

  def initialize(color)
    @color = color
    @display_character = self.character(color)
  end

  def to_s
    @display_character
  end

  def character(color)
    PIECE_CHARACTERS[color][self.class.to_s.downcase.to_sym]
  end

  attr_reader :deltas

  def moves(position)
    [self.get_lines(position), self.get_captures(position)]
  end

  def get_captures(position)
    []
  end

  def valid_position?(pos)
    pos.all? { |num| num.between?(0, 7) }
  end
end

class SlidingPiece < Piece
  def get_lines(position)
    x, y = position

    lines = []
    puts self.deltas
    self.deltas.each do |dx, dy|
      one_line = []

      7.times do |i|
        pos = [x + (i + 1) * dx, y + (i + 1) * dy]

        break unless valid_position?(pos)

        one_line << pos
      end

      lines << one_line
    end

    lines
  end
end

class SteppingPiece < Piece
  def get_lines(position)
    x, y = position

    deltas.map do |dx, dy|
      [x + dx, y + dy]
    end
  end
end

class Pawn < Piece
  #UGH
end

class Rook < SlidingPiece
  def deltas
    [[1, 0], [0, 1], [-1, 0], [0, -1]]
  end
end

class Bishop < SlidingPiece
  def deltas
    [[1, 1], [-1, -1], [1, -1], [-1, 1]]
  end
end

class King < SteppingPiece
  def deltas
    [[1, 1], [-1, -1], [1, -1], [-1, 1],
     [1, 0], [0, 1], [-1, 0], [0, -1]]
  end
end

class Queen < SteppingPiece
  def deltas
    [[1, 1], [-1, -1], [1, -1], [-1, 1],
     [1, 0], [0, 1], [-1, 0], [0, -1]]
  end
end

class Knight < Piece
  def deltas
    [[1, 2], [1, -2], [-1, 2], [-1, -2],
     [2, 1], [2, -1], [-2, 1], [-2, -1]]
  end
end