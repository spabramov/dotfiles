; extends

; """SELECT ... FROM ..."""
(string
    (string_start) @string.documentation.python
    (string_content) @sql.injected
    (#eq? @string.documentation.python "\"\"\"")
    (#match? @sql.injected "\\c^--sql"))
