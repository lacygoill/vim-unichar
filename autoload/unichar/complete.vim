if exists('g:autoloaded_unichar#complete')
    finish
endif
let g:autoloaded_unichar#complete = 1

" Interface {{{1
fu unichar#complete#fuzzy() abort "{{{2
    if !exists('*fzf#wrap') | return s:error('fzf is not installed') | endif
    if !exists('s:unicode_dict') | call s:init() | endif
    call fzf#run(fzf#wrap('unicode characters', {
        \ 'source': s:unicode_dict,
        \ 'options': '--ansi --tiebreak=index +m',
        \ 'sink': function('s:inject_unicode_character')}))
endfu
"}}}1
" Core {{{1
fu s:translate(lists) abort "{{{2
    for list in a:lists
        let list[0] = eval('"\u'..printf('%x', list[0])..'"')
    endfor
    return a:lists
endfu

fu s:inject_unicode_character(line) abort "{{{2
    let char = matchstr(a:line, '^.')
    call feedkeys((col('.') >= col('$') - 1 ? 'a' : 'i')..char, 'in')
endfu

fu s:init() abort "{{{2
    let s:unicode_dict = unichar#util#dict()
    let s:unicode_dict = s:translate(items(s:unicode_dict))
    call map(s:unicode_dict, '"\x1b[33m"..v:val[0].."\x1b[m\t"..v:val[1]')
endfu
"}}}1
" Utilities {{{1
fu s:error(msg) abort "{{{2
    echohl ErrorMsg
    echo a:msg
    echohl NONE
endfu

