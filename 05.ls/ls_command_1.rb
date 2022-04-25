# frozen_string_literal: true

# !/usr/bin/envruby

directory = Dir.glob('*')

MAX_CLUMN = 3
MAXIMUM_FILE = directory.length.to_f
row = (MAXIMUM_FILE / MAX_CLUMN).ceil
if (MAX_CLUMN * row - MAXIMUM_FILE) == 1
  directory.push(nil)
elsif (MAX_CLUMN * row - MAXIMUM_FILE) == 2
  directory.push(nil)
  directory.push(nil)
end

file_list = directory.each_slice(row).to_a
files = file_list.transpose

files.each do |list|
  list.each do |file|
    print file.to_s.ljust(24)
  end
  print "\n"
end
