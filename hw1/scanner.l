%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <stdbool.h>
    
    char* inputtext  = "";
    int inputsize = 0;
    int num_lines = 1;
    bool pragma_source = true;
    bool pragma_token = true;

    void concatyytoinput(char* yy) {
        int newSize = inputsize + yyleng + 1;
        char* newBuffer = (char*)malloc(newSize);
        strcpy(newBuffer,inputtext);
        strcat(newBuffer,yy);
        inputtext = newBuffer;
        inputsize = newSize;
    }
%}

keywords    "for"|"do"|"while"|"break"|"continue"|"if"|"else"|"return"|"struct"|"switch"|"case"|"default"|"void"|"int"|"double"|"float"|"char"|"const"|"signed"|"unsigned"|"short"|"long"
macros      "NULL"|"__COUNTER__"|"__LINE__"|"INT_MAX"|"INT_MIN"|"CHAR_MAX"|"CHAR_MIN"|"MAX"|"MIN"
operators   "+"|"-"|"*"|"/"|"%"|"++"|"--"|"<"|"<="|">"|">="|"=="|"!="|"="|"&&"|"||"|"!"|"&"|"|"
punc        ":"|";"|","|"."|"["|"]"|"("|")"|"{"|"}"
escape      "\a"|"\b"|"\e"|"\f"|"\n"|"\r"|"\t"|"\v"|"\\"|"\'"|"\""|"\?"
space       " "|"\t"

%x COMMENT
%x SHORTCOMMENT
%x CHAR
%x STRING

%%

#pragma(" "|"\t")+source(" "|"\t")+on(" "|"\t")*    {   
                                                        pragma_source = true;
                                                        concatyytoinput(yytext);
                                                    }

#pragma(" "|"\t")+source(" "|"\t")+off(" "|"\t")*   {
                                                        pragma_source = false; 
                                                        concatyytoinput(yytext);
                                                    }

#pragma(" "|"\t")+token(" "|"\t")+on(" "|"\t")*     {
                                                        pragma_token = true; 
                                                        concatyytoinput(yytext);
                                                    }

#pragma(" "|"\t")+token(" "|"\t")+off(" "|"\t")*    {   
                                                        pragma_token = false;
                                                        concatyytoinput(yytext);
                                                    }


{keywords}                                          {
                                                        if (pragma_token) {   
                                                            printf("#key:%s\n", yytext);
                                                        }
                                                        concatyytoinput(yytext);
                                                    }

{macros}                                            {
                                                        if (pragma_token) {   
                                                            printf("#macro:%s\n", yytext);
                                                        }
                                                        concatyytoinput(yytext);
                                                    }

{operators}                                         {
                                                        if (pragma_token) {
                                                            printf("#op:%s\n", yytext);
                                                        } 
                                                        concatyytoinput(yytext);
                                                    }

{punc}                                              {
                                                        if (pragma_token) {
                                                            printf("#punc:%s\n", yytext);
                                                        } 
                                                        concatyytoinput(yytext);
                                                    }

(_|[[:alpha:]])+(_|[[:alnum:]])*                    {
                                                        if (pragma_token) {
                                                            printf("#id:%s\n", yytext);
                                                        } 
                                                        concatyytoinput(yytext);
                                                    }

[+-]?[[:digit:]]+                                   {
                                                        if (pragma_token) {
                                                            printf("#integer:%s\n", yytext);
                                                        } 
                                                        concatyytoinput(yytext);
                                                    }

[+-]?("."[[:digit:]]+|[[:digit:]]+"."|[[:digit:]]+"."[[:digit:]]+)  {
                                                        if (pragma_token) {
                                                            printf("#float:%s\n", yytext);
                                                        } 
                                                        concatyytoinput(yytext);
                                                    }

" "                                                 {
                                                        concatyytoinput(yytext);
                                                    }

"\t"                                                {
                                                        concatyytoinput(yytext);
                                                    }

\n                                                  {
                                                        if (pragma_source) {
                                                            printf("%d:%s\n", num_lines, inputtext);
                                                        }
                                                        inputtext = "";
                                                        inputsize = 0;
                                                        num_lines++;
                                                    }

\'(\\[[:digit:]]+|\\a|\\b|\\e|\\f|\\n|\\r|\\t|\\v|\\\\|\\\'|\\\"|\\\?|\\012|\\U01234567|\\xC0|\\u00C0|\\xC0|\\u00C0|\\x12|\\x1234|[^\n'\\])\'   {
                                                        if (pragma_token) {
                                                        printf("#char:%s\n", yytext);
                                                        } 
                                                        concatyytoinput(yytext);
                                                    }

\"(\\[[:digit:]]+|\\a|\\b|\\e|\\f|\\n|\\r|\\t|\\v|\\\\|\\\'|\\\"|\\\?|\\012|\\U01234567|\\xC0|\\u00C0|\\xC0|\\u00C0|\\x12|\\x1234|[^\n"])*\"  {
                                                        if (pragma_token) {
                                                        printf("#string:%s\n", yytext);
                                                        } 
                                                        concatyytoinput(yytext);
                                                    }


<SHORTCOMMENT>"\\\n"                              {
                                                        if (pragma_source) {
                                                            printf("%d:%s\\\n", num_lines, inputtext);
                                                        }
                                                        inputtext = "";
                                                        inputsize = 0;
                                                        num_lines++;
                                                    }

"//".                                               {
                                                        concatyytoinput(yytext);
                                                        BEGIN SHORTCOMMENT;
                                                    }

<SHORTCOMMENT>\n                                    {
                                                        if (pragma_source) {
                                                            printf("%d:%s\n", num_lines, inputtext);
                                                        }
                                                        inputtext = "";
                                                        inputsize = 0;
                                                        num_lines++;
                                                        BEGIN 0;
                                                    }

<SHORTCOMMENT>.					                    {
                                                        concatyytoinput(yytext);
                                                    }                                                    

"/*"                                                {
                                                        concatyytoinput(yytext); 
                                                        BEGIN COMMENT;
                                                    }

<COMMENT>"*/"                                       {
                                                        concatyytoinput(yytext);
                                                        BEGIN 0;
                                                    }

<COMMENT>.					                        {
                                                        concatyytoinput(yytext);
                                                    }

<COMMENT>\n                                         {   
                                                        if (pragma_source) {
                                                            printf("%d:%s\n", num_lines, inputtext);
                                                        }
                                                        inputtext = "";
                                                        inputsize = 0;
                                                        num_lines++;
                                                    }

%%

int main() {
    yylex();

    return 0;
}
