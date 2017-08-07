%token <Symbol.t> IDENT
%token <int> INT

%token EOF NL
%token LPAR RPAR LBRACE RBRACE LBRACK RBRACK
%token DEF DO END CONS MATCH CASE
%token TYPE REC ANY NOTHING ARROW
%token COMMA SEMI COLON DOT AND OR EQUALS UNDER
%token LET TRUE FALSE IF THEN ELSE
%token EQEQUALS LT GT LTE GTE PLUS MINUS
%token SUBSUME


%right EQUALS
%right ARROW
%right AND
%right OR
%nonassoc EQEQUALS
%nonassoc LT
%nonassoc GT
%nonassoc LTE
%nonassoc GTE
%left PLUS
%left MINUS
%right CONS

%{
  open Variance
  open Typector
  open Types 
  open Typecheck
  open Exp
  open Location
%}

%start <Exp.exp> prog
%start <Exp.modlist> modlist
%start <Typector.typeterm> onlytype
%start <Typector.typeterm * Typector.typeterm> subsumption

%parameter <L : Location.Locator>

%%

%inline located(X): e = X { (L.pos ($startpos(e), $endpos(e)), e) }
%inline mayfail(X): e = X { Some e } | error { None }
%inline nofail(X): e = X { Some e }

prog:
 e = lambda_exp; EOF { e }

%inline onl: NL* { () }

snl:
| NL; onl { () }
| onl; SEMI; onl { () }

(* List with optional trailing seperator and error handling *)
sep_list(Sep, Item):
|
  { [] }
| x = Item { [x] }
| x = Item; Sep; xs = sep_list(Sep, Item) { x :: xs }
| error; Sep; xs = sep_list(Sep, Item) { xs }


modlist:
| onl; e = sep_list(snl, located(moditem));  EOF { e }

moditem:
| LET; v = IDENT; EQUALS; onl; e = lambda_exp { MLet (v, e) }
| DEF; f = IDENT; LPAR; p = params; RPAR; e = funbody { MDef (f, p, e) }
| TYPE; n = IDENT; args = loption(delimited(LBRACK, 
                            separated_nonempty_list(COMMA, typeparam), RBRACK));
  EQUALS; t = typeterm
    { MType (n, args, t) }
| TYPE; n = IDENT; args = loption(delimited(LBRACK, 
                            separated_nonempty_list(COMMA, typeparam), RBRACK));
    { MOpaqueType (n, args) }

funbody: e = located(mayfail(funbody_r)) { e }
funbody_r:
| e = funbody_code_r { e }
| COLON; t = typeterm; e = funbody_code { Typed (e, t) }

%inline funbody_code: e = located(mayfail(funbody_code_r)) { e }
funbody_code_r:
| EQUALS; onl; e = lambda_exp_r { e }
| DO; e = block_r; END { e }

(* blocks contain at least one expression and eat surrounding newlines *)
block: e = located(mayfail(block_r)) { e }
block_r:
| onl; e = block_exp_r
    { e }

%inline block_exp: e = located(nofail(block_exp_r)) { e }
block_exp_r:
| LET; v = IDENT; EQUALS; onl; e1 = lambda_exp; snl; e2 = block_exp
    { Let (v, e1, e2) }
| e1 = lambda_exp; snl; e2 = block_exp
    { Seq (e1, e2) }
| e1 = lambda_exp; onl; e2 = located(nofail(terminating_semi)); onl
    { Seq (e1, e2) }
| e = lambda_exp_r; onl
    { e }

%inline terminating_semi: SEMI { Unit }


%inline lambda_exp: e = located(nofail(lambda_exp_r)) { e }
lambda_exp_r:
| LT; ps = params; GT; onl; e = lambda_exp
    { Lambda (ps, e) }
| DO; e = block_r; END
    { e }
| e = simple_exp_r
    { e }



params: p = separated_list(COMMA, located(paramtype)) { p }

paramtype:
| p = param
    { p, None }
| p = param; COLON; t = typeterm
    { p, Some t }

param:
| v = IDENT
    { Ppositional v }
| v = IDENT; EQUALS;
    { Preq_keyword v }
| v = IDENT; EQUALS; e = term
    { Popt_keyword (v, e) }

argument:
| e = lambda_exp
    { Apositional e }
| v = IDENT; EQUALS; e = lambda_exp
    { Akeyword (v, e) }
| v = IDENT; EQUALS;
    { Akeyword (v, (L.pos ($startpos(v), $endpos(v)), Some (Var v))) }


simple_exp_r:
| e1 = simple_exp; op = binop; e2 = simple_exp
    { App((L.pos ($startpos(op), $endpos(op)), Some (Var (Symbol.intern op))), [(L.pos ($startpos(e1), $endpos(e1)), Apositional e1); (L.pos ($startpos(e1), $endpos(e2)), Apositional e2)]) }
| x = term; CONS; xs = simple_exp
    { Cons(x, xs) }
| e = term_r
    { e }

simple_exp:
| e = located(nofail(simple_exp_r))
    { e }

%inline binop:
| EQEQUALS { "(==)" }
| LT   { "(<)" }
| GT   { "(>)" }
| LTE  { "(<=)" }
| GTE  { "(>=)" }
| PLUS     { "(+)" }
| MINUS    { "(-)" }

tag: DOT; t = IDENT { t }

term_r:
| IF; cond = simple_exp; THEN; tcase = block; ELSE; fcase = block; END
    { If (cond, tcase, fcase) }
