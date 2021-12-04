require "./input.rb"

input = Input::DATA.split("\n")

class DayThree
  def initialize(input)
    @input = input
  end

  def part_one
    rates = (0...@input[0].length).reduce({
      gamma: "",
      epsilon: ""
    }) do |memo, idx|
      bits = @input.map { |binary_num| binary_num[idx].to_i }
      memo[:gamma] += most_frequent(bits)
      memo[:epsilon] += least_frequent(bits)

      memo
    end

    rates[:gamma].to_i(2) * rates[:epsilon].to_i(2)
  end

  def part_two
    get_oxygen * get_co2
  end

  private
  
  def get_oxygen
    remaining = @input
    idx = 0
    while remaining.length > 1
      remaining = most_frequents(remaining, idx)
      idx += 1
    end
    remaining.first.to_i(2)
  end
  
  def get_co2
    remaining = @input
    idx = 0
    while remaining.length > 1
      remaining = least_frequents(remaining, idx)
      idx += 1
    end
    remaining.first.to_i(2)
  end

  def most_frequents(list, idx)
    first_bits = list.map { |el| el[idx].to_i }

    list.select { |bin_num| bin_num[idx] == most_frequent(first_bits) }
  end

  def least_frequents(list, idx)
    list - most_frequents(list, idx)
  end

  def most_frequent(bits)
    bits.sum >= bits.length.to_f / 2 ? "1" : "0"
  end

  def least_frequent(bits)
    most_frequent(bits) == "1" ? "0" : "1"
  end
end

solution = DayThree.new(input)
p solution.part_one #3958484
p solution.part_two #1613181
