" Vim syntax file
" Language:     Dockerfile
" Maintainer:   Sam Hanes <sam@maltera.com>
" URL:          https://github.com/Elemecca/dockerfile.vim

" for version 5.x: clear all syntax items
" for version 6.x: quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" load shell syntax for use in RUN and company
let g:sh_noisk=1         " don't mess with iskeyword
let g:sh_fold_enabled=0  " don't try to fold on shell constructs
syntax include @shAll syntax/sh.vim

" Dockerfile keywords are case-insensitive
" note that this does not affect the shell syntax loaded earlier
syntax case ignore

syntax match dockerfileLineCont      "\\\n"    contained containedin=@shAll extend
syntax match dockerfileLineContError "\\\s\+$" contained containedin=@shAll

syntax cluster dockerfileInline contains=dockerfileLineCont,dockerfileLineContError

syntax region dockerfileString start=/"/ end=/"/ contained oneline

syntax match dockerfileKeyword /\v^\s*(FROM|MAINTAINER|EXPOSE|ENV)/ nextgroup=dockerfileText
syntax match dockerfileKeyword /\v^\s*(ADD|VOLUME|USER|WORKDIR)/    nextgroup=dockerfileText
syntax match dockerfileKeyword /\v^\s*(RUN|CMD|ENTRYPOINT)/ nextgroup=dockerfileScript,dockerfileArray

syntax region dockerfileText   start="\s" end="$" keepend contains=@dockerfileInline contained
syntax region dockerfileScript start="\s" end="$" keepend contains=@dockerfileInline,@shSubShList contained
syntax region dockerfileArray  start="\s*\[" end="]" contains=dockerfileString contained

syntax match dockerfileComment "\v^\s*#.*$"

hi def link dockerfileKeyword       Keyword
hi def link dockerfileComment       Comment
hi def link dockerfileLineCont      Operator
hi def link dockerfileLineContError Error
hi def link dockerfileString        String

let b:current_syntax = "dockerfile"
