# frozen_string_literal: true

require 'optparse'

def main
  params = ARGV.getopts('l')
  collect_files = take_file
  total_files = sum_files(collect_files)
  collect_files.empty? ? enter_standard_input(params) : enter_l_option(params, collect_files, total_files)
end

def enter_standard_input(params)
  standard_input = $stdin.read
  print standard_input.count("\n").to_s.rjust(8).to_s
  puts "#{standard_input.split(/\s+/).size.to_s.rjust(8)}#{standard_input.bytesize.to_s.rjust(7)}" unless params['l']
end

def take_file
  collect_files = []
  ARGV.each do |name|
    read_file = File.read(name)
    file_data = {
      line: read_file.count("\n"),
      word: read_file.split(/\s+/).size,
      byte: read_file.bytesize,
      filename: File.basename(name)
    }
    collect_files << file_data
  end
  collect_files
end

def sum_files(collect_files)
  {
    total_line: collect_files.sum { |lines| lines[:line] },
    total_word: collect_files.sum { |words| words[:word] },
    total_byte: collect_files.sum { |bytes| bytes[:byte] }
  }
end

def enter_l_option(params, collect_files, total_files)
  params['l'] ? show_lines(collect_files, total_files) : show_files(collect_files, total_files)
end

def show_files(collect_files, total_files)
  collect_files.each do |file|
    puts "#{file[:line].to_s.rjust(8)} #{file[:word].to_s.rjust(7)} #{file[:byte].to_s.rjust(7)} #{file[:filename]}"
  end
  return unless collect_files.size != 1

  puts "#{total_files[:total_line].to_s.rjust(8)} #{total_files[:total_word].to_s.rjust(7)} #{total_files[:total_byte].to_s.rjust(7)} total"
end

def show_lines(collect_files, total_files)
  collect_files.each do |file|
    puts "#{file[:line].to_s.rjust(8)} #{file[:filename]}"
  end
  puts "#{total_files[:total_line].to_s.rjust(8)} total" unless collect_files.size == 1
end

main
