日本語文字スクリプト
====

日本語の文字を書き出すrubyスクリプト

## Requirement
Ruby >= 2.1.0
### GUI版
- Tcl/Tk
    - 対応バージョンは不明．8.0にて確認
- gem 'tk'
    - 0.1.1にて確認

## Usage (CUI)
GUI版のほうが対応文字種が多いので，GUI版を推奨．

`ruby japs_chars.rb [-d "区切り文字"] -c 出力文字オプション -o 出力ファイル名 [出力形式オプション]`

区切り文字オプション(任意)
* ダブルクオートで指定
* 空白や改行等の特殊文字は以下が使用可能
    * 空白文字 '\s'
    * 改行文字 '\n'
    * 水平タブ '\t'
* デフォルトでは改行'\n'
* 出力文字と被らないように注意(特に記号)

出力文字オプション(必須)
* H Unicodeのひらがな
    * 以下のものを含まないU+3041~U+309Fのひらがな
        * voicingmarks (「゛」等)
        * 繰り返し記号「ゝ」「ゞ」
        * 縦書き文字「ゟ」
* h Unicodeの通常ひらがな
    * -Hに小文字と濁音・半濁音を除いたもの
* v Unicodeの濁音・半濁音のひらがな
* s Unicodeの小文字のひらがな
* K Unicodeのカタカナ
    * 以下のものを含まないU+30A0~U+30FFのカタカナ
        * 片仮名名句読点「゠」
        * つなぎおよび長音記号「・」「ー」
        * 繰り返し記号「ヽ」「ヾ」
        * 縦書き合字「ヿ」
* k Unicodeの通常カタカナ
    * -Kに小文字と濁音・半濁音を除いたもの
* V Unicodeの濁音・半濁音のカタカナ
* S Unicodeの小文字のカタカナ
* e Unicodeの片仮名拡張文字
    * 「ㇰ」「ㇴ」などのU+31F0~U+31FFのアイヌ語表音拡張文字
* x JIS基本漢字の第一水準漢字(JIS X 0208の16区~47区)
* X JIS基本漢字の第二水準漢字(JIS X 0208の48区~84区)
* j 常用漢字(2010年)(!未実装)
    * JISの-x,-Xオプションで指定した漢字と被るので注意
* m ASCIIコード内の記号
    * 制御文字等を除く記号文字
* n 数字
* a アルファベット小文字
* A アルファベット大文字

出力形式オプション(任意かつ重複不可)
* なし : 文字をUTF-8で出力(デフォルトでこの設定)
* -U : 文字のUnicodeコードポイントを出力

## Example (CUI)
* 区切り文字が空白
* ひらがな・カタカナ小文字抜き，JIS漢字第1,第2水準
* ファイル名'codepoints_hvkvxX.csv'
* コードポイントとして出力

`ruby japs_chars.rb -d "\s" -c hvkvxX -o codepoints_hvkvxX.csv -U`

## Usage (GUI)
Ruby/tk が必要

`ruby gui_japs_chars.rb`

## LICENSE
MIT
