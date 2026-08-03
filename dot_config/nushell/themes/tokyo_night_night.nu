# tokyo_night_night.nu
# Tokyo Night Night theme for Nushell
# Ported from xonsh pygments style: https://github.com/folke/tokyonight.nvim
# Activate with:  theme tokyo_night_night
#
# Palette (from the original Tokyo Night Night):
#   BLACK            #15161e
#   RED              #f7768e
#   GREEN            #9ece6a
#   YELLOW           #e0af68
#   BLUE             #7aa2f7
#   MAGENTA          #bb9af7
#   CYAN             #7dcfff
#   WHITE            #a9b1d6
#   INTENSE_BLACK    #414868
#   INTENSE_RED      #ff5874
#   INTENSE_GREEN    #a3d97a
#   INTENSE_YELLOW   #f9c574
#   INTENSE_BLUE     #7da6ff
#   INTENSE_MAGENTA  #c8a4f7
#   INTENSE_CYAN     #a4cdff
#   INTENSE_WHITE    #d8dee9
#   BACKGROUND       #1a1b26
#   TEXT             #c0caf5
#   SELECTION        #283457
#   COMMENT          #565f89

export const theme = {
    # ----- data types -----
    separator: { fg: '#414868' attr: b }
    leading_trailing_space_bg: { attr: n }
    header: { fg: '#7aa2f7' attr: b }
    empty: '#7aa2f7'
    bool: { fg: '#bb9af7' attr: i }
    int: { fg: '#ff9e64' }
    filesize: { fg: '#7dcfff' }
    duration: '#bb9af7'
    datetime: { fg: '#7dcfff' }
    range: { fg: '#ff9e64' }
    float: { fg: '#ff9e64' }
    string: '#9ece6a'
    nothing: '#565f89'
    binary: '#bb9af7'
    cell-path: '#7dcfff'
    row_index: { fg: '#9ece6a' attr: b }
    record: '#c0caf5'
    list: '#c0caf5'
    block: '#bb9af7'
    hints: '#565f89'
    search_result: { fg: '#d8dee9' bg: '#1a1b26' }
    garbled: { fg: '#d8dee9' bg: '#f7768e' attr: b }

    # ----- shapes (command-line tokens) -----
    shape_binary:           { fg: '#bb9af7' attr: b }
    shape_block:            { fg: '#bb9af7' }
    shape_bool:             { fg: '#bb9af7' }
    shape_closure:          { fg: '#9ece6a' attr: b }
    shape_custom:           '#9ece6a'
    shape_datetime:         { fg: '#7dcfff' attr: b }
    shape_directory:        { fg: '#7dcfff' }
    shape_external:         { fg: '#7dcfff' }
    shape_externalarg:      { fg: '#9ece6a' attr: b }
    shape_external_resolved: { fg: '#e0af68' attr: b }
    shape_filepath:         { fg: '#e0af68' }
    shape_flag:             { fg: '#7aa2f7' attr: b }
    shape_float:            { fg: '#ff9e64' }
    shape_glob_interpolation: { fg: '#7dcfff' attr: b }
    shape_globpattern:      { fg: '#7dcfff' attr: b }
    shape_int:              { fg: '#ff9e64' }
    shape_internalcall:     { fg: '#7dcfff' attr: b }
    shape_keyword:          { fg: '#bb9af7' attr: b }
    shape_list:             { fg: '#7dcfff' attr: b }
    shape_literal:          '#7aa2f7'
    shape_match_pattern:    '#9ece6a'
    shape_matching_brackets: { attr: u }
    shape_nothing:          { fg: '#bb9af7' }
    shape_operator:         '#89ddff'
    shape_pipe:             { fg: '#bb9af7' attr: b }
    shape_range:            { fg: '#ff9e64' attr: b }
    shape_record:           { fg: '#7dcfff' attr: b }
    shape_redirection:      { fg: '#f7768e' }
    shape_signature:        { fg: '#7dcfff' }
    shape_string:           '#9ece6a'
    shape_string_interpolation: { fg: '#bb9af7' }
    shape_table:            { fg: '#7dcfff' attr: b }
    shape_variable:         '#c0caf5'
    shape_vardecl:          { fg: '#bb9af7' attr: b }
    shape_raw_string:       '#9ece6a'
}
