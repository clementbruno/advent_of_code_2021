require_relative "input.rb"

input = Input::DATA.split(",").map(&:to_i)

class DaySeven
  def initialize(positions)
    @positions = positions
  end

  def part_one
    min_fuel_position(each_position_score_v1)
  end

  def part_two
    min_fuel_position(each_position_score_v2)
  end

  private

  def count_positions
    @count_positions ||= @positions.reduce({}) do |memo, position|
      memo[position] ? memo[position] += 1 : memo[position] = 1
      memo
    end
  end

  def each_position_score_v1
    (0..@positions.max).reduce({}) do |memo, position|
      count_positions.each do |sub_position, sub_count|
        distance = sub_count * (position - sub_position).abs
        memo[position] ? memo[position] += distance : memo[position] = distance
      end
      memo
    end
  end

  def each_position_score_v2
    (0..@positions.max).reduce({}) do |memo, position|
      count_positions.each do |sub_position, sub_count|
        distance_per_unit = (1..(position - sub_position).abs).sum
        distance = sub_count * distance_per_unit
        memo[position] ? memo[position] += distance : memo[position] = distance
      end
      memo
    end
  end

  def min_fuel_position(positions_scores)
    positions_scores.values.min
  end
end

solution = DaySeven.new(input)
p solution.part_one # 342730
p solution.part_two # 92335207
