%{

#include <stdio.h>
#include <stdlib.h>


char* _PLUS = "+";
char* _MINUS = "-";
char* _MULTIPLY = "*";
char* _DIVIDE = "/";
char* _MODULO = "%";
char* _INCREMENT = "++";
char* _DECREMENT = "--";
char* _NOT = "!";
char* _BITWISE_NOT = "~";
char* _LESS = "<";
char* _LESS_EQUAL = "<=";
char* _GREATER = ">";
char* _GREATER_EQUAL = ">=";
char* _SHIFT_LEFT = "<<";
char* _SHIFT_RIGHT = ">>";
char* _EQUAL = "==";
char* _NOT_EQUAL = "!=";
char* _ASSIGN = "=";
char* _AND = "&&";
char* _OR = "||";
char* _OP_AND = "&";
char* _OP_OR = "|";
char* _OP_XOR = "^";
char* _COLON = ":";
char* _SEMICOLON = ";";
char* _COMMA = ",";
char* _L_BRACKET = "(";
char* _R_BRACKET = ")";
char* _L_SQR_BRACKET = "[";
char* _R_SQR_BRACKET = "]";
char* _L_PARENTHESIS = "{";
char* _R_PARENTHESIS = "}";
char* _CONST = "const";
char* _IF = "if";
char* _ELSE = "else";
char* _SWITCH = "switch";
char* _CASE = "case";
char* _DEFAULT = "default";
char* _FOR = "for";
char* _WHILE = "while";
char* _DO = "do";
char* _RETURN = "return";
char* _BREAK = "break";
char* _CONTINUE = "continue";
char* _OPEN_SCALAR = "<scalar_decl>";
char* _CLOSE_SCALAR = "</scalar_decl>";
char* _OPEN_ARRAY = "<array_decl>";
char* _CLOSE_ARRAY = "</array_decl>";
char* _OPEN_CONST = "<const_decl>";
char* _CLOSE_CONST = "</const_decl>";
char* _OPEN_FUNC = "<func_decl>";
char* _CLOSE_FUNC = "</func_decl>";
char* _OPEN_DEF = "<func_def>";
char* _CLOSE_DEF = "</func_def>";
char* _OPEN_EXPR = "<expr>";
char* _CLOSE_EXPR = "</expr>";
char* _OPEN_STMT = "<stmt>";
char* _CLOSE_STMT = "</stmt>";

char* int2string(int x) {
    int y = x;
    int l = 1;
    while (y > 9) {
        y /= 10;
        l++;
    }
    char* t = (char*)malloc(sizeof(char) * l);
    sprintf(t, "%d", x);
    return t;
}


char* double2string(double f) {
    char *new_str = (char*)malloc(sizeof(char) * 33);
    sprintf(new_str, "%f", f);
    return new_str;
}


%}

%union {
    int ival;
    double dval;
    char* sval;
}

%token <sval> TYPE_VOID TYPE_INT TYPE_DOUBLE TYPE_FLOAT TYPE_CHAR TYPE_CONST TYPE_SIGNED TYPE_LENGTH
%token PLUS MINUS MULTIPLY DIVIDE MODULO
%token INCREMENT DECREMENT NOT BITWISE_NOT
%token LESS LESS_EQUAL GREATER GREATER_EQUAL EQUAL NOT_EQUAL ASSIGN
%token AND OR OP_AND OP_OR OP_XOR
%token COLON SEMICOLON COMMA
%token L_BRACKET R_BRACKET L_SQR_BRACKET R_SQR_BRACKET L_PARENTHESIS R_PARENTHESIS
%token FOR DO WHILE IF ELSE SWITCH RETURN BREAK CONTINUE CASE DEFAULT
%token <sval> SHIFT_LEFT SHIFT_RIGHT

%token <sval> ID
%token <sval> CHAR
%token <ival> INT
%token <dval> DOUBLE

%type <sval> def_dec_recursive
%type <sval> declaration_and_definition
%type <sval> declaration function_definition function_declaration
%type <sval> scalar_declaration scalar_recursive scalar
%type <sval> array_declaration array_recursive array array_bracket_recursive array_bracket array_value array_expression

%type <sval> statement_recursive statement compound_statement
%type <sval> if_else_statement switch_statement switch_clause_recursive switch_clause while_statement for_statement return_statement empty_expression

%type <sval> type const sign length not_int othertype
%type <sval> parameter_recursive parameter arguments

