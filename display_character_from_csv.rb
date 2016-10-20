#!ruby
require 'csv'
path = ARGV[0]
options = {:headers => false}
chars = CSV.table(path,options).transpose[0].map{|c| c.chr("UTF-8")}
chars.each do |c|
  c.each_codepoint { |cp| puts "U+#{cp.to_s(16)} : '#{c}'" }
end

