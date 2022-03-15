require 'set'
require_relative "input.rb"

input = Input::DATA

# Example input
# input = <<~DATA
# 2199943210
# 3987894921
# 9856789892
# 8767896789
# 9899965678
# DATA

class DayEight
  attr_reader :input

  def initialize(input)
    @input = input.split("\n").map { |line| line.split("").map(&:to_i) }
  end

  def part_one
    low_points.map { |v| v + 1 }.sum
  end

  def part_two
    multiplier = 1
    selected_basins = basins.sort_by { |basin| basin.length }.last(3)

    selected_basins.map(&:length).each do |basin_length|
      multiplier *= basin_length
    end
    multiplier
  end

  private

  def low_points
    output = []
    @input.each_with_index do |line, line_idx|
      line.each_with_index do |value, col_idx|
        if lowest_point?(value, line_idx, col_idx)
          output << value
        end
      end
    end
    output
  end

  def lowest_points_coordinates
    output = []
    @input.each_with_index do |line, line_idx|
      line.each_with_index do |value, col_idx|
        if lowest_point?(value, line_idx, col_idx)
          output << [line_idx, col_idx]
        end
      end
    end
    output
  end

  def lowest_point?(value, line_idx, col_idx)
    left_check = col_idx > 0 ? @input[line_idx][col_idx - 1] >= value : true
    right_check = col_idx < @input[line_idx].length - 1 ? @input[line_idx][col_idx + 1] >= value : true
    up_check = line_idx > 0 ? @input[line_idx - 1][col_idx] >= value : true
    bottom_check = line_idx < @input.length - 1 ? @input[line_idx + 1][col_idx] >= value : true
    [
      left_check,
      right_check,
      up_check,
      bottom_check
    ].all?
  end

  def lowest_neighbor?(value, line_idx, col_idx, basin)
    return false if value == 9

    left_check = col_idx > 0 && !basin.include?([line_idx, col_idx - 1]) ? @input[line_idx][col_idx - 1] >= value : true
    right_check = col_idx < @input[line_idx].length - 1 && !basin.include?([line_idx, col_idx + 1]) ? @input[line_idx][col_idx + 1] >= value : true
    up_check = line_idx > 0 && !basin.include?([line_idx - 1, col_idx]) ? @input[line_idx - 1][col_idx] >= value : true
    bottom_check = line_idx < @input.length - 1 && !basin.include?([line_idx + 1, col_idx]) ? @input[line_idx + 1][col_idx] >= value : true
    [
      left_check,
      right_check,
      up_check,
      bottom_check
    ].all?
  end

  def basins
    output = []
    lowest_points_coordinates.each do |coords|
      basin = Set.new
      basin.add(coords)
      neighbours = get_neighbours(coords)

      while neighbours.any?
        neighbours = neighbours.select do |neighbour|
          lowest_neighbor?(@input[neighbour[0]][neighbour[1]], neighbour[0], neighbour[1], basin)
        end

        neighbours.each do |neighbour|
          basin.add(neighbour)
        end

        neighbours = neighbours.map { |neighbour| get_neighbours(neighbour) }.flatten(1).reject { |neighbour| basin.include?(neighbour) }
      end

      output << basin
    end
    output
  end

  def get_neighbours(coords)
    output = []
    if coords[0] > 0
      output << [coords[0] - 1, coords[1]]
    end
    if coords[0] < @input.length - 1
      output << [coords[0] + 1, coords[1]]
    end
    if coords[1] > 0
      output << [coords[0], coords[1] - 1]
    end
    if coords[1] < @input[0].length - 1
      output << [coords[0], coords[1] + 1]
    end
    output
  end
end

day_8 = DayEight.new(input)
p day_8.part_one
p day_8.part_two
