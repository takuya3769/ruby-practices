# frozen_string_literal: true

# !/usr/bin/envruby

require 'optparse'
require 'etc'

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

def main
  params = ARGV.getopts('arl')
  dirs = ls_command(params)
  output_files(params, dirs)
end

def ls_command(params)
  ls_option = params['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  params['r'] ? ls_option.reverse : ls_option
end

def output_files(params, dirs)
  params['l'] ? command_l(dirs) : show_directories(dirs)
end

def show_directories(dirs)
  maxium_file = dirs.length.to_f
  row = (maxium_file / MAX_CLUMN).ceil
  if (MAX_CLUMN % maxium_file) != 0
    ((MAX_CLUMN * row) - maxium_file).to_i.times do
      dirs.push(nil)
    end
  end
  file_list = dirs.each_slice(row).to_a
  longest_name = dirs.compact.max_by(&:size)
  padding = 15
  files_list = file_list.transpose
  files_list.each do |list|
    list.each do |l|
      print l.to_s.ljust(longest_name.size + padding)
    end
    print "\n"
  end
end

def total_file(dirs)
  total_file_blocks = dirs.map { |dir| File.stat(dir).blocks }
  puts "total #{total_file_blocks.sum}"
end

def command_l(dirs)
  dirs.each do |dir|
    fs = File::Stat.new(dir)
    link = fs.nlink.to_s
    user_id = fs.uid
    user_name = Etc.getpwuid(user_id).name
    group_id = fs.gid
    group_name = Etc.getgrgid(group_id).name
    byte = fs.size.to_s
    files = fs.mode.digits(8).take(3).reverse
    print (FILE_TYPE[fs.ftype]).to_s + ACCESS_PERMISSION[files[0]] + ACCESS_PERMISSION[files[1]] + ACCESS_PERMISSION[files[2]]
    puts "#{link.rjust(2)} #{user_name} #{group_name} #{byte.rjust(4)}  #{fs.mtime.strftime('%_m %e %H:%M')} #{dir}"
  end
end
main
