vim9 noclear

if exists('loaded') | finish | endif
var loaded = true

def unichar#toggle#main(lnum1: number, lnum2: number)
    cursor(lnum1, 1)
    var pat: string
    var Rep: func
    if search('\\u\x\+', 'nW', lnum2) > 0
        [pat, Rep] = [
            '\\u\x\+',
            (m: list<string>): string => eval('"' .. m[0] .. '"')
            ]
    else
        [pat, Rep] = [
            '[^\x00-\xff]',
            (m: list<string>): string => char2nr(m[0])
                ->printf(char2nr(m[0]) <= 65535
                    ? '\u%x'
                    : '\U%x'
                  )
        ]
    endif
    var old_lines: list<string> = getline(lnum1, lnum2)
    var new_lines: list<string> = map(old_lines, (_, v) => substitute(v, pat, Rep, 'g'))
    setline(lnum1, new_lines)
enddef

