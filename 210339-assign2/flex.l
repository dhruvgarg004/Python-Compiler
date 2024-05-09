%option case-insensitive
%option yylineno
%{
    #include<bits/stdc++.h>
    using namespace std;
    #include "parse.tab.h"
    #include <cstring>
    int totq=0;
    int singleq=0;
    int multiq=0;
    int choices=0;
    int corrects=0;
    int marks=0;
    vector<int> qm(9,0);
    stack <string> s;
    stack <int> line;
    extern void printall();

%}

WS              [ \t\n\r]
Digit           [0-9]
Letter          [a-zA-Z]



 /*rules */
%%
"<"{WS}*"quiz"{WS}*">"                            { //done
    int nl=0;
    for (size_t i = 0; i < strlen(yytext); i++) {
        if (yytext[i] == '\n') nl++;
    }
    if(s.empty()){
        s.push("quiz");
        line.push(yylineno-nl);
        return QS;
    }
    else{
        printall();
        cout<<"Error at line "<<yylineno-nl<<" as the quiz has already started, you can't have another." << endl;
        exit(1);
    }
}
"<"{WS}*"/"{WS}*"quiz"{WS}*">"                   {
    int nl=0;
    for (size_t i = 0; i < strlen(yytext); i++) {
        if (yytext[i] == '\n') nl++;
    }
    if(s.empty()){ //fine
        printall();
        cout<<"Error at line "<<yylineno-nl<<endl;
        cout<<"Quiz has not started or already ended, closing not allowed"<<endl;
        exit(1);
    }
    else if(s.top()=="quiz"){ //fine
        s.pop();
        line.pop();
        return QE;
    }
    else{ //fine
        printall();
        if(s.top()=="single" || s.top()=="multi"){ 
            cout<<"Error at line "<<line.top()<<" because "<<s.top()<<" question has no closing tag."<<endl;        
        }
        else{
            cout<<"Error at line "<<line.top()<<" because "<<s.top()<<" has no closing tag."<<endl;        
        }
        exit(1);
    }
}
"<"{WS}*"correct"{WS}*">"                         { 
    int nl=0;
    for (size_t i = 0; i < strlen(yytext); i++) {
        if (yytext[i] == '\n') nl++;
    }
    if(s.empty()){ //fine
        break;
    }
    else if(s.top()=="single" || s.top()=="multi"){ //fine
        s.push("correct");
        line.push(yylineno-nl);
        return COS;
    }  
    else if(s.top()=="choice" || s.top()=="correct"){
        printall();
        cout<<"Error at line "<<line.top()<<" because "<<s.top()<<" has no closing tag."<<endl;
        exit(1);
    }
}
"<"{WS}*"/"{WS}*"correct"{WS}*">"               {
    int nl=0;
    for (size_t i = 0; i < strlen(yytext); i++) {
        if (yytext[i] == '\n') nl++;
    }
    if(s.empty()){ //fine
        break;
    }
    else if(s.top()=="correct"){ ///fine
        corrects++;
        s.pop();
        line.pop();
        return COE;
    }
    else if(s.top()=="choice"){
        printall();
        cout<<"Error at line "<<line.top()<<" because "<<s.top()<<" has no closing tag."<<endl;
        exit(1);
    }
    else if(s.top()=="multi" || s.top()=="single"){
        printall();
        cout<<"Error at line "<<yylineno-nl<<" because correct has no opening tag."<<endl;
        exit(1);
    }
}
"<"{WS}*"choice"{WS}*">"                          {
    int nl=0;
    for (size_t i = 0; i < strlen(yytext); i++) {
        if (yytext[i] == '\n') nl++;
    }
    if(s.empty()){ 
        break;
    }
    else if(s.top()=="single" || s.top()=="multi"){
        s.push("choice"); 
        line.push(yylineno-nl);
        return CHS;
    }  
    else if(s.top()=="choice" || s.top()=="correct"){
        printall();
        cout<<"Error at line "<<line.top()<<" because "<<s.top()<<" has no closing tag."<<endl;
        exit(1);
    }
}
"<"{WS}*"/"{WS}*"choice"{WS}*">"                 {
    int nl=0;
    for (size_t i = 0; i < strlen(yytext); i++) {
        if (yytext[i] == '\n') nl++;
    }
    if(s.empty()){
        break;
    }
    else if(s.top()=="choice"){
        choices++;
        s.pop();
        line.pop();
        return CHE ;
    }
    else if(s.top()=="correct"){
        printall();
        cout<<"Error at line "<<line.top()<<" because "<<s.top()<<" has no closing tag."<<endl;
        exit(1);
    }
    else if(s.top()=="multi" || s.top()=="single"){
        printall();
        cout<<"Error at line "<<yylineno-nl<<" because choice has no opening tag."<<endl;
        exit(1);
    }
}
"<"{WS}*"/"{WS}*"singleselect"{WS}*">"            {
    int nl=0;
    for (size_t i = 0; i < strlen(yytext); i++) {
        if (yytext[i] == '\n') nl++;
    }
    if(s.empty()){
        break;
    }
    else if(s.top()=="single"){
        s.pop();
        line.pop();
        return SSE;
    }
    else{ 
        if(s.top()=="correct" || s.top()=="choice"){
            printall();
            cout<<"Error at line "<<line.top()<<" because "<<s.top()<<" has no closing tag."<<endl;
            exit(1);
        }
        if(s.top()=="multi"){ 
            printall();
            cout<<"Error at line "<<yylineno-nl<< " because it has no opening tag."<<endl;
            exit(1);
        }
        if(s.top()=="quiz"){
            printall();
            cout<<"Error at line "<<yylineno-nl<<" because there is no opening tag of singleselect" << endl;
            exit(1);
        }
    }
}
"<"{WS}*"/"{WS}*"multiselect"{WS}*">"            {
    int nl=0;
    for (size_t i = 0; i < strlen(yytext); i++) {
        if (yytext[i] == '\n') nl++;
    }
    if(s.empty()){
        break;
    }
    else if(s.top()=="multi"){
        s.pop();
        line.pop();
        return MSE;
    }
    else{
        if(s.top()=="correct" || s.top()=="choice"){
            printall();
            cout<<"Error at line "<<line.top()<<" because "<<s.top()<<" has no closing tag."<<endl;
            exit(1);
        }
        if(s.top()=="single"){ 
            printall();
            cout<<"Error at line "<<yylineno-nl<< " because it has no opening tag."<<endl;
            exit(1);
        }
        if(s.top()=="quiz"){
            printall();
            cout<<"Error at line "<<yylineno-nl<<" because there is no opening tag of multiselect" << endl;
            exit(1);
        }
    }
}

