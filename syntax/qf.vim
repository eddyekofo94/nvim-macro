" Vim syntax file
" Language:     Quickfix window
" Maintainer:   Bekaboo <kankefengjing@gmail.com>
" Last Updated: Thu 28 Dec 2023 04:14:22 AM CST

if exists("b:current_syntax")
  finish
endif

" Default syntax and highlightings, use pipe or EN Space as separator
syn match qfFileName  "^[^|│ ]*" nextgroup=qfSeparator
syn match qfSeparator "[|│ ]"    nextgroup=qfLineNr                       contained
syn match qfLineNr    "[^|│ ]*"  contains=qfError,qfWarning,qfNote,qfInfo contained

hi def link qfFileName Directory
hi def link qfLineNr   LineNr

" Extended syntax to include additional keywords.
syn match qfError   "\<\(E\|ERROR\|error\)\>"              contained
syn match qfInfo    "\<\(I\|INFO\|info\)\>"                contained
syn match qfNote    "\<\(N\|H\|NOTE\|HINT\|note\|hint\)\>" contained
syn match qfWarning "\<\(W\|WARN\|warning\)\>"             contained

hi def link qfError   DiagnosticSignError
hi def link qfInfo    DiagnosticSignInfo
hi def link qfNote    DiagnosticSignHint
hi def link qfWarning DiagnosticSignWarn

let b:current_syntax = "qf"
