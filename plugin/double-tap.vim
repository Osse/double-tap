"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Double-Tap makes annoying comments go away
" Maintainer:  Øystein Walle <oystwa@gmail.com>
" Version:     0.1
" Description: Opening a new line from a comment may insert an unwanted
" comment; (re)pressing Enter will clear the line for you. This works if in
" insert mode and pressing Enter as well when using o or O in normal mode
" Last Change: Tue Mar 20 16:40:28 CET 2012
" License:     Vim License (see :help license)
" Location:    plugin/double-tab.vim
" Website:     https://github.com/osse/double-tap
"
" See double-tap.txt for help. This can be accessed by doing:
"
" :helptags ~/.vim/doc
" :help doubletap.txt
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:doubletap_version = '0.1'

" Vimscript Setup: {{{1
" Allow use of line continuation.
let s:save_cpo = &cpo
set cpo&vim

" We need version 7 for <expr> mappings
" as well as the user wanting nocompatible
if exists("g:loaded_doubletap")
          \ || !has("comments")
          \ || v:version < 700
          \ || &compatible
  let &cpo = s:save_cpo
  finish
endif
let g:loaded_doubletap = 1
" }}}

let s:pattern = '^\(.*,\|^\):\([^,]\+\).*$' " This patterns finds the wanted
                                            " item in 'comments'

let s:commStart = {} " dict to hold the comment starters using
                     " the current filetype as key

" This function returns a regular <CR> if the current line
" is not simply an empty comment. Otherwise it clears the line
function! s:Detect_empty_comment()
  " Do nothing in particular if no filetype is set
  if empty(&ft)
    return "\<CR>"
  endif
  " Captures the comment starter if necessary; only once per filetype
  if !has_key(s:commStart, &ft)
    let s:commStart[&ft] = substitute(&comments, s:pattern, '\2', '')
  endif
  let line = getline('.')
  if line =~ '^\s*'. s:commStart[&ft] . '\s*$'
    return "\<C-U>"
  else
    return "\<CR>"
  endif
endfunction

if !hasmapto('<Plug>DoubletapDetect')
  imap <unique> <CR> <Plug>DoubletapDetect
endif

inoremap <expr> <Plug>DoubletapDetect <SID>Detect_empty_comment()

" Teardown:{{{1
"reset &cpo back to users setting
let &cpo = s:save_cpo
" }}}

" vim: set sw=2 sts=2 et fdm=marker:
