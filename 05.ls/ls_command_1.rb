# frozen_string_literal: true

# !/usr/bin/envruby
MAX_CLUMN = 3
require 'optparse'
params = ARGV.getopts('a')
directory = params['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')

MAXIMUM_FILE = directory.length.to_f
row = (MAXIMUM_FILE / MAX_CLUMN).ceil
if (MAX_CLUMN % MAXIMUM_FILE) != 0
  (MAX_CLUMN * row - MAXIMUM_FILE).to_i.times do
    directory.push(nil)
  end
end

def show_directories(directory, row)
  file_list = directory.each_slice(row).to_a
  longest_name = directory.compact.max_by(&:size)
  padding = 15
  files = file_list.transpose
  files.each do |list|
    list.each do |file|
      print file.to_s.ljust(longest_name.size + padding)
    end
    print "\n"
  end
end
show_directories(directory, row)
