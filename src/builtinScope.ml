(* Populates a prototype for scopes *)
(* Note: Scope does not inherit true because it isn't user accessible yet. *)
let scopePrototypeTable = ValueUtil.tableBlank Value.TrueBlank
let scopePrototype = Value.TableValue(scopePrototypeTable)

let rethis = Value.snippetClosure 2 (function
    | [a;Value.ClosureValue(b)] -> Value.ClosureValue( Value.rethis a b )
    | [a;b] -> ValueUtil.badArgClosure "rethis" b
    | _ -> ValueUtil.impossibleArg "rethis")

let dethis = Value.snippetClosure 1 (function
    | [Value.ClosureValue(a)] -> Value.ClosureValue( Value.dethis a )
    | [a] -> ValueUtil.badArgClosure "dethis" a
    | _ -> ValueUtil.impossibleArg "dethis")

let decontext = Value.snippetClosure 1 (function
    | [Value.ClosureValue(a)] -> Value.ClosureValue( Value.decontext a )
    | [a] -> ValueUtil.badArgClosure "decontext" a
    | _ -> ValueUtil.impossibleArg "decontext")

let makeSuper current this = ValueUtil.snippetTextClosure
    ["rethis",rethis;"callCurrent",current;"obj",this]
    ["arg"]
    "(rethis obj (callCurrent.parent arg))"

let doConstruct = ValueUtil.snippetTextClosure
    ["null", Value.Null]
    ["f"]
    "f null"

let nullfn = ValueUtil.snippetTextClosure
    ["null", Value.Null]
    []
    "^(null)"

let loop = ValueUtil.snippetTextClosure
    ["tern", ValueUtil.tern; "null", Value.Null]
    ["f"]
    "{let .loop ^f ( tern (f null) ^(loop f) ^(null) ); loop} f" (* FIXME: This is garbage *)

let ifConstruct = ValueUtil.snippetTextClosure
    ["tern", ValueUtil.tern; "null", Value.Null]
    ["predicate"; "body"]
    "{let .if ^condition body (
        tern condition ^(body null) ^(null) );
    if} predicate body" (* Garbage construct again *)

let whileConstruct = ValueUtil.snippetTextClosure
    ["tern", ValueUtil.tern; "null", Value.Null]
    ["predicate"; "body"]
    "{let .while ^predicate body (
        tern (predicate null) ^(body null; while predicate body) ^(null)
    ); while} predicate body" (* Garbage construct again *)

let () =
    let (setAtomValue, setAtomFn, setAtomMethod) = BuiltinNull.atomFuncs scopePrototypeTable in

    setAtomFn "print" (
        let rec printFunction v =
            print_string (Pretty.dumpValueForUser v);
            Value.BuiltinFunctionValue(printFunction)
        in printFunction
    );

    setAtomValue "ln" (Value.StringValue "\n");

    setAtomValue "null" (Value.Null);
    setAtomValue "true" (Value.True);

    setAtomValue "rethis" rethis;
    setAtomValue "dethis" dethis;
    setAtomValue "decontext" rethis;
    setAtomValue "tern" ValueUtil.tern;
    setAtomValue "nullfn" nullfn;
    setAtomValue "do" doConstruct;
    setAtomValue "loop" loop;
    setAtomValue "if" ifConstruct;
    setAtomValue "while" whileConstruct;

    setAtomFn "not" (fun v -> match v with Value.Null -> Value.True | _ -> Value.Null);

    setAtomFn "println" (
        let rec printFunction v =
            print_endline (Pretty.dumpValueForUser v);
            Value.BuiltinFunctionValue(printFunction)
        in printFunction
    );
