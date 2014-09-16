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

  def to_s
    @display_character
  end

  def character(color)
    puts self.class.to_s.downcase.to_sym
    PIECE_CHARACTERS[color][self.class.to_s.downcase.to_sym]
  end

  def initialize(color)
    @color = color
    @display_character = self.character(color)
  end

  attr_reader :display_character
end

class Pawn < Piece

end

class Rook < Piece

end

class Bishop < Piece

end

class King < Piece
end

class Queen < Piece

end

class Knight < Piece
end