%type <sval> assign_expression or_expression and_expression or_op_expression xor_op_expression and_op_expression 
%type <sval> equal_expression compare_expression shift_expression add_minus_expression term_expression prefix_expression postfix_expression 
%type <sval> expression_end


%nonassoc UMINUS UADD UMULTI UANDOP
%nonassoc INCPOST DECPOST

%start program

%%

program:                        def_dec_recursive {printf("%s", $1);};


def_dec_recursive:              /* empty */ {$$ = "";}
                                | def_dec_recursive declaration_and_definition {
                                char* s = malloc(sizeof(char) * (1 + strlen($1) + strlen($2)));
                                strcpy(s, $1);
                                strcat(s, $2);
                                $$ = s;
                                };

declaration_and_definition:     function_definition {$$ = $1;}
                                | declaration {$$ = $1;};

declaration:                    function_declaration {$$ = $1;}
                                | scalar_declaration {$$ = $1;}
                                | array_declaration {$$ = $1;};


function_definition:            type ID L_BRACKET parameter_recursive R_BRACKET compound_statement {
                                char* s = malloc(sizeof(char) * (1 + strlen(_OPEN_DEF) + strlen($1) + strlen($2) + strlen($4) + strlen(_L_BRACKET) + strlen($6) + strlen(_R_BRACKET) + strlen(_CLOSE_DEF)));
                                strcpy(s, _OPEN_DEF);
                                strcat(s, $1);
                                strcat(s, $2);
                                strcat(s, _L_BRACKET);
                                strcat(s, $4);
                                strcat(s, _R_BRACKET);
                                strcat(s, $6);
                                strcat(s, _CLOSE_DEF);
                                $$ = s;
                                };
                                | type MULTIPLY ID L_BRACKET parameter_recursive R_BRACKET compound_statement {
                                char* s = malloc(sizeof(char) * (1 + strlen(_OPEN_DEF) + strlen($1) + 1 + strlen($3) + strlen($5) + strlen(_L_BRACKET) + strlen($7) + strlen(_R_BRACKET) + strlen(_CLOSE_DEF)));
                                strcpy(s, _OPEN_DEF);
                                strcat(s, $1);
                                strcat(s, _MULTIPLY);
                                strcat(s, $3);
                                strcat(s, _L_BRACKET);
                                strcat(s, $5);
                                strcat(s, _R_BRACKET);
                                strcat(s, $7);
                                strcat(s, _CLOSE_DEF);
                                $$ = s;
                                };


function_declaration:           type ID L_BRACKET parameter_recursive R_BRACKET SEMICOLON {
                                char* s = malloc(sizeof(char) * (1 + strlen(_OPEN_FUNC) + strlen($1) + strlen($2) +  strlen(_L_BRACKET) + strlen($4) + strlen(_R_BRACKET)  + strlen(_SEMICOLON) + strlen(_CLOSE_FUNC)));
                                strcpy(s, _OPEN_FUNC);
                                strcat(s, $1);
                                strcat(s, $2);
                                strcat(s, _L_BRACKET);
                                strcat(s, $4);
                                strcat(s, _R_BRACKET);
                                strcat(s, _SEMICOLON);
                                strcat(s, _CLOSE_FUNC);
                                $$ = s;
                                };
                                | type MULTIPLY ID L_BRACKET parameter_recursive R_BRACKET SEMICOLON {
                                char* s = malloc(sizeof(char) * (1 + strlen(_OPEN_FUNC) + strlen($1) + strlen(_MULTIPLY) + strlen($3) +  strlen(_L_BRACKET) + strlen($5) + strlen(_R_BRACKET)  + strlen(_SEMICOLON) + strlen(_CLOSE_FUNC)));
                                strcpy(s, _OPEN_FUNC);
                                strcat(s, $1);
                                strcat(s, _MULTIPLY);
                                strcat(s, $3);
                                strcat(s, _L_BRACKET);
                                strcat(s, $5);
                                strcat(s, _R_BRACKET);
                                strcat(s, _SEMICOLON);
                                strcat(s, _CLOSE_FUNC);
                                $$ = s;
                                };


scalar_declaration:             type scalar_recursive SEMICOLON {
                                char* s = malloc(sizeof(char) * (1 + strlen(_OPEN_SCALAR) + strlen($1) + strlen($2) + strlen(_SEMICOLON) + strlen(_CLOSE_SCALAR)));
                                strcpy(s, _OPEN_SCALAR);
                                strcat(s, $1);
                                strcat(s, $2);
                                strcat(s, _SEMICOLON);
                                strcat(s, _CLOSE_SCALAR);
                                $$ = s;
                                };


