%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "y.tab.h"

%}

keywords    "for"|"do"|"while"|"break"|"continue"|"if"|"else"|"return"|"struct"|"switch"|"case"|"default"|"void"|"int"|"double"|"float"|"char"|"const"|"signed"|"unsigned"|"short"|"long"
macros      "NULL"|"__COUNTER__"|"__LINE__"|"INT_MAX"|"INT_MIN"|"CHAR_MAX"|"CHAR_MIN"|"MAX"|"MIN"
operators   "+"|"-"|"*"|"/"|"%"|"++"|"--"|"<"|"<="|">"|">="|"=="|"!="|"="|"&&"|"||"|"!"|"&"|"|"
punc        ":"|";"|","|"."|"["|"]"|"("|")"|"{"|"}"
escape      "\a"|"\b"|"\e"|"\f"|"\n"|"\r"|"\t"|"\v"|"\\"|"\'"|"\""|"\?"
space       " "|"\t"

%x COMMENT
%x SHORTCOMMENT

%%

\n                                                  {}
{space}                                             {}
"void"                                              {yylval.sval = strdup(yytext); return TYPE_VOID;}
"int"                                               {yylval.sval = strdup(yytext); return TYPE_INT;}
"double"                                            {yylval.sval = strdup(yytext); return TYPE_DOUBLE;}
"float"                                             {yylval.sval = strdup(yytext); return TYPE_FLOAT;}
"char"                                              {yylval.sval = strdup(yytext); return TYPE_CHAR;}
"const"                                             {yylval.sval = strdup(yytext); return TYPE_CONST;}
"signed"|"unsigned"									{yylval.sval = strdup(yytext); return TYPE_SIGNED;}
"long"|"short"										{yylval.sval = strdup(yytext); return TYPE_LENGTH;}
"="                                                 {return ASSIGN;}
","                                                 {return COMMA;}
":"                                                 {return COLON;}
[0-9]+                                              {yylval.ival = atoi(yytext); return INT;}
([0-9]*"."[0-9]+)|([0-9]+"."[0-9]*)                 {yylval.dval = atof(yytext); return DOUBLE;}
[\"](\\.|[^\n\"\\])*[\"]                            {yylval.sval = strdup(yytext); return CHAR;}
[\'](\\.|[^\n\'\\])*[\']                            {yylval.sval = strdup(yytext); return CHAR;}
"NULL"                                              {yylval.ival = 0; return INT;}
"if"                                                {return IF;}
"else"                                              {return ELSE;}
"switch"                                            {return SWITCH;}
"case"                                              {return CASE;}
"default"                                           {return DEFAULT;}
"do"                                                {return DO;}
"while"                                             {return WHILE;}
"for"                                               {return FOR;}
"return"                                            {return RETURN;}
"break"                                             {return BREAK;}
"continue"                                          {return CONTINUE;}
"<"                                                 {return LESS;}
"<="                                                {return LESS_EQUAL;}
">"                                                 {return GREATER;}
">="                                                {return GREATER_EQUAL;}
"=="                                                {return EQUAL;}
"!="                                                {return NOT_EQUAL;}
"+"                                                 {return PLUS;}
"-"                                                 {return MINUS;}
"++"                                                {return INCREMENT;}
"--"                                                {return DECREMENT;}
"!"                                                 {return NOT;}
"~" 												{ return BITWISE_NOT; }
"*"                                                 {return MULTIPLY;}
"/"                                                 {return DIVIDE;}
"%"                                                 {return MODULO;}
"&&"                                                {return AND;}
"||"                                                {return OR;}
"&"                                                 {return OP_AND;}
"|"                                                 {return OP_OR;}
"^" 												{ return OP_XOR; }
"<<" 												{ return SHIFT_LEFT; }
">>" 												{ return SHIFT_RIGHT; }
"("                                                 {return L_BRACKET;}
")"                                                 {return R_BRACKET;}
"["                                                 {return L_SQR_BRACKET;}
"]"                                                 {return R_SQR_BRACKET;}
"{"                                                 {return L_PARENTHESIS;}
"}"                                                 {return R_PARENTHESIS;}
";"                                                 {return SEMICOLON;}
(_|[a-zA-Z])(_|[a-zA-Z]|[0-9])*                     {yylval.sval = strdup(yytext); return ID;}
<SHORTCOMMENT>"\\\n"                                {}
"//"                                                {BEGIN SHORTCOMMENT;}
<SHORTCOMMENT>\n                                    {BEGIN 0;}
<SHORTCOMMENT>.					                    {}                                                    
"/*"                                                {BEGIN COMMENT;}
<COMMENT>"*/"                                       {BEGIN 0;}
<COMMENT>.					                        {}
<COMMENT>\n                                         {}

%%

