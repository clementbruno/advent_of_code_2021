require_relative "input.rb"

input = Input::DATA

class DayEight
  UNIQUE_SEGMENTS_LENGTH = [2,3,4,7].freeze
  KNOWN_VALUES = {
    2 => 1,
    3 => 7,
    4 => 4,
    7 => 8
  }
  NUMBERS_MAPPING = ["abcefg", "cf", "acdeg", "acdfg", "bcdf", "abdfg", "abdefg", "acf", "abcdefg", "abcdfg"].freeze

  def initialize(input)
    @input = input
  end

  def part_one
    all_output_lines.flatten.select { |output| has_unique_number_of_segments?(output) }.length
  end

  def part_two
    all_output_lines.each_with_index.reduce(0) do |memo, (output_line, line_idx)|
      current_cipher_map = cipher_maps[line_idx]

      memo += output_line.map do |output_el|
        current_cipher_map[output_el]
      end.join("").to_i
      memo
    end
  end

  private

  def cipher_maps
    @cipher_maps ||= all_signal_lines.map { |signal_line| cipher_map(signal_line) }
  end

  def cipher_map(signal_line_arr)
    cipher_map = {}
    chars_1 = signal_line_arr.find { |signal| signal.length == 2 }
    cipher_map[chars_1] = "1"
    chars_7 = signal_line_arr.find { |signal| signal.length == 3 }
    cipher_map[chars_7] = "7"
    chars_4 = signal_line_arr.find { |signal| signal.length == 4 }
    cipher_map[chars_4] = "4"

    chars_8 = signal_line_arr.find { |signal| signal.length == 7 }
    cipher_map[chars_8] = "8"
    chars_6 = signal_line_arr.find { |signal| signal.length == 6 && (signal.split("") - chars_1.split("")).length == 5 }
    cipher_map[chars_6] = "6"
    chars_9 = signal_line_arr.find { |signal| signal.length == 6 && (signal.split("") - chars_4.split("")).length == 2 }
    cipher_map[chars_9] = "9"
    chars_0 = signal_line_arr.find { |signal| signal.length == 6 && signal != chars_6 && signal != chars_9 }
    cipher_map[chars_0] = "0"
    chars_3 = signal_line_arr.find { |signal| signal.length == 5 && (signal.split("") - chars_1.split("")).length == 3 }
    cipher_map[chars_3] = "3"
    chars_2 = signal_line_arr.find { |signal| signal.length == 5 && (signal.split("") - chars_9.split("")).length == 1 }
    cipher_map[chars_2] = "2"
    chars_5 = signal_line_arr.find { |signal| signal.length == 5 && signal != chars_2 && signal != chars_3 }
    cipher_map[chars_5] = "5"
    cipher_map
  end

  def all_signal_lines
    input_lines.map { |el| el[0].split(" ").map { |el| el.split("").sort.join("") }.sort }
  end

  def all_output_lines
    input_lines.map { |el| el[1].split(" ").map { |el| el.split("").sort.join("") } }
  end

  def input_lines
    @input.split("\n").map { |line| line.split(" | ") }
  end

  def has_unique_number_of_segments?(pattern)
    UNIQUE_SEGMENTS_LENGTH.include?(pattern.length)
  end
end

solution = DayEight.new(input)

p solution.part_one # 294
p solution.part_two # 973292


