# frozen_string_literal: true

# !/usr/bin/envruby

MAX_CLUMN = 3
FILE_TYPE = { 'fifo' => 'p',
              'characterSpecial' => 'c',
              'directory' => 'd',
              'blockSpecial' => 'b',
              'file' => '-',
              'link' => 'l',
              'socket' => 's' }.freeze

ACCESS_PERMISSION = { 0 => '---',
                      1 => '--x',
                      2 => '-w-',
                      3 => '-wx',
                      4 => 'r--',
                      5 => 'r-x',
                      6 => 'rw-',
                      7 => 'rwx' }.freeze

require 'optparse'
require 'etc'

params = ARGV.getopts('l')
dirs = Dir.glob('*')

if params['l']
  total_file = []
  dirs.each do |dir|
    fs = File.stat(dir)
    total_file << fs.blocks
  end
  puts "total #{total_file.sum}"

  dirs.each do |dir|
    fs = File::Stat.new(dir)
    total_file << fs.blocks
    link = fs.nlink.to_s
    user_id = fs.uid
    user_name = Etc.getpwuid(user_id).name
    group_id = fs.gid
    group_name = Etc.getgrgid(group_id).name
    byte = fs.size.to_s
    files = fs.mode.digits(8).take(3).reverse
    print (FILE_TYPE[fs.ftype]).to_s +
          ACCESS_PERMISSION[files[0]] +
          ACCESS_PERMISSION[files[1]] +
          ACCESS_PERMISSION[files[2]]
    puts "#{link.rjust(2)} #{user_name} #{group_name} #{byte.rjust(4)}  #{fs.mtime.strftime('%_m %e %H:%M')} #{dir}"
  end
else
  MAXIMUM_FILE = dirs.length.to_f
  row = (MAXIMUM_FILE / MAX_CLUMN).ceil
  if (MAX_CLUMN % MAXIMUM_FILE) != 0
    ((MAX_CLUMN * row) - MAXIMUM_FILE).to_i.times do
      dirs.push(nil)
    end
  end

  def show_directories(dirs, row)
    file_list = dirs.each_slice(row).to_a
    longest_name = dirs.compact.max_by(&:size)
    padding = 15
    files = file_list.transpose
    files.each do |list|
      list.each do |file|
        print file.to_s.ljust(longest_name.length + padding)
      end
      print "\n"
    end
  end
  show_directories(dirs, row)
end
