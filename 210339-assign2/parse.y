%{
    #include<bits/stdc++.h>
    using namespace std;
    extern int yylex();
    extern int yyparse();
    extern int yyrestart(FILE* yyin);
    extern FILE *yyin;
    extern char* yytext;

    void yyerror(const char *s);

    extern int yylineno;
    int a=0;
    extern int totq;
    extern int singleq;
    extern int multiq;
    extern int choices;
    extern int corrects;
    extern int marks;
    extern vector<int> qm;
    extern stack<string> s;
    extern stack<int> line;
    int tempch;
    void printall(){
        cout << "Number of questions: " << totq << endl;
        cout << "Number of singleselect questions: " << singleq << endl;
        cout << "Number of multiselect questions: " << multiq << endl;
        cout << "Number of answer choices: " << choices << endl;
        cout << "Number of correct answers: " << corrects << endl;
        cout << "Total marks: " << marks << endl;
        cout << "Number of 1 marks questions: " << qm[1] << endl;
        cout << "Number of 2 marks questions: " << qm[2] << endl;
        cout << "Number of 3 mark questions: " << qm[3] << endl;
        cout << "Number of 4 mark questions: " << qm[4] << endl;
        cout << "Number of 5 mark questions: " << qm[5] << endl;
        cout << "Number of 6 mark questions: " << qm[6] << endl;
        cout << "Number of 7 mark questions: " << qm[7] << endl;
        cout << "Number of 8 mark questions: " << qm[8] << endl;
    }
    int c;
    int ch;
  /*def */
%}

/*rules */

%union {
    int num;
}   

%token EOL
%token QS
%token QE
%token COS 
%token COE 
%token CHS 
%token CHE
%token SSE 
%token MSE
%token<num> SSS
%token<num> MSS

%type QUIZ
%type<num> SINGLESEL 
%type<num> MULTISEL
%type QUES 

%start S


%%
 //correct or choices out of questions should be ignored
S: 
    QS QUIZ QE ;

QUIZ: 
    %empty
|   SINGLESEL QUIZ 
|   MULTISEL QUIZ ;

SINGLESEL: SSS { 
    qm[$1]++;
    marks += $1;
    ch=0;
    c=0;
} QUES {
    if(ch < 3 || ch >4){
        printall();
        cout<<"Error till line: "<<yylineno<<" ,because it has incorrect number of choices."<<endl;
        exit(1);
    }
    if(c>1){
        printall();
        cout<<"Error till line: "<<yylineno<<" ,because it has more than required corrects."<<endl;
        exit(1);
    }
} SSE ;
MULTISEL: MSS {
    qm[$1]++;
    marks += $1;
    ch=0;
    c=0;
} QUES{
    if(ch < 3 || ch >4){
        printall();
        cout<<"Error till line: "<<yylineno<<" ,because it has incorrect number of choices."<<endl;
        exit(1);
    }
    if(c>ch){
        printall();
        cout<<"Error till line: "<<yylineno<<" ,because it has more than required corrects."<<endl;
        exit(1);
    }
} MSE;

QUES: %empty | CHOICE{ch++;} QUES | CORRECT{c++;} QUES ;
CHOICE: CHS CHE ;
CORRECT: COS COE ;

%%


int main(int argc ,char* argv[]){

    yyin = fopen(argv[1], "r");
    //yyrestart(yyin);
    yyparse();
    printall();
    fclose(yyin);
}

void yyerror(const char *s){
    printall();
    cout<<"Error found at line number: "<<yylineno<<endl;
    cout<< "error for text in yerror : " << yytext << endl;
    exit(1);
}
