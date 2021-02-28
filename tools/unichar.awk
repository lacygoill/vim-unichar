#!/usr/bin/awk -f

# Input: file downloaded from:
# ftp://ftp.unicode.org/Public/UNIDATA/UnicodeData.txt

# Output: Vimscript  code  defining  the  `unichar#util#dict()`  function  which
# returns a dictionary mapping the code point of a character to its description

# Usage:
#
#     /path/to/unichar.awk <(curl -Ls ftp://ftp.unicode.org/Public/UNIDATA/UnicodeData.txt) >/path/to/util/unichar.vim

# Most of the code is taken from:
# https://github.com/tpope/vim-characterize/blob/master/autoload/unicode.awk

BEGIN { FS=";"; printf "let s:d = {}\n\n"}

{
    code = $1
    name = $2
    alias = $11
    if (name == "<control>" && length(alias) != 0) {
        name = alias
    }
    printf "let s:d[0x%s]='%s'\n", $1, name
}

END { printf "\nfu unichar#util#dict() abort\n    return s:d\nendfu" }
