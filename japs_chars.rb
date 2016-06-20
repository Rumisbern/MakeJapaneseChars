# coding: utf-8

require 'optparse'
require 'csv'

def read_csv(path)
  options = {:headers => false}
  chars = CSV.table(path,options).transpose[0]
end

def output_chars(chars,format: "UTF-8")
  if format == "UTF-8"
    chars.map{|c| c.chr("UTF-8")}
  elsif format == "" ###################### kokokokoko ################
  end
end

params = ARGV.getopts("d:c:o:US")
raise "-c,-oオプションは指定必須" unless params["c"] && params["o"]

CSV_FILES_DIR = File.expand_path("../csv",__FILE__)

# 区切り文字設定
delimiter = "\n"
if params["d"]
  delimiter = params["d"].gsub(/\\./) do |matched|
    case matched
    when "\\s" then "\s"
    when "\\n" then "\n"
    when "\\t" then "\t"
    else raise "-dオプションが不正"
    end
  end
end

csv_files = Hash[*(Dir.glob("#{CSV_FILES_DIR}/*.csv").map{|file_path|
  [ File.basename(file_path,".*"), file_path ]
}.flatten)]

c = read_csv(csv_files["hiragana_voicing"])
p output_chars(c)
