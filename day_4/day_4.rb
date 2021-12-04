require_relative "input.rb"

numbers = Input::DATA.split("\n")[0]
boards = Input::DATA.split("\n\n")[1..].map { |line| line.split("\n") }

class DayThree
  attr_reader :drawn_numbers, :boards
  attr_accessor :winning_boards

  def initialize(input)
    @input = input
    @drawn_numbers = get_drawn_numbers
    @boards = get_boards
    @winning_boards = []
  end

  def part_one
    idx = 0
    last_drawn_number = nil
    while !@boards.any? { |board| board.winner? } && idx < @drawn_numbers.length - 1
      drawn_number = @drawn_numbers[idx]

      @boards.each do |board|
        board.set_drawn_values(drawn_number)
      end
      
      last_drawn_number = drawn_number
      idx += 1
    end

    winning_board = @boards.find { |board| board.winner? }
    winning_board.sum_non_drawn_numbers * last_drawn_number.to_i
  end

  def part_two
    idx = 0
    last_drawn_number = nil
    last_winning_drawn_number = nil

    while !@boards.all? { |board| board.winner? } #&& idx < @drawn_numbers.length - 1
      drawn_number = @drawn_numbers[idx]

      @boards.each_with_index do |board, idx|
        board.set_drawn_values(drawn_number)
        if board.winner? && !@winning_boards.include?(board)
          @winning_boards << board
          last_winning_drawn_number = drawn_number
        end
      end
      
      last_drawn_number = drawn_number
      idx += 1
    end

    last_winning_board = @winning_boards.last
    last_winning_board.sum_non_drawn_numbers * last_winning_drawn_number.to_i
  end

  private

  def get_drawn_numbers
    @input.split("\n")[0].split(",")
  end

  def get_boards
    @input.split("\n\n")[1..].map { |line| line.split("\n") }.map do |board_data|
      Board.new(board_data)
    end
  end
end

class Board
  attr_reader :board_state

  def initialize(board_data)
    @board_state = build_board(board_data)
  end
 
  def set_drawn_values(drawn_number)
    @board_state.each do |line|
      line.each do |board_num|
        if board_num.value == drawn_number
          board_num.draw
        end
      end
    end
  end

  def print
    @board_state.each do |line|
      line.each do |value|
        value.print_number_state
      end
    end
  end
  
  def winner?
    any_full_row? || any_full_column?
  end

  def sum_non_drawn_numbers
    non_drawn_numbers = []
    @board_state.each do |line|
      line.each do |board_num|
        if !board_num.drawn
          non_drawn_numbers << board_num
        end
      end
    end
    
    non_drawn_numbers.map { |board_num| board_num.value.to_i }.sum
  end

  class BoardNumber
    attr_reader :value, :drawn

    def initialize(value, column, row)
      @value = value
      @column = column
      @row = row
      @drawn = false
    end

    def draw
      @drawn = true
    end

    def print_number_state
      p "value is #{@value} on row #{@row} and in column #{@column} - Drawn: #{@drawn}"
    end
  end

  private

  def build_board(board_data)
    board_data.map.with_index do |line, row|
      line.split(" ").map.with_index do |number, column|
        BoardNumber.new(number, column, row)
      end
    end
  end

  def any_full_row?
    @board_state.any? { |line| line.all? { |number| number.drawn } }
  end

  def any_full_column?
    (0...@board_state[0].length).any? do |col_idx|
      @board_state.map { |line| line[col_idx] }.all? { |number| number.drawn }
    end
  end
end

solution = DayThree.new(Input::DATA)
p solution.part_one # 10374
p solution.part_two # 24742
