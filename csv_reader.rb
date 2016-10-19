# coding: utf-8
require 'csv'

CSV_FILES_DIR = File.expand_path("../csv",__FILE__)

# csvディレクトリから全てのファイル名とパスを取得
def all_file_path_hash
  return Hash[*(Dir.glob("#{CSV_FILES_DIR}/*.csv").map{|file_path|
                  [ File.basename(file_path,".*"), file_path ]
                }.flatten)]
end

# ファイル名の配列からcsvディレクトリに存在するファイルのパスを返す
def file_paths_from_file_names(file_names)
  path_hash = all_file_path_hash
  return file_names.map{|fn| path_hash[fn] }
end

# ファイルのパスの配列からコードポイントの配列を返す
def codepoints(file_paths)
  return file_paths.map{|fp| read_csv(fp) }.flatten
end

# コードポイントの配列から指定した形式の配列で返す
def output_chars(chars,format: "UTF-8")
  if format == "UTF-8"
    chars.map{|c| c.chr("UTF-8")}
  elsif format == "Unicode"
    chars.map{|c| sprintf("%#06x",c)}
  else
    raise "unknown format."
  end
end

# csvファイルを読み込んで配列で返す
def read_csv(path)
  options = {:headers => false}
  chars = CSV.table(path,options).transpose[0]
end

# ファイル名の配列からコードポイントを指定した形式の配列で返す
def codepoints_from_file_names(file_names, format: 'UTF-8')
  fp = file_paths_from_file_names(file_names)
  cp = codepoints(fp)
  return output_chars(cp, format: format)
end

