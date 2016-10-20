# coding: utf-8
require 'tk'
require 'yaml'
require_relative 'csv_reader'

config_file_path = 'config.yml'

def make_radio_button(f,var,text,value,anchor: false)
  button = TkRadioButton.new(f,
                             text: text,
                             value: value,
                             variable: var)
  if anchor != false
    button.pack(anchor: anchor)
  else
    button.pack
  end
end

def make_check_button(f, var, text, value: true, offvalue: false)
  TkCheckButton.new(f,
                    text: text,
                    onvalue: value,
                    offvalue: offvalue,
                    variable: var
                   ).pack(anchor: :w)
end

def getsavefile
  return Tk.getSaveFile('title' => 'ファイルを開く',
			'filetypes' => "{全てのファイル {.*}}")
end

def variable_values(var)
  return var.select{|v| v.value != " " && v.value != "0" }
end

def file_save_and_exit(variables, file_path, format, delimiter)
  chars = codepoints_from_file_names(variables, format: format)
  chars = chars.inject{|memo,c| memo += (delimiter + c)}
  File.write(file_path, chars)
  exit
end

root = TkRoot.new do
  title 'Make Japanese Chars GUI'
  #geometry '900x600'
end

frame_char = TkFrame.new(root)
vbar = TkScrollbar.new(frame_char)
frame_format = TkFrame.new(root)
frame_delimiter = TkFrame.new(root)


config = Hash[*YAML.load_file(config_file_path)['config'].flatten]
listbox = TkListbox.new(frame_char,
                        height: 10,
                        width: 70,
                        selectmode: 'multiple',
                        yscrollcommand: proc{|first,last| vbar.set(first, last)}
                       ).pack(side: 'left', fill: 'both')
listbox.insert('end', *config.keys)


TkLabel.new(frame_delimiter, text: "区切り文字設定").pack(anchor: :w)
var_delimiter = TkVariable.new("\s")
make_radio_button(frame_delimiter, var_delimiter, "空白", "\s", anchor: :w)
make_radio_button(frame_delimiter, var_delimiter, "改行", "\n", anchor: :w)
make_radio_button(frame_delimiter, var_delimiter, "カンマ", ",", anchor: :w)


TkLabel.new(frame_format, text: "出力形式設定").pack(anchor: :w)
var_format = TkVariable.new("UTF-8")
make_radio_button(frame_format, var_format, "UTF-8で文字を出力する", "UTF-8", anchor: :w)
make_radio_button(frame_format, var_format, "Unicodeのコードポイントを出力する", "Unicode", anchor: :w)


var = TkVariable.new('')
button = TkButton.new(root,'text' => '出力する')
button.command(proc{
                 var.value = getsavefile
                 if var.value != ""
                   file_save_and_exit(listbox.curselection.map{|i| config.values[i]},
                                      var.value,
                                      var_format.value,
                                      var_delimiter.value)
                 end
               })

frame_char.pack
frame_delimiter.pack(fill: 'x')
frame_format.pack(fill: 'x')
button.pack

Tk.mainloop

