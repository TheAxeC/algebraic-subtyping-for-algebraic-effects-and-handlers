# Algebraic Subtyping for Algebraic Effects and Handlers

## Bugs

### Sequencing/letin

`fun a -> #Op (); a` is compiled to `fun a -> let _ = #Op () in a`.

This does not comply with the specification
