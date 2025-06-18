; extends

(string
    (string_content) @text.emphasis
    (#match? @text.emphasis "\\cselect.+from")
    (#set! injection.language "sql")
)

(assignment 
    left: (identifier) @variable
    right: (string (string_content) @text.emphasis)
    (#match? @variable "\\cquery|sql"))

(call 
    function: (identifier)  @function.call
    arguments: (argument_list (string (string_content) @text.emphasis))
    (#match? @function.call "\\cquery|op.execute|sa.text"))
