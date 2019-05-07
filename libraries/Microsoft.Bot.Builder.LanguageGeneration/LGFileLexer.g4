lexer grammar LGFileLexer;

// From a multiple-lanague perpective, it's not recommended to use members, predicates and actions to 
// put target-language-specific code in lexer rules 

// the reason we use it here is that
// 1. it greatly simplify the lexer rules, can avoid unnecessary lexer modes 
// 2. it helps us to output token more precisely
//    (for example, 'CASE:' not followed right after '-' will not be treated as a CASE token)
// 3. we only use very basic boolen variables, and basic predidates
//    so it would be very little effort to translate to other languages

@lexer::members {
  bool ignoreWS = true;      // usually we ignore whitespace, but inside template, whitespace is significant
  bool expectIfElse = false; // whether we are expecting IF/ELSEIF/ELSE
}

fragment LETTER: 'a'..'z' | 'A'..'Z';
fragment NUMBER: '0'..'9';

fragment WHITESPACE
  : ' '|'\t'|'\ufeff'|'\u00a0'
  ;

COMMENTS
  : ('>'|'$') ~('\r'|'\n')+ -> skip
  ;

WS
  : WHITESPACE+ -> skip
  ;

NEWLINE
  : '\r'? '\n' -> skip
  ;

HASH
  : '#' -> pushMode(TEMPLATE_NAME_MODE)
  ;

DASH
  : '-' {expectIfElse = true;} -> pushMode(TEMPLATE_BODY_MODE)
  ;

INVALID_TOKEN_DEFAULT_MODE
  : .
  ;

mode TEMPLATE_NAME_MODE;

WS_IN_NAME
  : WHITESPACE+ -> skip
  ;

NEWLINE_IN_NAME
  : '\r'? '\n' -> type(NEWLINE), popMode
  ;

IDENTIFIER
  : (LETTER | NUMBER | '_') (LETTER | NUMBER | '-' | '_')*
  ;

DOT
  : '.'
  ;

OPEN_PARENTHESIS
  : '('
  ;

CLOSE_PARENTHESIS
  : ')'
  ;

COMMA
  : ','
  ;

INVALID_SEPERATE_CHAR
  : [;]
  ;

mode TEMPLATE_BODY_MODE;

// a little tedious on the rules, a big improvement on portability
WS_IN_BODY_IGNORED
  : WHITESPACE+  {ignoreWS}? -> skip
  ;

WS_IN_BODY
  : WHITESPACE+  -> type(WS)
  ;

NEWLINE_IN_BODY
  : '\r'? '\n' {ignoreWS = true;} -> type(NEWLINE), popMode
  ;

IF
  : ('if'|'IF') WHITESPACE* ':'  {expectIfElse}? { ignoreWS = true;}
  ;

ELSEIF
  : ('elseif'|'ELSEIF') WHITESPACE* ':' {expectIfElse}? { ignoreWS = true;}
  ;

ELSE
  : ('else'|'ELSE') WHITESPACE* ':' {expectIfElse}? { ignoreWS = true;}
  ;

MULTI_LINE_TEXT
  : '```' .*? '```' { ignoreWS = false; expectIfElse = false;}
  ;

ESCAPE_CHARACTER
  : '\\{' | '\\[' | '\\\\' | '\\'[rtn\]}]  { ignoreWS = false; expectIfElse = false;}
  ;

INVALID_ESCAPE
  : '\\'~[\r\n]?
  ;

EXPRESSION
  : '{' (~[\r\n{}] | ESCAPE_CHARACTER)* '}'  { ignoreWS = false; expectIfElse = false;}
  ;

TEMPLATE_REF
  : '[' (~[\r\n\]] | TEMPLATE_REF)* ']'  { ignoreWS = false; expectIfElse = false;}
  ;

TEXT_SEPARATOR
  : [ \t\r\n{}[\]()]  { ignoreWS = false; expectIfElse = false;}
  ;

TEXT
  : ~[ \\\t\r\n{}[\]()]+  { ignoreWS = false; expectIfElse = false;}
  ;