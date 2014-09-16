# coding: utf-8

require_relative 'pieces'

class Board

  attr_accessor :board
  attr_reader :cursor

  def self.new_board
    Array.new(8) { Array.new(8) }
  end

  def populate_board
    self.board[0] = populate_royal_court(:black)
    self.board[1] = populate_pawns(:black)
    self.board[6] = populate_pawns(:white)
    self.board[7] = populate_royal_court(:white)
  end

  def initialize
    @board = Board.new_board
    self.populate_board
  end

  def populate_royal_court(color)
    [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook].map do |piece|
      piece.new(color)
    end
  end

  def populate_pawns(color)
    pawns = []
    8.times do
      pawns << Pawn.new(color)
    end
    pawns
  end

  def render(cursor_coords)

    rows = []
    8.times do |row|

      cols = []
      8.times do |col|
        raw_char = (self[[row, col]] || ' ').to_s

        formatted_char = format_char(raw_char, [row, col], cursor_coords)

        cols << formatted_char
      end

      rows << cols.join('')
    end
    rows.join("\n")
  end

  def format_char(char, pos, cursor_coords)
    if pos == cursor_coords
      char.bg_cyan
    elsif pos.reduce(:+).odd?
      char.bg_gray
    else
      char
    end
  end

  def [](coords)
    row, col = coords
    board[row][col]
  end

  def coordinates_of(symbol)
    char, number = symbol.to_s.split('')

    number = 8 - Integer(number)
    char = char.ord - 'a'.ord

    [number, char]
  end

  def symbol_of(coords)
    row, col = coords
    row = 8 - row
    col = ('a'.ord + col).chr
    (col + row.to_s).to_sym
  end

end

class String
  def black;          "\033[30m#{self}\033[0m" end
  def red;            "\033[31m#{self}\033[0m" end
  def green;          "\033[32m#{self}\033[0m" end
  def brown;          "\033[33m#{self}\033[0m" end
  def blue;           "\033[34m#{self}\033[0m" end
  def magenta;        "\033[35m#{self}\033[0m" end
  def cyan;           "\033[36m#{self}\033[0m" end
  def gray;           "\033[37m#{self}\033[0m" end
  def bg_black;       "\033[40m#{self}\033[0m" end
  def bg_red;         "\033[41m#{self}\033[0m" end
  def bg_green;       "\033[42m#{self}\033[0m" end
  def bg_brown;       "\033[43m#{self}\033[0m" end
  def bg_blue;        "\033[44m#{self}\033[0m" end
  def bg_magenta;     "\033[45m#{self}\033[0m" end
  def bg_cyan;        "\033[46m#{self}\033[0m" end
  def bg_gray;        "\033[47m#{self}\033[0m" end
  def bold;           "\033[1m#{self}\033[22m" end
  def reverse_color;  "\033[7m#{self}\033[27m" end
end