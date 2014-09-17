# coding: utf-8
require 'yaml'

require_relative 'board'

class Game

  attr_reader :board, :cursor, :turn



  def initialize
    @board = Board.new
    @cursor = Cursor.new
    @turn = :white
    @picking = true
  end

  def picking?
    @picking
  end

  # def move
  #
  #   turn = turns.next
  #   board.move(self.get_move)
  #
  #
  # end

  def current_player
    self.turn
  end

  def next_turn
    @turn = @turn == :white ? :black : :white
  end

  def run
    loop do
      board.render(cursor.coordinates)
      handle_input(get_char)
    end
  end

  def handle_input(char)
    case char
    when 'w'
      cursor.up
    when 'a'
      cursor.left
    when 's'
      cursor.down
    when 'd'
      cursor.right
    when "\r"
      coords = self.click

      if picking? && board.piece_color_at(cursor.coordinates) == current_player
        board.touch_piece_at(coords)
        @picking = false
      elsif board.place_at(coords)
        @picking = true
        next_turn
      end
    when 'q'
      self.save
      exit
    when 'l'
      self.load
    end
  end

  def clear_screen
    system('clear')
  end

  def get_char
    begin
      system("stty raw -echo")
      str = STDIN.getc
    ensure
      system("stty -raw echo")
    end
  end

  # def get_player_move
  #   while []
  #     board.render
  #
  #     ret = handle_input(get_char)
  #     break if ret.is_a?(Array)
  #   end
  #
  #
  # end

  def click
    cursor.coordinates
  end

  def save
    File.write('.chess_save', self.to_yaml)
  end

  def load
    YAML.load(File.read('.chess_save')).run
  end


end

class Cursor
  SIZE = 8

  attr_reader :row, :col

  def initialize
    @row = 0
    @col = 0
  end

  def left
    @col = (col - 1) % SIZE
    nil
  end

  def right
    @col = (col + 1) % SIZE
    nil
  end

  def up
    @row = (row - 1) % SIZE
    nil
  end

  def down
    @row = (row + 1) % SIZE
    nil
  end

  def coordinates
    [row, col]
  end

end

if __FILE__ == $PROGRAM_NAME
  Game.new.run
end