(*| MATCH; e = simple_exp; WITH; onl;
    LBRACK; RBRACK; ARROW; onl; n = lambda_exp; onl;
    OR; x = IDENT; CONS; xs = IDENT; ARROW; onl; c = lambda_exp; onl; END
    { Match (e, n, x, xs, c) }*)
| MATCH; e = separated_nonempty_list(COMMA, simple_exp); snl; c = nonempty_list(case); END
    { Match (e, c) }
| v = IDENT 
    { Var v }
| LPAR; e = lambda_exp_r; RPAR
    { e }
| LPAR; e = lambda_exp; COLON; t = typeterm; RPAR
    { Typed (e, t) }
| f = term; LPAR; x = separated_list(COMMA, located(argument)); RPAR
    { App (f, x) }
| LPAR; RPAR
    { Unit }
| LBRACK; RBRACK
    { Nil }
| LBRACK; e = nonemptylist_r; RBRACK
    { e }
| e = term; DOT; f = IDENT
    { GetField (e, f) }
| i = INT
    { Int i }
| t = tag
    { Object (Some t, []) }
| t = tag; LBRACE; o = separated_list(COMMA, objfield(lambda_exp)); RBRACE
    { Object (Some t, o) }
| LBRACE; o = separated_list(COMMA, objfield(lambda_exp)); RBRACE
    { Object (None, o) }
| TRUE
    { Bool true }
| FALSE
    { Bool false }

term:
| t = located(nofail(term_r))
    { t }

%inline objfield(body):
| v = IDENT; EQUALS
    { v, (L.pos ($startpos(v), $endpos(v)), Some (Var v)) }
| v = IDENT; EQUALS; e = body
    { v, e }


%inline objfield_pat(body):
| v = IDENT; EQUALS
    { v, (L.pos ($startpos(v), $endpos(v)), Some (PVar v)) }
| v = IDENT; EQUALS; e = body
    { v, e }


nonemptylist_r:
| x = lambda_exp
    { Cons(x, (let (l, _) = x in l, Some Nil)) }
| x = lambda_exp; COMMA; xs = nonemptylist
    { Cons(x, xs) }

%inline nonemptylist:
| e = located(nofail(nonemptylist_r))
    { e }

(* Pattern matching *)

pat_r:
| UNDER
    { PWildcard }
| v = IDENT
    { PVar v }
| t = tag
    { PObject(Some t, []) }
| t = tag; LBRACE; o = separated_list(COMMA, objfield_pat(pat)); RBRACE
    { PObject(Some t, o) }
| LBRACE; o = separated_list(COMMA, objfield_pat(pat)); RBRACE
    { PObject(None, o) }
| p1 = pat; OR; p2 = pat
    { PAlt (p1, p2) }
| LPAR; p = pat_r; RPAR
    { p }
| n = INT
    { PInt n }

pat:
| p = located(nofail(pat_r)) { p }

case_r: (* what's a good syntax here? snl for onl? *)
| p = separated_nonempty_list(COMMA, pat); 
    { p }

case: CASE; ps = located(case_r); snl; e = lambda_exp; snl { ps, e }

subsumption:
| t1 = typeterm; SUBSUME; t2 = typeterm; EOF { (t1, t2) }

onlytype:
| t = typeterm; EOF { t }

variance:
| PLUS { VPos }
| MINUS { VNeg }
| PLUS; MINUS { VNegPos }
| MINUS; PLUS { VNegPos }

typearg:
| PLUS; t = typeterm { VarSpec (APos t) }
| MINUS; t = typeterm { VarSpec (ANeg t) }
| MINUS; s = typeterm; PLUS; t = typeterm
| PLUS; t = typeterm; MINUS; s = typeterm { VarSpec (ANegPos (s, t)) }
| t = typeterm { VarUnspec t }

typeparam:
| v = option(variance); x = IDENT { TParam (v, x) }
| UNDER { TNoParam }

objtype:
| v = IDENT; COLON; t = typeterm
   { (v, fun _ -> t) }

(* FIXME: detect duplicate parameters *)
funtype:
| RPAR; { [] }
| t = typeterm; COMMA; ts = funtype { (None, t) ::  ts }
| t = typeterm; RPAR { [None, t] }
| v = IDENT; COLON; t = typeterm; COMMA; ts = funtype { (Some v, t) :: ts }
| v = IDENT; COLON; t = typeterm; RPAR { [Some v, t] }

typeterm:
| v = IDENT; LBRACK; ps = separated_nonempty_list(COMMA, typearg); RBRACK
     { TNamed (v, ps) }
| v = IDENT
     { TNamed (v, []) }
(* funtype includes its closing paren as a hack to avoid a conflict *)
| LPAR; ts = funtype; ARROW; tr = typeterm 
    { TCons (ty_fun
        (ts |> List.filter (function (None, _) -> true | _ -> false) |> List.map (fun (_, t) -> fun _ -> t))
        (ts |> List.fold_left (fun s (v, t) -> match v with Some v -> Typector.SMap.add v ((fun _ -> t), true) s | None -> s) Typector.SMap.empty)
        (fun _ -> tr)
        (L.pos ($startpos, $endpos))) }
| ANY { TZero Neg }
| NOTHING { TZero Pos }
| LBRACE; o = separated_list(COMMA, objtype); RBRACE 
  { TCons (ty_obj_l o (L.pos ($startpos, $endpos))) }
| t1 = typeterm; p = meetjoin; t2 = typeterm { TAdd (p, t1, t2)  } %prec AND
| REC; v = IDENT; EQUALS; t = typeterm { TRec (v, t) }
| UNDER { TWildcard }
| LPAR; t = typeterm; RPAR { t }

%inline meetjoin : AND { Variance.Neg } | OR { Variance.Pos }
