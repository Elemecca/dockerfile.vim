
if exists( "b:current_syntax" )
    finish
endif

syntax include syntax/sh.vim

let b:current_syntax = "dockerfile"

syntax case ignore

syntax match dockerfileLineCont      "\\$"  contained
syntax match dockerfileLineContError "\\ $" contained

syntax cluster dockerfileInline contains=dockerfileLineCont,dockerfileLineContError

syntax region dockerfileString start=/"/ end=/"/ contained

syntax match dockerfileKeyword /\v^\s*(FROM|MAINTAINER|EXPOSE|ENV)/ nextgroup=dockerfileText
syntax match dockerfileKeyword /\v^\s*(ADD|VOLUME|USER|WORKDIR)/    nextgroup=dockerfileText
syntax match dockerfileKeyword /\v^\s*(RUN)/ nextgroup=dockerfileScript
syntax match dockerfileKeyword /\v^\s*(CMD|ENTRYPOINT)/ nextgroup=dockerfileScript,dockerfileArray

syntax region dockerfileText   start="\s" skip="\\$" end="$" contains=@dockerfileInline contained
syntax region dockerfileScript start="\s" skip="\\$" end="$" contains=@dockerfileInline,@shSubShList contained
syntax region dockerfileArray  start="\s*\[" end="]" contains=dockerfileString contained

syntax match dockerfileComment "#.*$" contains=@dockerfileInline

hi def link dockerfileKeyword       Keyword
hi def link dockerfileComment       Comment
hi def link dockerfileLineCont      Operator
hi def link dockerfileLineContError Error
hi def link dockerfileString        String
