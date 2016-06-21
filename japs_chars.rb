# coding: utf-8

require 'optparse'
require 'csv'

# csvファイルを読み込んで配列で返す
def read_csv(path)
  options = {:headers => false}
  chars = CSV.table(path,options).transpose[0]
end

# コードポイントの配列から指定した形式の配列で返す
def output_chars(chars,format: "UTF-8")
  if format == "UTF-8"
    chars.map{|c| c.chr("UTF-8")}
  elsif format == "Unicode"
    chars.map{|c| sprintf("%#06x",c)}
  end
end

params = ARGV.getopts("d:c:o:U")
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

# csvディレクトリからファイル名とパスを取得
csv_files = Hash[*(Dir.glob("#{CSV_FILES_DIR}/*.csv").map{|file_path|
  [ File.basename(file_path,".*"), file_path ]
}.flatten)]

# 出力文字決定
char_types = Array.new
params["c"].each_char do |type|
  case type
  when "H"
    char_types.push("hiragana_normal")
    char_types.push("hiragana_voicing")
    char_types.push("hiragana_small")
  when "h" then char_types.push("hiragana_normal")
  when "v" then char_types.push("hiragana_voicing")
  when "s" then char_types.push("hiragana_small")
  when "K"
    char_types.push("katakana_normal")
    char_types.push("katakana_voicing")
    char_types.push("katakana_small")
  when "k" then char_types.push("katakana_normal")
  when "V" then char_types.push("katakana_voicing")
  when "S" then char_types.push("katakana_small")
  when "e" then char_types.push("katakana_extention")
  when "x" then char_types.push("jis_kanji_1")
  when "X" then char_types.push("jis_kanji_2")
  else raise "-cオプションが不正"
  end
end

# 出力形式決定
output_type = params["U"] ? "Unicode" : "UTF-8"

# csvから抽出
char_nums = Array.new
char_types.each do |type|
  char_nums.push( read_csv(csv_files[type]) )
end

# ファイル出力
chars = output_chars(char_nums.flatten,format: output_type)
options = {:row_sep => "", :col_sep => delimiter}
CSV.open(params["o"], "w", options) << chars
