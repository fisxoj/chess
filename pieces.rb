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

  attr_reader :display_character, :deltas, :moves, :color, :board

  def initialize(color, board)
    @board = board
    @color = color
    @display_character = self.character(color)
  end

  def to_s
    @display_character
  end

  def character(color)
    PIECE_CHARACTERS[color][self.class.to_s.downcase.to_sym]
  end

  def calculate_moves(position)
    @moves = { :lines => self.get_lines(position),
               :captures => self.get_captures(position) }
  end

  def get_captures(position)
    []
  end

  def on_board?(pos)
    pos.all? { |num| num.between?(0, 7) }
  end

  def owned_by?(test_color)
    self.color == test_color
  end

  def same_color_as?(other_piece)
    return false unless other_piece
    self.color == other_piece.color
  end
end

class SlidingPiece < Piece
  def get_lines(position)
    x, y = position

    lines = []
    self.deltas.each do |dx, dy|
      one_line = []

      7.times do |i|
        pos = [x + (i + 1) * dx, y + (i + 1) * dy]

        break if !on_board?(pos) || board.teammate_at?(self, pos)

        one_line << pos
        # break if it was their guy
        break if board.opponent_at?(self, pos)
      end

      lines << one_line

    end

    lines
  end
end

class SteppingPiece < Piece
  def get_lines(position)
    x, y = position
    lines = []

    deltas.each do |dx, dy|
      pos = [x + dx, y + dy]

      lines << [pos] if on_board?(pos) && !board.teammate_at?(self, pos)
    end

    lines
  end
end

class Pawn < Piece
  def get_lines(position)
    []
  end
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

class Queen < SlidingPiece
  def deltas
    [[1, 1], [-1, -1], [1, -1], [-1, 1],
     [1, 0], [0, 1], [-1, 0], [0, -1]]
  end
end

class Knight < SteppingPiece
  def deltas
    [[1, 2], [1, -2], [-1, 2], [-1, -2],
     [2, 1], [2, -1], [-2, 1], [-2, -1]]
  end
end