scalar_recursive:               scalar {$$ = $1;}
                                | scalar_recursive COMMA scalar {
                                char* s = malloc(sizeof(char) * (1 + strlen($1) + strlen(_COMMA) + strlen($3)));
                                strcpy(s, $1);
                                strcat(s, _COMMA);
                                strcat(s, $3);
                                $$ = s;
                                };


scalar:                         ID ASSIGN assign_expression {
                                char* s = malloc(sizeof(char) * (1 + strlen($1) + strlen(_ASSIGN) + strlen($3)));
                                strcpy(s, $1);
                                strcat(s, _ASSIGN);
                                strcat(s, $3);
                                $$ = s;
                                }
                                | ID {$$ = $1;}
                                | MULTIPLY ID ASSIGN assign_expression {
                                char* s = malloc(sizeof(char) * (1 + strlen(_MULTIPLY) + strlen($2) + strlen(_ASSIGN) + strlen($4)));
                                strcpy(s, _MULTIPLY);
                                strcat(s, $2);
                                strcat(s, _ASSIGN);
                                strcat(s, $4);
                                $$ = s;
                                }
                                | MULTIPLY ID {
                                char* s = malloc(sizeof(char) * (1 + strlen(_MULTIPLY) + strlen($2)));
                                strcpy(s, _MULTIPLY);
                                strcat(s, $2);
                                $$ = s;
                                };

array_declaration:              type array_recursive SEMICOLON {
                                char* s = malloc(sizeof(char) * (1 + strlen(_OPEN_ARRAY) + strlen($1) + strlen($2) + strlen(_SEMICOLON) + strlen(_CLOSE_ARRAY)));
                                strcpy(s, _OPEN_ARRAY);
                                strcat(s, $1);
                                strcat(s, $2);
                                strcat(s, _SEMICOLON);
                                strcat(s, _CLOSE_ARRAY);
                                $$ = s;
                                };


array_recursive:                array {$$ = $1;}
                                | array_recursive COMMA array {
                                char* s = malloc(sizeof(char) * (1 + strlen($1) + strlen(_COMMA) + strlen($3)));
                                strcpy(s, $1);
                                strcat(s, _COMMA);
                                strcat(s, $3);
                                $$ = s;
                                };


array:                          ID array_bracket_recursive array_value {
                                char* s = malloc(sizeof(char) * (1 + strlen($1) + strlen($2)+ strlen($3)));
                                strcpy(s, $1);
                                strcat(s, $2);
                                strcat(s, $3);
                                $$ = s;
                                };


array_bracket_recursive:        array_bracket {$$ = $1;}
                                | array_bracket_recursive array_bracket {
                                char* s = malloc(sizeof(char) * (1 + strlen($1) + strlen($2)));
                                strcpy(s, $1);
                                strcat(s, $2);
                                $$ = s;
                                };


array_bracket:                  L_SQR_BRACKET assign_expression R_SQR_BRACKET {
                                char* s = malloc(sizeof(char) * (1 + strlen(_L_SQR_BRACKET) + strlen($2) + strlen(_R_SQR_BRACKET)));
                                strcpy(s, _L_SQR_BRACKET);
                                strcat(s, $2);
                                strcat(s, _R_SQR_BRACKET);
                                $$ = s;
                                };


array_value:                    /* empty */ {$$ = "";}
                                | ASSIGN L_PARENTHESIS array_expression R_PARENTHESIS {
                                char* s = malloc(sizeof(char) * (1 + strlen(_ASSIGN) + strlen(_L_PARENTHESIS) + strlen($3) + strlen(_R_PARENTHESIS)));
                                strcpy(s, _ASSIGN);
                                strcat(s, _L_PARENTHESIS);
                                strcat(s, $3);
                                strcat(s, _R_PARENTHESIS);
                                $$ = s;
                                };


