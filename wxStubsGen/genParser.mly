%{
open GenTypes

let new_class class_name class_inherit class_methods =
  let class_uname = String.capitalize class_name in

  let class_parents = StringMap.empty in
  let class_children = StringMap.empty in
  {
    class_name;
    class_uname;
    class_inherit;
    class_methods;
    class_parents;
    class_children;
  }

let default_options = { fopt_gen_cpp = true; fopt_others = () }

%}


%token EOF

%token <string>STRING
%token <string> IDENT

%token LBRACE
%token RBRACE
%token LPAREN
%token RPAREN
%token LBRACKET
%token RBRACKET
%token COMMA
%token STAR
%token AMPERSAND
%token UNDERSCORE
%token QUESTION
%token EQUAL
%token LESSMINUS
%token LESSGREATER

%token BEGIN
%token END
%token INCLUDE
%token CLASS
%token INHERIT
%token NEW
%token METHOD
%token TRUE
%token FALSE
%token GEN_CPP
%token FUNCTION

%start file
%type <GenTypes.file> file

%%

file: components EOF { $1 };

components:
          { [] }
| component components { $1 :: $2 }
;

component:
  | INCLUDE STRING                          { Comp_include $2 }
  | CLASS IDENT ancestors BEGIN methods END { Comp_class (new_class  $2 $3 $5) }
;

ancestors:
  { [] }
| INHERIT IDENT ancestors { $2 :: $3 }
;

methods:
  { [] }
| meth methods { $1 :: $2 }
;

/* For Mantis: using "method" as a rule name triggers a weird error.
      There should be some substitution done for keywords in ocamlyacc, no ? */
meth:
| NEW options_maybe LPAREN genident maybe_mlname RPAREN LPAREN arguments RPAREN
  {
    { proto_kind = ProtoNew;
      proto_ret = None;
      proto_name = $4;
      proto_mlname = $5;
      proto_args = $8;
      proto_options = $2;
    }
  }
| METHOD options_maybe LPAREN ctype COMMA genident maybe_mlname RPAREN LPAREN arguments RPAREN
  {
    { proto_kind = ProtoMethod;
      proto_ret = Some $4;
      proto_name = $6;
      proto_mlname = $7;
      proto_args = $10;
      proto_options = $2;
    }
  }
| FUNCTION options_maybe LPAREN ctype COMMA genident maybe_mlname RPAREN LPAREN arguments RPAREN
  {
    { proto_kind = ProtoFunction;
      proto_ret = Some $4;
      proto_name = $6;
      proto_mlname = $7;
      proto_args = $10;
      proto_options = $2;
    }
  }
;

options_maybe:
                          { default_options }
| LBRACE options RBRACE { $2 }
;

bool:
  TRUE   { true }
| FALSE  { false }
;

options:
                             { default_options }
| GEN_CPP EQUAL bool options {  { $4 with fopt_gen_cpp = $3 } }
;

maybe_mlname:
                 { None }
| COMMA genident { Some $2 }
;

ctype:
  | ctype STAR { Typ_pointer $1 }
  | genident { Typ_ident $1 }
  | ctype AMPERSAND { Typ_reference $1 }
  | ctype QUESTION { Typ_option $1 }
  | UNDERSCORE { Typ_direct }
  | ctype LBRACKET RBRACKET { Typ_array ($1, None) }
;

arguments:
  { [] }
| argument more_arguments { $1 :: $2 }
;

more_arguments:
  { [] }
| COMMA argument more_arguments { $2 :: $3 }
;

argument:
  maybe_ocaml UNDERSCORE STRING
    { { arg_name = $3; arg_ctype = Typ_direct; arg_direction = In;
        arg_ocaml = $1 } }
| maybe_ocaml ctype maybe_direction genident
    { { arg_ocaml = $1; arg_ctype = $2; arg_direction = $3; arg_name = $4; } }
;

maybe_ocaml:
|             { None }
| STRING      { Some $1 }
;

maybe_direction:
  { In }
| LESSMINUS { Out }
/* | LESSGREATER { InOut } */
;

/* We want to accept idents that are keywords */
genident:
  IDENT { $1 }
| INCLUDE { "include" }
| BEGIN   { "begin" }
| END     { "end" }
| CLASS   { "class" }
| INHERIT { "inherit" }
| NEW     { "new" }
| METHOD  { "method" }
| GEN_CPP   { "gen_cpp" }
| TRUE    { "true" }
| FALSE   { "false" }
| FUNCTION { "function" }
;

