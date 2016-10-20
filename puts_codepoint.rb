#!ruby

start_num = ARGV[0].hex
end_num = ARGV[1].hex
start_num.upto(end_num) do |n|
  puts sprintf('0x%04x', n)
end