array_expression:               L_PARENTHESIS array_expression R_PARENTHESIS {
                                char* s = malloc(sizeof(char) * (1 + strlen(_L_PARENTHESIS) + strlen($2) + strlen(_R_PARENTHESIS)));
                                strcpy(s, _L_PARENTHESIS);
                                strcat(s, $2);
                                strcat(s, _R_PARENTHESIS);
                                $$ = s;
                                }
                                | array_expression COMMA L_PARENTHESIS array_expression R_PARENTHESIS {
                                char* s = malloc(sizeof(char) * (1 + strlen($1) + strlen(_COMMA) + strlen(_L_PARENTHESIS) + strlen($4) + strlen(_R_PARENTHESIS)));
                                strcpy(s, $1);
                                strcat(s, _COMMA);
                                strcat(s, _L_PARENTHESIS);
                                strcat(s, $4);
                                strcat(s, _R_PARENTHESIS);
                                $$ = s;
                                }
                                | array_expression COMMA assign_expression {
                                char* s = malloc(sizeof(char) * (1 + strlen($1) + strlen(_COMMA) + strlen($3)));
                                strcpy(s, $1);
                                strcat(s, _COMMA);
                                strcat(s, $3);
                                $$ = s;
                                }
                                | assign_expression {$$ = $1;};
                                


assign_expression:              or_expression ASSIGN assign_expression {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen($1)+ strlen(_ASSIGN) + strlen($3) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, $1);
                                strcat(s, _ASSIGN);
                                strcat(s, $3);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                }
                                | or_expression {$$ = $1;};


or_expression:                  or_expression OR and_expression {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen($1) + strlen(_OR) +  strlen($3) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, $1);
                                strcat(s, _OR);
                                strcat(s, $3);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                }
                                | and_expression {$$ = $1;};


and_expression:                  and_expression AND or_op_expression {
                                char *s = (char*)malloc(sizeof(char)*(1 + strlen(_OPEN_EXPR) + strlen($1) + strlen(_AND) +  strlen($3) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, $1);
                                strcat(s, _AND);
                                strcat(s, $3);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                }
                                | or_op_expression {$$ = $1;};


or_op_expression:               or_op_expression OP_OR xor_op_expression {
                                char *s = (char*)malloc(sizeof(char)*(1 + strlen(_OPEN_EXPR) + strlen($1) + strlen(_OP_OR) +  strlen($3) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, $1);
                                strcat(s, _OP_OR);
                                strcat(s, $3);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                }
                                | xor_op_expression {$$ = $1;};


xor_op_expression:              xor_op_expression OP_XOR and_op_expression {
                                char *s = (char*)malloc(sizeof(char)*(1 + strlen(_OPEN_EXPR) + strlen($1) + strlen(_OP_XOR) +  strlen($3) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, $1);
                                strcat(s, _OP_XOR);
                                strcat(s, $3);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                }
                                | and_op_expression {$$ = $1;};


and_op_expression:              and_op_expression OP_AND equal_expression {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen($1) + strlen(_OP_AND) +  strlen($3) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, $1);
                                strcat(s, _OP_AND);
                                strcat(s, $3);
                                strcat(s,  _CLOSE_EXPR);
                                $$ = s;
                                }
                                | equal_expression {$$ = $1;};


equal_expression:               equal_expression EQUAL compare_expression {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen($1) + strlen(_EQUAL) +  strlen($3) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, $1);
                                strcat(s, _EQUAL);
                                strcat(s, $3);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                }
                                | equal_expression NOT_EQUAL compare_expression {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen($1) + strlen(_NOT_EQUAL) +  strlen($3) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, $1);
                                strcat(s, _NOT_EQUAL);
                                strcat(s, $3);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                }
                                | compare_expression {$$ = $1;};


compare_expression:             compare_expression GREATER shift_expression {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen($1) + strlen(_GREATER) +  strlen($3) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, $1);
                                strcat(s, _GREATER);
                                strcat(s, $3);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                }
                                | compare_expression LESS shift_expression {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen($1) + strlen(_LESS) +  strlen($3) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, $1);
                                strcat(s, _LESS);
                                strcat(s, $3);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                }
                                | compare_expression GREATER_EQUAL shift_expression {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen($1) + strlen(_GREATER_EQUAL) +  strlen($3) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, $1);
                                strcat(s, _GREATER_EQUAL);
                                strcat(s, $3);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                }
                                | compare_expression LESS_EQUAL shift_expression {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen($1) + strlen(_LESS_EQUAL) +  strlen($3) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, $1);
                                strcat(s, _LESS_EQUAL);
                                strcat(s, $3);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                }
                                | shift_expression {$$ = $1;};


shift_expression:               shift_expression SHIFT_LEFT add_minus_expression {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen($1) + strlen(_SHIFT_LEFT) +  strlen($3) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, $1);
                                strcat(s, _SHIFT_LEFT);
                                strcat(s, $3);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                }
                                | shift_expression SHIFT_RIGHT add_minus_expression {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen($1) + strlen(_SHIFT_RIGHT) +  strlen($3) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, $1);
                                strcat(s, _SHIFT_RIGHT);
                                strcat(s, $3);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                }
                                | add_minus_expression {$$ = $1;};


