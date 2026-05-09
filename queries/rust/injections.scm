; extends

(
    [
        (string_content)
    ] @injection.content
    (#match? @injection.content "(SELECT|INSERT|UPDATE|DELETE).+(FROM|INTO|VALUES|SET).*(WHERE|GROUP BY)?")
    (#set! injection.language "sql")
)

(
    [
        (string_content)
    ] @injection.content
    (#match? @injection.content "(CREATE|ALTER|DROP|TRUNCATE).+(TABLE)?")
    (#set! injection.language "sql")
)

(macro_invocation
  macro: [(identifier) (scoped_identifier)] @_name
  (token_tree) @injection.content
  (#any-of? @_name "view")
  (#set! injection.language "html")
  (#set! injection.include-children))
