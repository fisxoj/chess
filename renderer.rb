# coding: utf-8

require_relative 'string_colors'

module Renderer

  GREEN_DOT = '•'.green

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
  end

  def format_char(char, pos, cursor_coords)
    if pos == cursor_coords
      char.bg_cyan
    elsif touched_piece && touched_piece_moves.include?(pos)  #fix this fug mess
      if self[pos] && !touched_piece.same_color_as?(self[pos])
        char.bg_red
      elsif pos.reduce(:+).odd?
        GREEN_DOT.bg_gray
      else
        GREEN_DOT
      end
    elsif pos.reduce(:+).odd?
      char.bg_gray
    else
      char
    end
  end

end