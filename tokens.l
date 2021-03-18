%option flex
%option unicode 
%option namespace=Project 
%option lexer=Lexer
%option bison-cc
%option bison-locations
%option bison-cc-namespace=Project
%option bison-cc-parser=Parser 

%top {
    #include "grammar.yy.hh"
%}

%%

[ \t\r]+ {
    // Ignore whitespace
}

[0-9]+(\.[0-9]+)? {
    yylval = std::stod(yytext);
    return Parser::token::NUMERIC;
}

[+-/*\(\)] {
    return yytext[0];
}

%%