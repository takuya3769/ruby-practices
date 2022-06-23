# frozen_string_literal: true

require 'optparse'

def main
  params = ARGV.getopts('l')
  files_data = take_files
  total_files = sum_files(files_data)
  files_data.empty? ? basic_input(params) : type_l_command(params, files_data, total_files)
end

def basic_input(params)
  standard_input = $stdin.read
  print standard_input.count("\n").to_s.rjust(8).to_s
  puts "#{standard_input.split(/\s+/).size.to_s.rjust(8)}#{standard_input.bytesize.to_s.rjust(7)}" unless params['l']
  print "\n"
end

def take_files
  files_data = []
  ARGV.each do |information|
    read_file = File.read(information)
    file_data = {
      line: read_file.count("\n"),
      word: read_file.split(/\s+/).size,
      byte: read_file.bytesize,
      filename: File.basename(information)
    }
    files_data << file_data
  end
  files_data
end

def sum_files(files_data)
  {
    total_line: files_data.sum { |lines| lines[:line] },
    total_word: files_data.sum { |words| words[:word] },
    total_byte: files_data.sum { |bytes| bytes[:byte] }
  }
end

def type_l_command(params, files_data, total_files)
  params['l'] ? show_lines(files_data, total_files) : show_files(files_data, total_files)
end

def show_files(files_data, total_files)
  files_data.each do |file|
    puts "#{file[:line].to_s.rjust(8)} #{file[:word].to_s.rjust(7)} #{file[:byte].to_s.rjust(7)} #{file[:filename]}"
  end
  return unless files_data.size != 1

  puts "#{total_files[:total_line].to_s.rjust(8)} #{total_files[:total_word].to_s.rjust(7)} #{total_files[:total_byte].to_s.rjust(7)} total"
end

def show_lines(files_data, total_files)
  files_data.each do |file|
    puts "#{file[:line].to_s.rjust(8)} #{file[:filename]}"
  end
  puts "#{total_files[:total_line].to_s.rjust(8)} total" unless files_data.size == 1
end

main
