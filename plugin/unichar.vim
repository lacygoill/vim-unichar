vim9script noclear

if exists('loaded') | finish | endif
var loaded = true

# Mappings {{{1

ino <c-g><c-u> <cmd>call unichar#complete#fuzzy()<cr>

# Commands {{{1

# This command looks for special sequences  such as `\u1234` inside the range of
# lines it received.
# If it  finds one,  it tries  to translate  all similar  ones into  the literal
# characters they stand for.
# If it  doesn't find any  `\u1234`, it tries to  do the reverse;  translate all
# characters  whose code  point  is above  255  (anything which  is  not in  the
# extended ascii table) into special characters + code points.

com -bar -range=% UnicharToggle unichar#toggle#main(<line1>, <line2>)

