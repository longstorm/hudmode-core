"" =============================================================================
"" File:          plugin/tnt.vim
"" Description:   An outliner and system for hackers, writers and artists.
"" Author:        Vic Goldfeld <vic@longstorm.org>
"" Version:       0.0
"" ReleaseDate:   2013-01-31
"" License:       MIT License (see below)
""
"" Copyright (C) 2013 Vic Goldfeld under the MIT License.
""
"" Permission is hereby granted, free of charge, to any person obtaining a 
"" copy of this software and associated documentation files (the "Software"), 
"" to deal in the Software without restriction, including without limitation 
"" the rights to use, copy, modify, merge, publish, distribute, sublicense, 
"" and/or sell copies of the Software, and to permit persons to whom the 
"" Software is furnished to do so, subject to the following conditions:
""
"" The above copyright notice and this permission notice shall be included in 
"" all copies or substantial portions of the Software.
""
"" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
"" OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
"" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
"" THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR 
"" OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
"" ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR 
"" OTHER DEALINGS IN THE SOFTWARE.
"" =============================================================================

if exists('g:loaded_hudmode') || &cp
	finish
endif
let g:loaded_hudmode = 1

augroup hud
	autocmd!
	autocmd CursorMoved *.hud,*.vhud call CursorMoveLoop()
augroup END

let s:lines = 0
let s:line = 0
let s:num = 0
let s:ex = 0
function! CursorMoveLoop()
	let lines = line('$')
	let line = getline('.')
	let num = line('.')
	let ex = histnr(':')
	
	let checkLines = l:lines == s:lines
	let checkLine = l:line == s:line
	let checkNum = l:num == s:num
	let checkEx = l:ex == s:ex

	" if we're still on the same line number.
	if l:checkNum
		" if the number of lines hasn't changed.
		if l:checkLines
			" if our current line hasn't changed.
			if l:checkLine
				" if no new ex command was issued.
				if l:ex
					return
				endif
			" our current line has changed.
			else

			endif
		endif
	endif
		


	echo checkLines .' '. checkLine .' '. checkNum .' '. checkEx

	if l:checkLines && l:checkNum && l:checkLine && l:checkEx
		return
	endif

	if l:checkEx
		echo l:ex
	endif

	let s:lines = l:lines
	let s:line = l:line 
	let s:num = l:num 
	let s:ex = l:ex

endfunction

nnoremap <Leader>.n :luafile $HOME/.vim/bundle/hudmode-vim/plugin/hudmode.lua<CR>

lua << MONGO
require('mongo')
local db = assert(mongo.Connection.New())

assert(db:connect('localhost'))
--assert(db:insert('test.values', { a = 9, b = 'str9' }))

findOne = function(collection, query, fields)
	local q = assert(db:query(collection, query))
	for res in q:results() do return 3 end
end
MONGO

lua << EOF
-- compiled from github.com/longstorm/hudmode-core/fold.coffee:32
getFoldById = function(id, fields)
  if id == nil then
    id = -1
  end
  if fields == nil then
    fields = { }
  end
  return findOne('folds', {
    _id = id
  }, fields)
end
EOF

nnoremap <Leader>.N :echo luaeval('getFoldById(1)')<CR>
