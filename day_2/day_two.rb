require_relative "input.rb"

input = Input::DATA

operations = input.split("\n")

class DayTwo
  def initialize(operations)
    @operations = operations
  end

  def part_one
    calculation_position(coordinates_part_one)
  end

  def part_two
    calculation_position(coordinates_part_two)
  end

  private

  def calculation_position(coords)
    coords[:horizontal] * coords[:depth]
  end

  def coordinates_part_one
    @operations.reduce({
      horizontal: 0,
      depth: 0
    }) do |position, operation|
      direction, moves = operation.split(" ")
    
      case direction
      when "up"
        position[:depth] -= moves.to_i
      when "down"
        position[:depth] += moves.to_i
      when "forward"
        position[:horizontal] += moves.to_i
      end
      position
    end
  end

  def coordinates_part_two
    @operations.reduce({
      aim: 0,
      horizontal: 0,
      depth: 0
    }) do |position, operation|
      direction, moves = operation.split(" ")
      moves = moves.to_i
    
      case direction
      when "up"
        position[:aim] -= moves
      when "down"
        position[:aim] += moves
      when "forward"
        position[:horizontal] += moves
        position[:depth] += position[:aim] * moves
      end
      position
    end
  end
end

solution = DayTwo.new(operations)
p solution.part_one
p solution.part_two

