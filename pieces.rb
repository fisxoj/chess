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

  attr_reader :display_character, :deltas,
              :color, :board
  attr_accessor :first_move

  def initialize(color, board)
    @board = board
    @color = color
    @display_character = self.character(color)
    @first_move = true
  end

  def to_s
    @display_character
  end

  def inspect
    @display_character
  end

  def character(color)
    PIECE_CHARACTERS[color][self.class.to_s.downcase.to_sym]
  end

  def moves(position)
    self.get_lines(position)
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

        lines << pos
        # break if it was their guy
        break if board.opponent_at?(self, pos)
      end

      # lines << one_line

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

      lines << pos if on_board?(pos) && !board.teammate_at?(self, pos)
    end

    lines
  end
end

class Pawn < Piece
  def get_lines(position)
    row, col = position
    dir = (self.color == :white ? -1 : 1)
    moves = []

    # Disallow forward captures
    single_hop = [row + dir, col]
    moves << single_hop unless board.anyone_at(single_hop)

    # Allow diagonal captures
    capture1 = [row + dir, col + dir]
    p board.opponent_at?(self, capture1)
    moves << capture1 if board.opponent_at?(self, capture1)

    capture2 = [row + dir, col - dir]
    moves << capture2 if board.opponent_at?(self, capture2)

    # Allow moving twice if it's the first move
    double_hop = [row + 2 * dir, col]
    moves << double_hop if !board.anyone_at?(double_hop) && self.first_move
    @moves = moves
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