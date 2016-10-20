# coding: utf-8
require 'csv'

CSV_FILES_DIR = File.expand_path("../csv",__FILE__)

def read_csv(path)
  options = {:headers => false}
  chars = CSV.table(path,options).transpose[0]
end

# csvディレクトリからファイル名とパスを取得
csv_files = Hash[*(Dir.glob("#{CSV_FILES_DIR}/*.csv").map{|file_path|
  [ File.basename(file_path,".*"), file_path ]
}.flatten)]

codepoints_array = Array.new
csv_files.each_value do |path|
  codepoints_array.push( read_csv(path) )
end

dups = codepoints_array.flatten.group_by{|i| i}.reject{|k,v| v.one?}.keys
result = Hash.new
dups.each do |n|
  codepoints_array.each_with_index do |codepoints,i|
    if codepoints.include?(n)
      result[n] ||= Array.new
      result[n].push(csv_files.keys[i])
    end
  end
end

result.each do |k,v|
  puts "0x#{sprintf('%04x',k)} : #{v.inject{|memo,str| memo + ", " + str}}"
end

