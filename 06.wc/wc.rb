# frozen_string_literal: true

require 'optparse'

def main
  params = ARGV.getopts('l')
  taken_files = take_file
  summarized_values = sum_files(taken_files)
  taken_files.empty? ? enter_standard_input(params) : show_files(params, taken_files, summarized_values)
end

def enter_standard_input(params)
  standard_input = $stdin.read
  print standard_input.count("\n").to_s.rjust(8).to_s
  puts "#{standard_input.split(/\s+/).size.to_s.rjust(8)}#{standard_input.bytesize.to_s.rjust(7)}" unless params['l']
end

def take_file
  taken_files = []
  ARGV.each do |name|
    read_file = File.read(name)
    file_data = {
      line: read_file.count("\n"),
      word: read_file.split(/\s+/).size,
      byte: read_file.bytesize,
      filename: File.basename(name)
    }
    taken_files << file_data
  end
  taken_files
end

def sum_files(taken_files)
  {
    total_line: taken_files.sum { |lines| lines[:line] },
    total_word: taken_files.sum { |words| words[:word] },
    total_byte: taken_files.sum { |bytes| bytes[:byte] }
  }
end

def show_files(params, taken_files, summarized_values)
  params['l'] ? selected_l_option(taken_files, summarized_values) : output_file(taken_files, summarized_values)
end

def output_file(taken_files, summarized_values)
  taken_files.each do |file|
    puts "#{file[:line].to_s.rjust(8)} #{file[:word].to_s.rjust(7)} #{file[:byte].to_s.rjust(7)} #{file[:filename]}"
  end
  return unless taken_files.size != 1

  puts "#{summarized_values[:total_line].to_s.rjust(8)} #{summarized_values[:total_word].to_s.rjust(7)} #{summarized_values[:total_byte].to_s.rjust(7)} total"
end

def selected_l_option(taken_files, summarized_values)
  taken_files.each do |file|
    puts "#{file[:line].to_s.rjust(8)} #{file[:filename]}"
  end
  puts "#{summarized_values[:total_line].to_s.rjust(8)} total" unless taken_files.size == 1
end

main
