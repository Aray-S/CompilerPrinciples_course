%{
    #include <stdio.h>
    #include <string.h>
    int lines = 1, words=0, chars = 0;
%}

NAME        ^#\ ([0-9a-zA-Z]+\.sealpp)
COMMENT     #([\ \t]|.)*
SPACE       [\ \t\r]+
ENTER	    [\n]+
TYPEID      Int|Float|String|Void|Bool
KEYWORD     fprintf|while|if|else|continue|break|return|aafor
SYMBOL      \<\=|\>\=|\=\=|\:\=|\%f|\%s|\%lld|\|\||\&\&|\%|\~|\^|\-|\*|\/|\+|\-|\;|\=|\:|\||\&|\{|\}|\(|\)|\\|\<|\>
CONST       [0-9]+\.[0-9]+|0|[1-9][0-9]*
FUNC        func\ {OBJECTED}
STDOUT      stdout|stderr
OBJECTED    [a-z][a-zA-Z0-9]*
OTHER       .
%%

{NAME}      {	chars += yyleng; printf("#name %s\n", yytext+2);	}
{COMMENT}   {	chars += yyleng;	}
{SPACE}     {	chars += yyleng;	}
{ENTER}	    {	chars += yyleng; ++lines;	}
{TYPEID}    {	chars += yyleng; printf("#%d TYPEID %s\n", lines, yytext);	}
{KEYWORD}   {	chars += yyleng; printf("#%d KEYWORD %s\n", lines, yytext);	}
{SYMBOL}    {	chars += yyleng; printf("#%d %s\n", lines, yytext);	}
{CONST}     {	chars += yyleng; printf("#%d CONST %s\n", lines, yytext);	}
{FUNC}	    {	chars += yyleng; printf("#%d %s\n", lines, yytext);	}
{STDOUT}    {	chars += yyleng;	}
{OBJECTED}  {	chars += yyleng; printf("#%d OBJECTED %s\n", lines, yytext);	}
{OTHER}     {	chars += yyleng;	}

%%

int yywrap()	{return 1;}

int main()
{
    yylex();
    fseek (yyin, 0, SEEK_SET);
    char *str = malloc (chars+1);
    if (str) fread (str, 1, chars, yyin);
    for (int i=1;i<chars; i++)
    	if ((str[i]==' '||str[i]=='\t'||str[i]=='\r'||str[i]=='\n')&&str[i-1]!=' '&&str[i-1]!='\t'&&str[i-1]!='\r'&&str[i-1]!='\n')
		++words; 
    printf("lines:%d,words:%d,chars:%d\n", lines, words, chars);
    return 0;
}


