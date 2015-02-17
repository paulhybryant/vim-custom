" vim: set sw=2 ts=2 sts=2 et tw=78 foldlevel=0 foldmethod=marker filetype=vim nospell:

" Get the array of normal buffers, by normal it means it is not special
" buffers that are for exampe hidden {{{
function! myutils#GetListedBuffers()
    return filter(range(1, bufnr('$')), 'buflisted(v:val)')
endfunction
" }}}

" Get the number of normal listed buffers, by normal it means it is not special
" buffers that are for exampe hidden {{{
function! myutils#GetNumListedBuffers()
    return len(myutils#GetListedBuffers())
endfunction
" }}}

" Get the next number of normal buffers after 'cur_bufnr'. The next number is
" the smallest buffer number that is larger than 'cur_bufnr'. If 'cur_bufnr'
" is the largest buffer number, return the largest buffer number that is
" smaller than 'cur_bufnr'. Returns 'cur_bufnr' if there is only one normal
" buffer. {{{
let g:myutils#special_bufvars = ['gistls', 'NERDTreeType']
function! myutils#NextBufNr(cur_bufnr)
    let l:buffers = myutils#GetListedBuffers()

    if &buftype == 'quickfix'
        return -1
    endif

    for var in g:myutils#special_bufvars
        if exists('b:' . var)
            return -1
        endif
    endfor

    if len(l:buffers) == 1
        if l:buffers[0] == a:cur_bufnr
            return l:buffers[0]
        else
            return -1
        endif
    endif

    for i in range(0, len(l:buffers) - 1)
        if l:buffers[i] == a:cur_bufnr
            if i == len(l:buffers) - 1
                return l:buffers[i - 1]
            else
                return l:buffers[i + 1]
            endif
        endif
    endfor
    return -1
endfunction
" }}}

" Whether the current window is the NERDTree window {{{
function! myutils#IsInNERDTreeWindow()
  return exists("b:NERDTreeType")
endfunction
" }}}

" Returns true iff is NERDTree open/active {{{
function! myutils#IsNTOpen()
    return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction
" }}}

" calls NERDTreeFind iff NERDTree is active, current window contains a
" modifiable file, and we're not in vimdiff {{{
function! myutils#SyncNTTree()
    if &modifiable && myutils#IsNTOpen() && strlen(expand('%')) > 0 && !&diff
        if !exists('t:NERDTreeBufName') || bufname('%') != t:NERDTreeBufName
            NERDTreeFind
            wincmd p
        endif
    endif
endfunction
" }}}

" Sort words selected in visual mode in a single line, separated by space {{{
function! myutils#SortWords(delimiter, numeric) range
    let l:delimiter = a:delimiter
    if a:firstline != a:lastline
        echomsg "Can only sort words in a single line."
    endif
    if len(l:delimiter) != 1
        let l:delimiter = ' '
    endif
    " yank current visual selection to reg x
    normal gv"xy
    " split the words selected and sort
    if a:numeric
        let @x = join(sort(map(split(@x, l:delimiter), 'str2nr(v:val)'), 'n'), l:delimiter)
    else
        let @x = join(sort(split(@x, l:delimiter)), l:delimiter)
    endif
    " re-select area and delete
    normal gvd
    " paste sorted words back in
    normal "xP
endfunction
" }}}

" Get the total number of normal windows {{{
function! myutils#GetNumberOfNormalWindows()
    return len(filter(range(1, winnr('$')), 'buflisted(winbufnr(v:val))'))
endfunction
" }}}

" Functions for editing related files {{{
function! myutils#EditHeader()
  let l:filename = expand("%")
  if l:filename =~# ".*\.h$"
    return
  elseif l:filename =~# ".*_unittest\.cc$"
    let l:filename = substitute(l:filename, "\\v(.*)_unittest\.cc", "\\1", "")
  elseif l:filename =~# ".*\.cc$"
    let l:filename = substitute(l:filename, "\\v(.*)\.cc", "\\1", "")
  endif
  exec "edit " . fnameescape(l:filename . ".h")
endfunction

function! myutils#EditCC()
  let l:filename = expand("%")
  if l:filename =~# ".*_unittest\.cc"
    let l:filename = substitute(l:filename, "\\v(.*)_unittest\.cc", "\\1", "")
  elseif l:filename =~# ".*\.h"
    let l:filename = substitute(l:filename, "\\v(.*)\.h", "\\1", "")
  else
    return
  endif
  exec "edit " . fnameescape(l:filename . ".cc")
endfunction

function! myutils#EditTest()
  let l:filename = expand("%")
  if l:filename =~# ".*_unittest\.cc"
    return
  elseif l:filename =~# ".*\.cc"
    let l:filename = substitute(l:filename, "\\v(.*)\.cc", "\\1", "")
  elseif l:filename =~# ".*\.h"
    let l:filename = substitute(l:filename, "\\v(.*)\.h", "\\1", "")
  endif
  exec "edit " . fnameescape(l:filename . "_unittest.cc")
endfunction
" }}}

" functions for settping up tabline mappsing for different OSes {{{
function! myutils#SetupTablineMappingForMac()
  silent! nmap <silent> <unique> ¡ <Plug>AirlineSelectTab1
  silent! nmap <silent> <unique> ™ <Plug>AirlineSelectTab2
  silent! nmap <silent> <unique> £ <Plug>AirlineSelectTab3
  silent! nmap <silent> <unique> ¢ <Plug>AirlineSelectTab4
  silent! nmap <silent> <unique> ∞ <Plug>AirlineSelectTab5
  silent! nmap <silent> <unique> § <Plug>AirlineSelectTab6
  silent! nmap <silent> <unique> ¶ <Plug>AirlineSelectTab7
  silent! nmap <silent> <unique> • <Plug>AirlineSelectTab8
  silent! nmap <silent> <unique> ª <Plug>AirlineSelectTab9
endfunction

function! myutils#SetupTablineMappingForLinux()
  if has('gui_running')
    silent! nmap <silent> <unique> <M-1> <Plug>AirlineSelectTab1
    silent! nmap <silent> <unique> <M-2> <Plug>AirlineSelectTab2
    silent! nmap <silent> <unique> <M-3> <Plug>AirlineSelectTab3
    silent! nmap <silent> <unique> <M-4> <Plug>AirlineSelectTab4
    silent! nmap <silent> <unique> <M-5> <Plug>AirlineSelectTab5
    silent! nmap <silent> <unique> <M-6> <Plug>AirlineSelectTab6
    silent! nmap <silent> <unique> <M-7> <Plug>AirlineSelectTab7
    silent! nmap <silent> <unique> <M-8> <Plug>AirlineSelectTab8
    silent! nmap <silent> <unique> <M-9> <Plug>AirlineSelectTab9
  else
    silent! nmap <silent> <unique> 1 <Plug>AirlineSelectTab1
    silent! nmap <silent> <unique> 2 <Plug>AirlineSelectTab2
    silent! nmap <silent> <unique> 3 <Plug>AirlineSelectTab3
    silent! nmap <silent> <unique> 4 <Plug>AirlineSelectTab4
    silent! nmap <silent> <unique> 5 <Plug>AirlineSelectTab5
    silent! nmap <silent> <unique> 6 <Plug>AirlineSelectTab6
    silent! nmap <silent> <unique> 7 <Plug>AirlineSelectTab7
    silent! nmap <silent> <unique> 8 <Plug>AirlineSelectTab8
    silent! nmap <silent> <unique> 9 <Plug>AirlineSelectTab9
  endif
endfunction

function! myutils#SetupTablineMappingForWindows()
  silent! nmap <silent> <unique> ± <Plug>AirlineSelectTab1
  silent! nmap <silent> <unique> ² <Plug>AirlineSelectTab2
  silent! nmap <silent> <unique> ³ <Plug>AirlineSelectTab3
  silent! nmap <silent> <unique> ´ <Plug>AirlineSelectTab4
  silent! nmap <silent> <unique> µ <Plug>AirlineSelectTab5
  silent! nmap <silent> <unique> ¶ <Plug>AirlineSelectTab6
  silent! nmap <silent> <unique> · <Plug>AirlineSelectTab7
  silent! nmap <silent> <unique> ¸ <Plug>AirlineSelectTab8
  silent! nmap <silent> <unique> ¹ <Plug>AirlineSelectTab9
endfunction
" }}}