add_minus_expression:           add_minus_expression PLUS term_expression {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen($1) + strlen(_PLUS) +  strlen($3) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, $1);
                                strcat(s, _PLUS);
                                strcat(s, $3);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                }
                                | add_minus_expression MINUS term_expression {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen($1) + strlen(_MINUS) +  strlen($3) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, $1);
                                strcat(s, _MINUS);
                                strcat(s, $3);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                }
                                | term_expression {$$ = $1;};


term_expression:                term_expression MULTIPLY prefix_expression {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen($1) + strlen(_MULTIPLY) +  strlen($3) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, $1);
                                strcat(s, _MULTIPLY);
                                strcat(s, $3);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                }
                                | term_expression DIVIDE prefix_expression {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen($1) + strlen(_DIVIDE) +  strlen($3) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, $1);
                                strcat(s, _DIVIDE);
                                strcat(s, $3);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                }
                                | term_expression MODULO prefix_expression {
                                char *s = (char*)malloc(sizeof(char)*(1 + strlen(_OPEN_EXPR) + strlen($1) + strlen(_MODULO) +  strlen($3) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, $1);
                                strcat(s, _MODULO);
                                strcat(s, $3);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                }
                                | prefix_expression {$$ = $1;};


prefix_expression:              INCREMENT prefix_expression {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen(_INCREMENT) +  strlen($2) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, _INCREMENT);
                                strcat(s, $2);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                }
                                | DECREMENT prefix_expression {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen(_DECREMENT) +  strlen($2) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, _DECREMENT);
                                strcat(s, $2);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                }
                                | PLUS prefix_expression %prec UADD {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen(_PLUS) +  strlen($2) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, _PLUS);
                                strcat(s, $2);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                }
                                | MINUS prefix_expression %prec UMINUS {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen(_MINUS) +  strlen($2) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, _MINUS);
                                strcat(s, $2);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                }
                                | NOT prefix_expression {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen(_NOT) +  strlen($2) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, _NOT);
                                strcat(s, $2);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                }
                                | BITWISE_NOT prefix_expression {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen(_BITWISE_NOT) +  strlen($2) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, _BITWISE_NOT);
                                strcat(s, $2);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                }

                                | L_BRACKET type MULTIPLY R_BRACKET prefix_expression {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen(_L_BRACKET) +  strlen($2) + strlen(_MULTIPLY) + strlen(_R_BRACKET) +strlen($5) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, _L_BRACKET);
                                strcat(s, $2);
                                strcat(s, _MULTIPLY);
                                strcat(s, _R_BRACKET);
                                strcat(s, $5);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                }
                                | L_BRACKET type R_BRACKET prefix_expression {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen(_L_BRACKET) +  strlen($2) + strlen(_R_BRACKET) +strlen($4) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, _L_BRACKET);
                                strcat(s, $2);
                                strcat(s, _R_BRACKET);
                                strcat(s, $4);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                }
                                | MULTIPLY prefix_expression %prec UMULTI {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen(_MULTIPLY) +  strlen($2) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, _MULTIPLY);
                                strcat(s, $2);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                }
                                | OP_AND prefix_expression %prec UANDOP {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen(_OP_AND) +  strlen($2) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, _OP_AND);
                                strcat(s, $2);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                }
                                | postfix_expression {$$ = $1;};


