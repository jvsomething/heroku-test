

today = Date.today

10.times do |_|
  now = DateTime.new(today.year, today.month, today.day, rand(0...23), 0, 0)
  end_time = now + (30/1440.0)
  p  now.to_s + ' : ' + end_time.to_s
end

