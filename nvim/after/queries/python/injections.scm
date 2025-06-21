; extends

; "text with {param} highlighted"
(string
    (string_content) @injection.content
    (#set! injection.language "nim_format_string")
)

; """SELECT ... FROM ..."""
(string
    (string_start) @string_start
    (string_content) @injection.content
    (#eq? @string_start "\"\"\"")
    (#match? @injection.content "\\c^--sql")
    (#set! injection.language "sql")
)