postfix_expression:             postfix_expression INCREMENT %prec INCPOST {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen($1) + strlen(_INCREMENT) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, $1);
                                strcat(s, _INCREMENT);
                                strcat(s,  _CLOSE_EXPR);
                                $$ = s;
                                }
                                | postfix_expression DECREMENT %prec DECPOST {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen($1) + strlen(_DECREMENT) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, $1);
                                strcat(s, _DECREMENT);
                                strcat(s,  _CLOSE_EXPR);
                                $$ = s;
                                }
                                | postfix_expression L_BRACKET R_BRACKET {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen($1) + strlen(_L_BRACKET) + strlen(_R_BRACKET) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, $1);
                                strcat(s, _L_BRACKET);
                                strcat(s, _R_BRACKET);
                                strcat(s,  _CLOSE_EXPR);
                                $$ = s;
                                }
                                | postfix_expression L_BRACKET arguments R_BRACKET {
                                char *s = (char*)malloc(sizeof(char)*(1 + strlen(_OPEN_EXPR) + strlen($1) + strlen(_L_BRACKET) + strlen($3) + strlen(_R_BRACKET) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, $1);
                                strcat(s, _L_BRACKET);
                                strcat(s, $3);
                                strcat(s, _R_BRACKET);
                                strcat(s,  _CLOSE_EXPR);
                                $$ = s;
                                }
                                | L_BRACKET assign_expression R_BRACKET {
                                char *s = (char*)malloc(sizeof(char)*(1 + strlen(_OPEN_EXPR) + strlen(_L_BRACKET) + strlen($2) + strlen(_R_BRACKET) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, _L_BRACKET);
                                strcat(s, $2);
                                strcat(s, _R_BRACKET);
                                strcat(s,  _CLOSE_EXPR);
                                $$ = s;
                                }
                                | expression_end {$$ = $1;};


expression_end:                 ID {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen($1) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, $1);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                }
                                | ID array_bracket_recursive {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen($1) + strlen($2) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, $1);
                                strcat(s, $2);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                }
                                | INT {
                                char *tmp = int2string($1);
                                char* s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen(tmp) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, tmp);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                }
                                | DOUBLE {
                                char *tmp = double2string($1);
                                char* s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen(tmp) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, tmp);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                }
                                | CHAR {
                                char* s = malloc(sizeof(char) * (1 + strlen(_OPEN_EXPR) + strlen($1) + strlen(_CLOSE_EXPR)));
                                strcpy(s, _OPEN_EXPR);
                                strcat(s, $1);
                                strcat(s, _CLOSE_EXPR);
                                $$ = s;
                                };


arguments:                      arguments COMMA assign_expression {
                                char *s = (char*)malloc(sizeof(char)*(1 + strlen($1) + strlen(_COMMA) + strlen($3)));
                                strcpy(s, $1);
                                strcat(s, _COMMA);
                                strcat(s, $3);
                                $$ = s;
                                }
                                | assign_expression {$$ = $1;};


type:                           const sign length TYPE_INT {
                                char* s = malloc(sizeof(char) * (1 + strlen($1) + strlen($2) + strlen($3) + strlen($4)));
                                strcpy(s, $1);
                                strcat(s, $2);
                                strcat(s, $3);
                                strcat(s, $4);
                                $$ = s;
                                }
                                | const sign not_int {
                                char* s = malloc(sizeof(char) * (1 + strlen($1) + strlen($2) + strlen($3)));
                                strcpy(s, $1);
                                strcat(s, $2);
                                strcat(s, $3); 
                                $$ = s; 
                                }
                                | const othertype {
                                char* s = malloc(sizeof(char) * (1 + strlen($1) + strlen($2)));
                                strcpy(s, $1);
                                strcat(s, $2);
                                $$ = s;
                                }
                                | TYPE_CONST {$$ = $1;}


const:                          /* empty */ {$$ = "";}
                                | TYPE_CONST { $$ = $1; };


sign:                           /* empty */ {$$ = "";}
                                | TYPE_SIGNED { $$ = $1;};


length:                         /* empty */ {$$ = "";}
                                | TYPE_LENGTH { $$ = $1;}
                                | TYPE_LENGTH TYPE_LENGTH { 
                                char* s = malloc(sizeof(char) * (1 + strlen($1) + strlen($2)));
                                strcpy(s, $1);
                                strcat(s, $2);
                                $$ = s;
                                };


not_int:                        TYPE_LENGTH TYPE_LENGTH {
                                char* s = malloc(sizeof(char) * (1 + strlen($1) + strlen($2)));
                                strcpy(s, $1);
                                strcat(s, $2);
                                $$ = s;
                                }
                                | TYPE_LENGTH {$$ = $1;}
                                | TYPE_CHAR {$$ = $1;};


othertype:                      TYPE_SIGNED | TYPE_FLOAT | TYPE_DOUBLE | TYPE_VOID {$$ = $1;};


parameter_recursive:            /* empty */ {$$ = "";}
                                | parameter {$$ = $1;}
                                | parameter_recursive COMMA parameter {
                                char* s = malloc(sizeof(char) * (1 + strlen($1) + strlen(_COMMA) + strlen($3)));
                                strcpy(s, $1);
                                strcat(s, _COMMA);
                                strcat(s, $3);
                                $$ = s;
                                };


