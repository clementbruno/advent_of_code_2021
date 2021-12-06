require_relative "input.rb"

input = Input::DATA.split(",")

class DaySix
  INITIAL_DAYS_HASH = {
    0 => 0,
    1 => 0,
    2 => 0,
    3 => 0,
    4 => 0,
    5 => 0,
    6 => 0,
    7 => 0,
    8 => 0
  }

  def initialize(input)
    @lantern_fishes = build_lanter_fishes_count(input.map(&:to_i))
  end

  def part_one
    80.times do
      spend_day
    end

    @lantern_fishes.values.sum
  end

  def part_two
    # To be launched after part one: 256 - 80 = 176
    176.times do
      spend_day
    end

    @lantern_fishes.values.sum
  end

  private

  def spend_day
    @lantern_fishes = (0..8).reduce(INITIAL_DAYS_HASH.clone) do |memo, k|
      if k == 0
        memo[8] += @lantern_fishes[0]
        memo[6] += @lantern_fishes[0]
      else
        memo[k - 1] += @lantern_fishes[k]
      end
      memo
    end
  end

  def build_lanter_fishes_count(data)
    data.reduce(INITIAL_DAYS_HASH.clone) do |memo, num|
      memo[num] += 1
      memo
    end
  end
end

solution = DaySix.new(input)
p solution.part_one # 375482
p solution.part_two # 1689540415957
