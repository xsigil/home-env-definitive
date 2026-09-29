" Neovim syntax file for Universal Bayes System DSL (*.ub)
if exists("b:current_syntax")
  finish
endif

" 1. 1行コメント (# ...)
syntax match ubComment "#.*$" contains=@Spell

" 2. 文字列リテラル ("...")
syntax region ubString start=/"/ skip=/\\\\\|\\"/ end=/"/ contains=@Spell

" 3. トップレベルキーワード / スコープキーワード
syntax keyword ubKeyword Slot Subject Hypothesis Evidence Element
syntax keyword ubInclude #include includepdf

" 4. 引数キー (date:, window:, prior:)
syntax keyword ubKey date window prior

" 5. デシバン数値 / 整数 (+18, -30, 0 など)
syntax match ubNumber "\v<[+-]?[0-9]+>"

" 6. デリミタ / 記号
syntax match ubDelimiter "[{}():;,]"

" --- 標準ハイライトグループへのリンク ---
highlight default link ubComment   Comment
highlight default link ubString    String
highlight default link ubKeyword   Statement
highlight default link ubInclude   Include
highlight default link ubKey       Type
highlight default link ubNumber    Number
highlight default link ubDelimiter Delimiter

let b:current_syntax = "ub"