parameter:                      type ID {
                                char* s = malloc(sizeof(char) * (1 + strlen($1) + strlen($2)));
                                strcpy(s, $1);
                                strcat(s, $2);
                                $$ = s;
                                };
                                | type MULTIPLY ID {
                                char* s = malloc(sizeof(char) * (1 + strlen($1) + strlen(_MULTIPLY) + strlen($3)));
                                strcpy(s, $1);
                                strcat(s, _MULTIPLY);
                                strcat(s, $3);
                                $$ = s;
                                };


compound_statement:             L_PARENTHESIS statement_recursive R_PARENTHESIS {
                                char* s = malloc(sizeof(char) * (1 + strlen(_L_PARENTHESIS) + strlen($2) + strlen(_R_PARENTHESIS)));
                                strcpy(s, _L_PARENTHESIS);
                                strcat(s, $2);
                                strcat(s, _R_PARENTHESIS);
                                $$ = s;
                                };


statement_recursive:            /* empty */ {$$ = "";}
                                | statement_recursive statement {
                                char* s = malloc(sizeof(char) * (1 + strlen($1) + strlen($2)));
                                strcpy(s, $1);
                                strcat(s, $2);
                                $$ = s;
                                };

statement:                      assign_expression SEMICOLON {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_STMT) + strlen($1) + strlen(_SEMICOLON) + strlen(_CLOSE_STMT)));
                                strcpy(s, _OPEN_STMT);
                                strcat(s, $1);
                                strcat(s, _SEMICOLON);
                                strcat(s, _CLOSE_STMT);
                                $$ = s;
                                }
                                | BREAK SEMICOLON {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_STMT) + strlen(_BREAK) + strlen(_SEMICOLON) + strlen(_CLOSE_STMT)));
                                strcpy(s, _OPEN_STMT);
                                strcat(s, _BREAK);
                                strcat(s, _SEMICOLON);
                                strcat(s, _CLOSE_STMT);
                                $$ = s;
                                } 
                                | CONTINUE SEMICOLON {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_STMT) + strlen(_CONTINUE) + strlen(_SEMICOLON) + strlen(_CLOSE_STMT)));
                                strcpy(s, _OPEN_STMT);
                                strcat(s, _CONTINUE);
                                strcat(s, _SEMICOLON);
                                strcat(s, _CLOSE_STMT);
                                $$ = s;
                                }
                                | compound_statement {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_STMT) + strlen($1) + strlen(_CLOSE_STMT)));
                                strcpy(s, _OPEN_STMT);
                                strcat(s, $1);
                                strcat(s, _CLOSE_STMT);
                                $$ = s;
                                }
                                | if_else_statement {$$ = $1;}
                                | switch_statement {$$ = $1;}
                                | while_statement {$$ = $1;}
                                | for_statement {$$ = $1;}
                                | return_statement {$$ = $1;};
                                | declaration {$$ = $1;}


if_else_statement:              IF L_BRACKET assign_expression R_BRACKET compound_statement {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_STMT) + strlen(_IF)  +strlen(_L_BRACKET) + strlen($3) + strlen(_R_BRACKET) + strlen($5) + strlen(_CLOSE_STMT)));
                                strcpy(s, _OPEN_STMT);
                                strcat(s, _IF);
                                strcat(s, _L_BRACKET);
                                strcat(s, $3);
                                strcat(s, _R_BRACKET);
                                strcat(s, $5);
                                strcat(s, _CLOSE_STMT);
                                $$ = s;
                                }
                                | IF L_BRACKET assign_expression R_BRACKET compound_statement ELSE compound_statement {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_STMT) + strlen(_IF) + strlen(_L_BRACKET) + strlen($3) + strlen(_R_BRACKET) + strlen($5)+ strlen(_ELSE) + strlen($7) + strlen(_CLOSE_STMT)));
                                strcpy(s, _OPEN_STMT); 
                                strcat(s, _IF);
                                strcat(s, _L_BRACKET);
                                strcat(s, $3);
                                strcat(s, _R_BRACKET);
                                strcat(s, $5);
                                strcat(s, _ELSE);
                                strcat(s, $7);
                                strcat(s, _CLOSE_STMT);
                                $$ = s;
                                };


