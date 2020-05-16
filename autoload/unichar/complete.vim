if exists('g:autoloaded_unichar#complete')
    finish
endif
let g:autoloaded_unichar#complete = 1

" sets the color for the glyph of a unicode character
const s:COLOR = 30

" Interface {{{1
fu unichar#complete#fuzzy() abort "{{{2
    if !exists('*fzf#run') | return s:error('fzf is not installed') | endif
    if !exists('s:fuzzy_source') | call s:set_fuzzy_source() | endif
    call fzf#run(fzf#wrap({
        \ 'source': s:fuzzy_source,
        \ 'options': '--ansi --nth=2.. --tiebreak=index -m',
        \ 'sink': function('s:inject_unicode_character',
        \ )}))
endfu
"}}}1
" Core {{{1
fu s:translate(lists) abort "{{{2
    for list in a:lists
        let list[0] = eval('"\U'..printf('%x', list[0])..'"')
    endfor
    return a:lists
endfu

fu s:inject_unicode_character(line) abort "{{{2
    let char = matchstr(a:line, '^.')
    call feedkeys((col('.') >= col('$') - 1 ? 'a' : 'i')..char, 'in')
endfu

fu s:set_fuzzy_source() abort "{{{2
    let s:fuzzy_source = unichar#util#dict()
    let s:fuzzy_source = s:translate(items(s:fuzzy_source))
    " Some weird unicode characters can prevent us from accessing a match in the fzf window.{{{
    "
    " For example, search for `single`, then press `C-p` to visit all matches.
    " You  won't   be  able  to   finish,  because  eventually,  `c6`   will  be
    " automatically appended to the command-line:
    "
    "     single6c
    "           ^^
    "
    " In this example, I think the culprit is `SINGLE CHARACTER INTRODUCER`.
    "
    " Btw, this is probably a bug in st:
    " https://github.com/tmux/tmux/issues/2124#issuecomment-601301882
    "
    " ---
    "
    " Anyway, if a character is not printable, I doubt I'll ever want to insert it.
    "}}}
    call filter(s:fuzzy_source, 'v:val[0] !~# ''[^[:print:]]''')
    call map(s:fuzzy_source, '"\x1b[38;5;"..s:COLOR.."m"..v:val[0].."\x1b[0m\t"..v:val[1]')
endfu
"}}}1
" Utilities {{{1
fu s:error(msg) abort "{{{2
    echohl ErrorMsg
    echo a:msg
    echohl NONE
endfu

