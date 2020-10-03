fu unichar#toggle#main(lnum1, lnum2) abort
    call cursor(a:lnum1, 1)
    if search('\\u\x\+', 'nW', a:lnum2)
        let [pat, l:Rep] = ['\\u\x\+', {m -> eval('"' .. m[0] .. '"')}]
    else
        let [pat, l:Rep] = ['[^\x00-\xff]',
            \ {m -> char2nr(m[0])->printf(char2nr(m[0]) <= 65535 ? '\u%x' : '\U%x')}]
    endif
    let old_lines = getline(a:lnum1, a:lnum2)
    let new_lines = map(old_lines, {_, v -> substitute(v, pat, Rep, 'g')})
    call setline(a:lnum1, new_lines)
endfu