switch_statement:               SWITCH L_BRACKET assign_expression R_BRACKET L_PARENTHESIS switch_clause_recursive R_PARENTHESIS {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_STMT) + strlen(_SWITCH) + strlen(_L_BRACKET) + strlen($3) + strlen(_R_BRACKET) + strlen(_L_PARENTHESIS) +strlen($6) + strlen(_R_PARENTHESIS) + strlen(_CLOSE_STMT)));
                                strcpy(s, _OPEN_STMT);
                                strcat(s, _SWITCH);
                                strcat(s, _L_BRACKET);
                                strcat(s, $3);
                                strcat(s, _R_BRACKET);
                                strcat(s, _L_PARENTHESIS);
                                strcat(s, $6);
                                strcat(s, _R_PARENTHESIS);
                                strcat(s, _CLOSE_STMT);
                                $$ = s;
                                };


switch_clause_recursive:        /* empty */ {$$ = "";}
                                | switch_clause_recursive switch_clause {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen($1) + strlen($2)));
                                strcpy(s, $1);
                                strcat(s, $2);
                                $$ = s;
                                }

switch_clause:                  CASE assign_expression COLON statement_recursive {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_CASE) + strlen($2) + strlen(_COLON) + strlen($4)));
                                strcpy(s, _CASE);
                                strcat(s, $2);
                                strcat(s, _COLON);
                                strcat(s, $4);
                                $$ = s;
                                }
                                | DEFAULT COLON statement_recursive {
                                char *s = (char*)malloc(sizeof(char)  *(1 + strlen(_DEFAULT) +  strlen(_COLON) + strlen($3)));
                                strcpy(s, _DEFAULT);
                                strcat(s, _COLON);
                                strcat(s, $3);
                                $$ = s;
                                };


while_statement:                WHILE L_BRACKET assign_expression R_BRACKET statement {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_STMT) + strlen(_WHILE) + strlen(_L_BRACKET) + strlen($3)+ strlen(_R_BRACKET) + strlen($5) + strlen(_CLOSE_STMT)));
                                strcpy(s,  _OPEN_STMT);
                                strcat(s, _WHILE);
                                strcat(s, _L_BRACKET);
                                strcat(s, $3);
                                strcat(s, _R_BRACKET);
                                strcat(s, $5);
                                strcat(s,  _CLOSE_STMT);
                                $$ = s;
                                }
                                | DO statement WHILE L_BRACKET assign_expression R_BRACKET SEMICOLON {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_STMT)+ strlen(_DO) + strlen($2)+ strlen(_WHILE) + strlen(_L_BRACKET) + strlen($5) + strlen(_R_BRACKET) + strlen(_SEMICOLON) + strlen(_CLOSE_STMT)));
                                strcpy(s, _OPEN_STMT);
                                strcat(s, _DO);
                                strcat(s, $2);
                                strcat(s, _WHILE);
                                strcat(s, _L_BRACKET);
                                strcat(s, $5);
                                strcat(s, _R_BRACKET);
                                strcat(s, _SEMICOLON);
                                strcat(s,  _CLOSE_STMT);
                                $$ = s;
                                };

for_statement:                  FOR L_BRACKET empty_expression SEMICOLON empty_expression SEMICOLON empty_expression R_BRACKET statement {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_STMT) + strlen(_FOR) + strlen(_L_BRACKET) +  strlen($3) + strlen(_SEMICOLON) + strlen($5) + strlen(_SEMICOLON) + strlen($7) + strlen(_R_BRACKET) + strlen($9) + strlen(_CLOSE_STMT)));
                                strcpy(s, _OPEN_STMT);
                                strcat(s, _FOR);
                                strcat(s, _L_BRACKET);
                                strcat(s, $3);
                                strcat(s, _SEMICOLON);
                                strcat(s, $5);
                                strcat(s, _SEMICOLON);
                                strcat(s, $7);
                                strcat(s, _R_BRACKET);
                                strcat(s, $9);
                                strcat(s, _CLOSE_STMT);
                                $$ = s;
                                };


return_statement:               RETURN empty_expression SEMICOLON {
                                char *s = (char*)malloc(sizeof(char) * (1 + strlen(_OPEN_STMT) + strlen(_RETURN) + strlen($2) + strlen(_SEMICOLON) + strlen(_CLOSE_STMT)));
                                strcpy(s, _OPEN_STMT);
                                strcat(s, _RETURN);
                                strcat(s, $2);
                                strcat(s, _SEMICOLON);
                                strcat(s, _CLOSE_STMT);
                                $$ = s;
                                };


empty_expression:               /*empty*/ {$$ = "";}
                                | assign_expression {$$ = $1;};

%%

int yylex();

int main(void) {
    yyparse();
    return 0;
}

void yyerror(char *msg) {
    fprintf(stderr, "Error: %s\n", msg);
    exit(1);
}
