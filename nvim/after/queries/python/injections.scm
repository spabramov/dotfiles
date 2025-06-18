; extends

; "text with {param} highlighted"
(string
    (string_content) @injection.content
    (#set! injection.language "nim_format_string")
)

; "SELECT ... FROM ..."
(string
    (string_content) @injection.content
    (#match? @injection.content "\\cselect.+from")
    (#set! injection.language "sql")
)

; query = "sql expression"
(assignment 
    left: (identifier) @_id
    right: (string (string_content) @injection.content)
    (#match? @_id "\\cquery|sql")
    (#set! injection.language "sql"))

; query("sql expression")
(call 
    function: (identifier)  @_id
    arguments: (argument_list (string (string_content) @injection.content))
    (#match? @_id "\\cquery")
    (#set! injection.language "sql"))
