#!/usr/bin/env ruby

require "optparse"
require "date"
opt = OptionParser.new

params = ARGV.getopts("", "y:#{Date.today.year}", "m:#{Date.today.month}")

year = params.values[0].to_i
month = params.values[1].to_i
week = ["日", "月", "火", "水", "木", "金", "土"]


set_day = Date.new(year, month, 1).wday
last_day = Date.new(year, month, -1).day


calendar = "#{month}月 #{year}"
puts calendar.center(20)
puts week.join(" ")
print "   " * set_day


(1..last_day).each do |date|
  print date.to_s.rjust(2) + " "
  set_day = set_day + 1
  if set_day % 7 == 0
    puts " "
  end
end
