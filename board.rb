# coding: utf-8

require_relative 'pieces'

class Board

  attr_accessor :board
  attr_reader :cursor, :touched_piece, :touched_coordinates,
              :touched_piece_moves

  def initialize
    @board = self.new_board

    self.populate_board
    p @board
    # self.initialize_moves
    @touched_piece_moves = []
  end

  def render(cursor_coords)

    clear_screen

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
    puts rows.join("\n")
    #puts touched_piece
  end

  def format_char(char, pos, cursor_coords)
    if pos == cursor_coords
      char.bg_cyan
    elsif touched_piece && touched_piece_moves.include?(pos)  #fix this fug mess
      if self[pos] && !touched_piece.same_color_as?(self[pos])
        char.bg_red
      else
        char.bg_green
      end
    elsif pos.reduce(:+).odd?
      char.bg_gray
    else
      char
    end
  end

  def teammate_at?(piece, coordinates)
   # p coordinates
    self[coordinates] && self[coordinates].color == piece.color
  end

  def opponent_at?(piece, coordinates)
    self[coordinates] && self[coordinates].color != piece.color
  end

  def anyone_at?(coordinates)
    !self[coordinates].nil?
  end

  # def stepping_on_teammate?(from_coordinates, to_coordinates)
#     self[from_coordinates].same_color_as?(self[to_coordinates])
#   rescue NoMethodError
#     false
#   end
#
#   def stepping_on_opponent?(from_coordinates, to_coordinates)
#     !self[from_coordinates].same_color_as?(self[to_coordinates])
#   rescue NoMethodError
#     false
#   end
#
#   def valid_moves(piece)
#     piece.moves[:lines].map do |line|
#       stop = false
#       p line
#       line.take_while do |coords|
#         break if stop
#
#         p coords
#         other_piece = self[coords]
#
#         return true unless other_piece
#
#         if piece.same_color_as?(self[coords]) #stepping_on_teammate?
#           false
#         else
#           stop = true
#           true
#         end
#
#       end
#     end
#   end

  def touch_piece_at(coordinates)
    piece = self[coordinates]

    @touched_piece = piece
    @touched_coordinates = coordinates
    @touched_piece_moves = piece.moves(coordinates)
  end

  def place_at(coordinates)
    if touched_piece_moves.include?(coordinates)
      self[coordinates] = touched_piece
      self[touched_coordinates] = nil
      # touched_piece.calculate_moves(coordinates)
      touched_piece.first_move = false
      @touched_piece_moves = []
      @touched_piece = nil
      true
    else
      false
    end
  end

  def [](coords)
    row, col = coords
    self.board[row][col]
  end

  def []=(coords, piece)
    row, col = coords
    board[row][col] = piece
  end

  # def initialize_moves
  #   8.times do |x|
  #     8.times do |y|
  #       pos = [x, y]
  #       piece = self[[x, y]]
  #       piece.calculate_moves([x, y]) if piece
  #     end
  #   end
  # end

  def piece_color_at(coordinates)
    piece = self[coordinates]

    return nil unless piece

    piece.color
  end

  def inspect
    "A board."
  end

  def each_piece(&prc)
    self.board.flatten.compact.each(&prc)
  end                 #DELETE ME??

  def new_board
    Array.new(8) { Array.new(8) }
  end

  def populate_board
    self.board[0] = populate_royal_court(:black)
    self.board[1] = populate_pawns(:black)
    self.board[6] = populate_pawns(:white)
    self.board[7] = populate_royal_court(:white)
  end

  def populate_royal_court(color)
    [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook].map do |piece|
      piece.new(color, self)
    end
  end

  def populate_pawns(color)
    pawns = []
    8.times do
      pawns << Pawn.new(color, self)
    end
    pawns
  end

  def symbol_of(coords)
    row, col = coords
    row = 8 - row
    col = ('a'.ord + col).chr
    (col + row.to_s).to_sym
  end                 #DELETE ME???

  def coordinates_of(symbol)
    char, number = symbol.to_s.split('')

    number = 8 - Integer(number)
    char = char.ord - 'a'.ord

    [number, char]
  end            #DELETE ME TOO???

  def clear_screen
    system('clear')
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