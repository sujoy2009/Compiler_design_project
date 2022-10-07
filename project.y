/* C Declarations */

%{
	#include<stdio.h>
        #include<math.h>
	int sym[26];
        int n=0,p=0;
	int fact=1;
	int i,j,gcd,lcm,s,t;
	int cnt=0;
	int flag=0;
	double y,x,l;
%}

/* bison declarations */

%token NUM VAR IF ELSE ELSIF WHILE FOR  CASE SWITCH BREAK DEFAULT INT FLOAT CHAR DOUBLE ID MAIN FACTORIAL PRINT GCD LCM TAN LN PRIME HEAD

%left '<' '>'
%left '+' '-'
%left '*' '/'

/* Grammar rules and actions follow.  */

%%
pre:  /* NULL */
      |HEAD     
      |pre start
      ;

start: /* NULL */
	|MAIN '('')' '<' program '>'	{printf("\nEND OF Block of main function.\n");}
	;

program: /* NULL */

	| program statement
	;
statement: ';'
	|SWITCH '(' VAR ')' '{' BASE '}'

	|TYPE VAR ';'	{ printf("\nValid declaration\n");}
	|TYPE VAR '=' NUM ';'	{ printf("\nValid assignment\n");}

	| expression ';' 	{ printf("Value of expression: %d\n", $1); }

        | VAR '=' expression ';' 	{ 
						sym[$1] = $3; 
                                                n = sym[$1];
				printf("Value of the variable: %d\t\n",$3);
					}

	| IF '(' expression ')' expression ';'  {
								if($3)
								{
									printf("Value of expression in IF: %d\n",$5);
								}
								else
								{
							     	printf("Condition value zero in IF block\n");
								}
							}

	| IF '(' expression ')' expression ';' ELSIF '(' expression ')' expression ';' ELSE expression ';'{
							if($3)
							{
			                                printf("Value of expression in IF: %d\n",$5);
							}
                                                        else if($9)
							{
			                                printf("Value of expression in ELSIF: %d\n",$11);
							}
						        else
						        {
			                                printf("Value of expression in ELSE: %d\n",$14);
					 		}
						}


	| IF '(' expression ')' expression ';' ELSE expression ';'{
							if($3)
							{
			printf("Value of expression in IF: %d\n",$5);
							}
						else
						{
			printf("Value of expression in IF: %d\n",$8);
								}
							   }
	| WHILE '(' expression ')' ';' {
                            printf("\nwhileLoop Started Here\n");
							while($3--) {
								printf("whileLoop Here :  %d\n", n);
							}
							printf("whileLoop Ended Here\n\n");				
						}
                     |FOR '(' expression ',' expression ')' ';' {
                            printf("\nfor Loop Started Here\n");
						int i=0;
	                                                                                for(i=$3;i<=$5;i++){
	                                                                                            printf("printing loop statement\n");
                                                                                                                                           }
	                                                                                                       printf("forLoop Ended Here\n\n");
 				
						}
	|IF '(' expression ')' '{' statement '}'

	|FACTORIAL '(' NUM ')' ';'	{$$ =$3;
				if($3<0)
					printf("\nError! Negative Number.\n");
				else{
					for(i=1;i<=$3;++i){
						fact*=i;
					}
				printf("Factorial of %d = %d\n",$3,fact);
				}
                                  }
	
	|PRIME '(' NUM ')' ';'	{$$ =$3;
				if($3<0)
					printf("\nError! Negative Number.\n");
				else{
					s=$3/2;
					for(t=2;t<=x;t++){
						if($3%t==0){
							printf("%d is not a prime number\n",$3);
							flag=1;
							break;
							}
					}
				if(flag==0){ printf("%d is a prime number\n",$3);}
				}
                                  }

	|PRINT '(' expression ')' ';'	{printf("%d\n",$3);}
	|GCD '(' expression ',' expression ')' ';'		{$$=$3,$5;
						for(j=1;j<=$3 && j<=$5;++j){
							if($3%j == 0 && $5%j == 0 )
								gcd = j;
						}
						printf("GCD of %d and %d = %d\n",$3,$5,gcd);
					}
	|LCM '(' expression ',' expression ')' ';'		{$$=$3,$5;
						lcm = ($3>$5)? $3 : $5;
						while(1){
							if(lcm%$3 == 0 && lcm%$5 == 0){
								printf("The LCM of %d and %d = %d\n",$3,$5,lcm);
								break;
							}
							++lcm;
						}
					}
	|TAN '(' expression ')' ';'		{$$=$3;
					x=$3*(3.142/180);
					y=tan(x);
					printf("Value of tan(%d) = %lf\n",$3,y);
					}

	|LN '(' expression ')' ';'		{$$=$3;
					l=log($3);
					printf("Value of ln(%d) = %lf\n",$3,l);
						}

	;

TYPE : INT	{ }

     | FLOAT	{ }

     | CHAR	{  }
     
     | DOUBLE	{  }
     ;


BASE : Base
     | Base Default
     ;

Base   : /*NULL*/
     | Base Case
     ;

Case    : CASE NUM ':' expression ';' BREAK ';' {
             if(n==$2){
                  cnt=1;
                  printf("\nTest  started here \nYour ID : %d  And You got %d points !! \nTest  ended\n\n",$2,$4);
             }
        }
     ;

Default    : DEFAULT ':' expression ';' BREAK ';'{
            if(cnt==0){
                printf("\nTest statement Started Here\nYou lost !!!\nTest ended\n\n");
            }
        }
     ; 

expression: NUM				{ $$ = $1; 	}

	| VAR				{ $$ = sym[$1]; }

	| expression '+' expression	{ $$ = $1 + $3; }

	| expression '-' expression	{ $$ = $1 - $3; }

	| expression '*' expression	{ $$ = $1 * $3; }

	| expression '/' expression	{ 	if($3) 
				  		{
				     			$$ = $1 / $3;
				  		}
				  		else
				  		{
							$$ = 0;
							printf("\ndivision by zero\t");
				  		} 	
				    	}

	| expression '<' expression	{ $$ = $1 < $3; }

	| expression '>' expression	{ $$ = $1 > $3; }

	| '(' expression ')'		{ $$ = $2;	}
	;
%%

int yywrap()
{
return 1;
}

yyerror(char *s){
	printf( "%s\n", s);
}