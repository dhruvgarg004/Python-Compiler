%option noyywrap
%option case-insensitive
%option yylineno

%{
    #include<bits/stdc++.h>
    using namespace std;
    vector<string> lexeme;
    unordered_map<string,int> lex_count;
    unordered_map<string,string> token;
%}

WS              [ \t\f\n\r]|\r\n
DIGIT           [0-9]
LETTER          [a-zA-Z]
UNDERSC         [_]
NAME            {LETTER}({LETTER}|{DIGIT}|{UNDERSC}){0,62}
OPERATOR        "="|"+"|"-"|"*"|"/"|"<"|">"|"%"|"&"|"**"|"//"|".EQ."|".NE."|".LT."|".LE."|".GT."|".GE."|"=="|"/="|"<="|">="|".NOT."|".AND."|".OR."|".EQV."|".NEQV."|"&&"|"<<"|">>"|"||"
DELIMITER       "("|")"|"["|"]"|"(/"|"/)"
SPECIAL_CHAR    "@"|"#"|"$"|"|"|"^"|"`"|"?"|"~"|";"|":"|"."|","|"{"|"}"|"\\"|"'"

SIGN            "+"|"-"
CHAR_LITERAL        \"[^\'\"]*\" 
DIGIT_STR       {DIGIT}{DIGIT}*
S_DIGIT_STR     {SIGN}?{DIGIT_STR}
EXPONENT        {S_DIGIT_STR}
EXPONENT_LET    "E"|"D"|"e"|"d"
SIGNIFICAND     {DIGIT_STR}"."{DIGIT_STR}?|"."{DIGIT_STR}
REAL_LIT_CONST  {SIGNIFICAND}({EXPONENT_LET}{EXPONENT})?|{DIGIT_STR}{EXPONENT_LET}{EXPONENT}
S_REAL_LIT_CONST {SIGN}?{REAL_LIT_CONST}
LOGICAL_LIT_CONST (".TRUE."|".FALSE.")


%%

 /* Ignore Comments and Whitespaces */
{WS}
^[[:blank:]]*!.*$ {}

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

{DELIMITER}            {
    if(find(lexeme.begin(), lexeme.end(), yytext) == lexeme.end()){ 
        lexeme.push_back(yytext); token[yytext] = "DELIMITER"; 
    } 
        lex_count[yytext]++;
}

{SPECIAL_CHAR}            {
    if(find(lexeme.begin(), lexeme.end(), yytext) == lexeme.end()){ 
        lexeme.push_back(yytext); token[yytext] = "SPECIAL_CHAR"; 
    } 
        lex_count[yytext]++;
 }

(?i:ALLOCATABLE|ALLOCATE|ASSIGN|ASSOCIATE|ASYNCHRONOUS|BACKSPACE|BIND|CALL|CASE|CLASS|CLOSE|COMMON|CONTAINS|CONTINUE|CYCLE|CODIMENSION|CONTIGUOUS|CRITICAL|DATA|DEALLOCATE|DEFERRED|DIMENSION|DO|ELSE|ELSEWHERE|END|ENDFILE|ENDIF|ENTRY|EQUIVALENCE|EXIT|EXTERNAL|ENUM|ENUMERATOR|EXTENDS|FORALL|FINAL|FLUSH|FORMAT|FUNCTION|GOTO|GENERIC|IMPORT|IF|IMPLICIT|INQUIRE|INTRINSIC|INCLUDE|INTERFACE|INTENT|LOCK|MODULE|NOPASS|NAMELIST|NULLIFY|OPEN|ONLY|OPERATOR|OPTIONAL|PARAMETER|PAUSE|PRINT|PROGRAM|POINTER|PRIVATE|PASS|PROTECTED|PROCEDURE|PUBLIC|READ|RETURN|RECURSIVE|RESULT|REWIND|REWRITE|SAVE|STOP|SUBROUTINE|SELECT|SEQUENCE|SUBMODULE|TARGET|THEN|USE|VALUE|UNLOCK|VOLATILE|WHILE|WRITE)   {

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


{CHAR_LITERAL}            {
    if(find(lexeme.begin(), lexeme.end(), yytext) == lexeme.end()){ 
        lexeme.push_back(yytext); token[yytext] = "CHAR_LITERAL"; 
    } 
        lex_count[yytext]++;
}

{NAME}            {
    string temp;
    temp.assign(yytext);
    transform(temp.begin(), temp.end(), temp.begin(), ::toupper);
    if(yytext==temp){
        if(find(lexeme.begin(), lexeme.end(), yytext) == lexeme.end()){ 
            lexeme.push_back(yytext); token[yytext] = "NAME"; 
        } 
        lex_count[yytext]++; 
    }
    else{
        if(find(lexeme.begin(), lexeme.end(), yytext) == lexeme.end()){ 
            lexeme.push_back(yytext); token[yytext] = "NAME"; 
        } 
        lex_count[temp]++;
    }
}

{S_DIGIT_STR}|{DIGIT_STR}            {
    if(find(lexeme.begin(), lexeme.end(), yytext) == lexeme.end()){ 
        lexeme.push_back(yytext); token[yytext] = "INT_LITERAL"; 
    } 
        lex_count[yytext]++;
}

{REAL_LIT_CONST}|{S_REAL_LIT_CONST}            {
    string temp;
    temp.assign(yytext);
    transform(temp.begin(), temp.end(), temp.begin(), ::toupper);
    if(yytext==temp){
        if(find(lexeme.begin(), lexeme.end(), yytext) == lexeme.end()){ 
            lexeme.push_back(yytext); token[yytext] = "REAL_LITERAL"; 
        } 
        lex_count[yytext]++; 
    }
    else{
        if(find(lexeme.begin(), lexeme.end(), yytext) == lexeme.end()){ 
            lexeme.push_back(yytext); token[yytext] = "REAL_LITERAL"; 
        } 
        lex_count[temp]++;
    }
}

(?:{LOGICAL_LIT_CONST})            {
    string temp;
    temp.assign(yytext);
    transform(temp.begin(), temp.end(), temp.begin(), ::toupper);
    if(yytext==temp){
        if(find(lexeme.begin(), lexeme.end(), yytext) == lexeme.end()){ 
            lexeme.push_back(yytext); token[yytext] = "LOGICAL_LITERAL"; 
        } 
        lex_count[yytext]++; 
    }
    else{
        if(find(lexeme.begin(), lexeme.end(), yytext) == lexeme.end()){ 
            lexeme.push_back(yytext); token[yytext] = "LOGICAL_LITERAL"; 
        } 
        lex_count[temp]++;
    }
}

.       { cerr<<"Invalid character ("<<yytext<<") found at line number "<<yylineno<<"\nProgram Terminated\n"; 
        return 0;}


%%

int main(int argc ,char* argv[]){
    
    yyin = fopen(argv[1], "r");
    yylex();
    cout<<setw(20)<<left<<"Token"<<"Count"<<"              "<<"Lexeme"<<endl;
    sort(lexeme.begin(),lexeme.end());
    for(auto lex : lexeme){
        if(token[lex] == "NAME" || token[lex]=="KEYWORD" || token[lex]=="REAL_LITERAL" || token[lex]=="LOGICAL_LITERAL" || token[lex]=="OPERATOR"){
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