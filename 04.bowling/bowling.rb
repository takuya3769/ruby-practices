# frozen_string_literal: true

LASTFRAME = 18
score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if shots.length >= LASTFRAME && s == 'X'
    shots << 10
  elsif s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = []
shots.each_slice(2) do |shot|
  if frames.length == 10
    frames[9] << shot[-1]
  else
    frames << shot
  end
end

point = frames.each_with_index.sum do |frame, i|
    next_frame = frames[i + 1]
    after_next_frame = frames[i + 2]
    strike = frame[0] == 10
    spare = !strike && frame.sum == 10

    if i == 9
      frame.sum
    elsif strike
      double = next_frame[0] == 10
      if double
        second_point = i == 8 ? next_frame[1] : after_next_frame[0]
        next_frame[0] + second_point + 10
      else
        next_frame[0] + next_frame[1] + 10
      end
    elsif spare
      next_frame[0] + 10
    else
      frame.sum
    end
end

puts point
