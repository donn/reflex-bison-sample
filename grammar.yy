%language "C++"
%locations

%define parser_class_name {Parser}
%define api.namespace {Project}

%define api.value.type {double}

%code requires {
    namespace Project {
        class Lexer;
    }

    struct Context {
        int trace = 0;
        double result = 0;
    };
}

%{
    #include "tokens.l.hh"
    #include <iostream>

    #undef yylex
    #define yylex lexer->yylex
%}

%parse-param { Project::Lexer* lexer } { Context* context }

%token NUMERIC

%left '+' '-'
%left '*' '/'
%left UNARY

%initial-action {
#if YYDEBUG
    this->set_debug_level(context->trace);
#endif
}

%%

top:
    expression {
        $$ = $1;
        context->result = $$;
    }
    ;

expression:
    '(' expression ')' {
        $$ = $2;
    }
    | expression '+' expression {
        $$ = $1 + $3;
    }
    | expression '-' expression {
        $$ = $1 - $3;
    }
    | expression '*' expression {
        $$ = $1 * $3;
    }
    | expression '/' expression {
        $$ = $1 / $3;
    }
    | NUMERIC {
        $$ = $1;
    }
    ;

%%