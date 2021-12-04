require_relative "input.rb"

input = Input::DATA.split("\n").map(&:to_i)

class DayOne
  def initialize(input)
    @input = input
  end

  def part_one
    @input.each_with_index.reduce(0) do |increases, (depth, idx)|
      increases if idx == 0
    
      if depth > @input[idx - 1]
        increases += 1
      end
      increases
    end
  end

  def part_two
    rolling_sums.each_with_index.reduce(0) do |increases, (rolling_sum, idx)|
      increases if idx == 0
    
      if rolling_sum > rolling_sums[idx - 1]
        increases += 1
      end
      increases
    end
  end

  private

  def rolling_sums
    @input.slice(0, @input.length-2).each_with_index.reduce([]) do |sums, (depth, idx)|
      sums << (depth + @input[idx+1] + @input[idx+2])
      sums
    end
  end
end

solution = DayOne.new(input)
p solution.part_one
p solution.part_two
