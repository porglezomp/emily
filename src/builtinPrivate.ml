(* Populates a scope for use by snippets; the user can't ever see it. *)
(* Note: Scope does not inherit true because it isn't user accessible. *)
let privatePrototypeTable = Value.tableBlank Value.TrueBlank
let privatePrototype = Value.TableValue(privatePrototypeTable)

let () =
    let (setAtomValue, setAtomFn, setAtomMethod) = BuiltinNull.atomFuncs scopePrototypeTable in
    ()

let snippetClosure args text =
    ()