"<"{WS}*"singleselect"{WS}+"marks"{WS}*"="{WS}*\"{WS}*{Digit}+{WS}*\"{WS}*">"   {
    int x=0;
    int nl=0;
    for (size_t i = 0; i < strlen(yytext); i++) {
        if (yytext[i] >= '0' && yytext[i] <= '9') {
            x = x*10 + (yytext[i] - '0');
        }
        if(yytext[i]=='\n') nl++;
    }
    if(x!=1 && x!=2){
        printall();
        cout<<"Error: marks out of bound in singleselect at line number: "<<yylineno-nl<<endl;
        exit(1);
    }
    yylval.num = x;
    if(s.empty()){
        break;
    }
    else if(s.top()=="quiz"){
        singleq++;
        totq++;
        s.push("single"); 
        line.push(yylineno-nl);
        return SSS;
    }
    else{
        if(s.top()=="single" || s.top()=="multi"){
            printall();
            cout<<"Error at line "<<line.top()<< " because the " <<s.top()<<" question tag has still not ended and a new question appeared at "<<yylineno-nl<<endl;
            exit(1);
        }
        if(s.top()=="choice" || s.top()=="correct"){
            printall();
            cout<<"Error at line "<<line.top()<< " because the " <<s.top()<<" tag has still not ended."<<endl;
            exit(1);
        }
    }
}
"<"{WS}*"multiselect"{WS}+"marks"{WS}*"="{WS}*\"{WS}*{Digit}+{WS}*\"{WS}*">"    {
    int nl=0;
    int x=0;
    for (size_t i = 0; i < strlen(yytext); i++) {
        if (yytext[i] >= '0' && yytext[i] <= '9') {
            x = x*10 + (yytext[i] - '0');
        }
        if(yytext[i]=='\n') nl++;
    }
    if(x<2 || x>8){
        printall();
        cout<<"Error: marks out of bound in multiselect at line number: "<<yylineno-nl<<endl;
        exit(1);
    }
    yylval.num = x;
    if(s.empty()){
        break;
    }
    else if(s.top()=="quiz"){
        multiq++;
        totq++;
        s.push("multi");
        line.push(yylineno-nl);
        return MSS;
    }
    else{
        printall();
        if(s.top()=="single" || s.top()=="multi"){
            printall();
            cout<<"Error at line "<<line.top()<< " because the " <<s.top()<<" question tag has still not ended and new question started at "<<yylineno-nl<<endl;
            exit(1);
        }
        if(s.top()=="choice" || s.top()=="correct"){
            printall();
            cout<<"Error at line "<<line.top()<< " because the " <<s.top()<<" tag has still not ended."<<endl;
            exit(1);
        }
        exit(1);
    }
}
"<"{WS}*"singleselect"{WS}+"marks"{WS}*"=". { 
    int nl=0;
    for (size_t i = 0; i < strlen(yytext); i++) {
        if (yytext[i] == '\n') nl++;
    }
    printall();
    cout<<"Error at line: "<<yylineno-nl<<" ,because of incorrect single select opening tag."<<endl;
    exit(1);
}
"<"{WS}*"multiselect"{WS}+"marks"{WS}*"=". {
    int nl=0;
    for (size_t i = 0; i < strlen(yytext); i++) {
        if (yytext[i] == '\n') nl++;
    }
    printall();
    cout<<"Error at line: "<<yylineno-nl<<" ,because of incorrect multi select opening tag."<<endl;
    exit(1);
}
\n  {}
.   {}
%%

int yywrap(){return 1;}