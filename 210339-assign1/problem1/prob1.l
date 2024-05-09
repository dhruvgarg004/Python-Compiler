%option noyywrap
%option yylineno

%{
    #include<bits/stdc++.h>
    using namespace std;
    vector<string> lexeme;
    unordered_map<string,int> lex_count;
    unordered_map<string,string> token;
%}

WS              [ \t\f\n\r]|\r\n
COMMENT         \{[^\}]*\}
DELIMITER         "\{"|"\}"|";"|"\("|"\)"|"\["|"\]"|":"|","|"'"|"\"" 
OPERATOR        "AND"|"OR"|"LEQ"|"LT"|"GEQ"|"GT"|"NOT"|"EQL"|"NEQ"|":="|"+"|"-"|"*"|"/"|"%"|"^"|"|"|"&"|"<<"|">>"|"<="|">="
PDIGIT          [1-9]
DIGIT           [0-9]
LETTER          [a-zA-Z]
PHEX            [1-9a-fA-F]
HEX             [0-9a-fA-F]
HEXADECIMAL     "0"(x|X){HEX}|"0"(x|X){PHEX}{HEX}+
STRING          \"[^\"\']*\"|\'[^\'\"]*\'
INVALSTR        \"[^\"\']*|\'[^\'\"]*
ID              {LETTER}({LETTER}|{DIGIT})*
INTEGER         {DIGIT}|{PDIGIT}{DIGIT}+
FLOATING_POINT         {INTEGER}"."{DIGIT}{1,6}
 
%%

 /* Ignore Comments and Whitespaces */
{COMMENT}|{WS}


(?i:ARRAY|BEGIN|BOOLEAN|COMMENT|CONTINUE|DO|DOUBLE|ELSE|END|FALSE|FOR|IF|INTEGER|LABEL|LIST|LONG|OWN|PROCEDURE|STEP|SWITCH|THEN|TRUE|UNTIL|VALUE|WHILE) { 
    string temp;
    temp.assign(yytext);
    transform(temp.begin(), temp.end(), temp.begin(), ::toupper);
    if(yytext==temp){
        if(find(lexeme.begin(), lexeme.end(), yytext) == lexeme.end()){ 
            lexeme.push_back(yytext); token[yytext] = "KEYWORD"; 
        } 
        lex_count[yytext]++; 
    }
    else{
        if(find(lexeme.begin(), lexeme.end(), yytext) == lexeme.end()){ 
            lexeme.push_back(yytext); token[yytext] = "KEYWORD"; 
        } 
        lex_count[temp]++;
    }
}

{DELIMITER}            { 
    if(find(lexeme.begin(), lexeme.end(), yytext) == lexeme.end()){ 
        lexeme.push_back(yytext); token[yytext] = "DELIMITER"; 
    } 
        lex_count[yytext]++; 
}

(?i:{OPERATOR})            {
    string temp;
    temp.assign(yytext);
    transform(temp.begin(), temp.end(), temp.begin(), ::toupper);
    if(yytext==temp){
        if(find(lexeme.begin(), lexeme.end(), yytext) == lexeme.end()){ 
            lexeme.push_back(yytext); token[yytext] = "OPERATOR"; 
        } 
        lex_count[yytext]++; 
    }
    else{
        if(find(lexeme.begin(), lexeme.end(), yytext) == lexeme.end()){ 
            lexeme.push_back(yytext); token[yytext] = "OPERATOR"; 
        } 
        lex_count[temp]++;
    }
}

{ID}                {
    if(find(lexeme.begin(), lexeme.end(), yytext) == lexeme.end()){ 
        lexeme.push_back(yytext); token[yytext] = "IDENTIFIER"; 
    } 
        lex_count[yytext]++;
}

{STRING}             {
    if(find(lexeme.begin(), lexeme.end(), yytext) == lexeme.end()){ 
        lexeme.push_back(yytext); token[yytext] = "STRING"; 
    } 
        lex_count[yytext]++;
}

{INTEGER}                {
    if(find(lexeme.begin(), lexeme.end(), yytext) == lexeme.end()){ 
        lexeme.push_back(yytext); token[yytext] = "INTEGER"; 
    } 
        lex_count[yytext]++;
}

{FLOATING_POINT}                {
    if(find(lexeme.begin(), lexeme.end(), yytext) == lexeme.end()){ 
        lexeme.push_back(yytext); token[yytext] = "FLOATING_POINT"; 
    } 
        lex_count[yytext]++;
}

(?i:{HEXADECIMAL})               {
    string temp;
    temp.assign(yytext);
    transform(temp.begin(), temp.end(), temp.begin(), ::toupper);
    if(yytext==temp){
        if(find(lexeme.begin(), lexeme.end(), yytext) == lexeme.end()){ 
            lexeme.push_back(yytext); token[yytext] = "HEXADECIMAL"; 
        } 
        lex_count[yytext]++; 
    }
    else{
        if(find(lexeme.begin(), lexeme.end(), yytext) == lexeme.end()){ 
            lexeme.push_back(yytext); token[yytext] = "HEXADECIMAL"; 
        } 
        lex_count[temp]++;
    }
}

{INVALSTR}      { cerr<<"Invalid string ("<<yytext<<") found at line number "<<yylineno<<"\nProgram Terminated\n"; 
        return 0;}

.       { cerr<<"Invalid character ("<<yytext<<") found at line number "<<yylineno<<"\nProgram Terminated\n"; 
        return 0;}


%%

int main(int argc ,char* argv[]){

    yyin = fopen(argv[1], "r");
    
    yylex();

    cout<<setw(20)<<left<<"Token"<<"Count"<<"              "<<"Lexeme"<<endl;
    sort(lexeme.begin(),lexeme.end());
    for(auto lex : lexeme){
        if(token[lex]=="KEYWORD" || token[lex]=="OPERATOR" || token[lex]=="HEXADECIMAL"){
            string temp;
            temp.assign(lex);
            transform(temp.begin(), temp.end(), temp.begin(), ::toupper);
            lex_count[lex]=lex_count[temp];
        }
        cout<<setw(20)<<left<<token[lex]<<lex_count[lex]<<"              "<<lex<<endl;
    }

    fclose(yyin);
    return 0;

}


