%{
#define YYSTYPE char *
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAXN 10000
#define MAXL 5000
int yyerror(const char* s);
int yylex(void);
FILE *yyin;

char *MinusSet(const char *p1, const char *p2);
char *UnionSet(const char *p1, const char *p2);
char *IntersectSet(const char *p1, const char *p2);
char *Max(const char *p1);
char *Min(const char *p1);
void OutputRes(char *p1);

void AppendIntToStr(char* str, int num);
void Expand(char* str);
void RmRedunInt(char *str_to_out);
void StrToIntList(char *str, int list[], int *count);
int IsExist(int target, int list[], int length);
void IntListToStr(int list[], int length,char *str);
void RmWs(char* str);
char *FFormat(const char* str);
%}
%token NUM
%token LB RB BRACE SET INTERSECT UNION MAX MIN
%left '-'
%%
/* grammar rules and actions follow in {}*/

input: input line
	| line
	;

line: 	'\n'
        | expr '\n' {printf("res %s\n",$1);OutputRes($1);}
	;
// start of your grammar rules and actions
expr : expr '-' expr2        {$$ = MinusSet($1, $3);}
     | expr2                 {$$ = $1;}
     ;

expr2: expr2 INTERSECT expr3 {$$ = IntersectSet($1, $3);}
     | expr2 UNION expr3     {$$ = UnionSet($1, $3);}
     | expr3                 {$$ = $1;}
     ;

expr3: MAX expr3             {$$ = Max($1);}
     | MIN expr3	     {$$ = Min($1);}
     | expr4		     {$$ = $1;}
     ;

expr4: SET                   {$$ = FFormat($1);}	
     | LB expr RB            {$$ = $2;}	
     ;

/* set  : '{' vec '}'           {$$ = Expand($0);} */
/*      | "{}"		     {$$ = "";} */
/*      ; */

/* vec  : NUM ',' vec           {$$ = $0;}	 */
/*      | incre ',' vec	     {$$ = $0;}	 */
/*      | NUM                   {$$ = $1;}	 */
/*      | incre		     {$$ = $1;}	 */
/*      ; */

/* incre: NUM '-' NUM           {$$ = Expand($0);} */
/*      ; */

// end of your grammar rules and actions
%%
#include<ctype.h>
int main(int argc, char *argv[]){
	// clear the result file
	FILE *fp = fopen("results.txt","w");
	if(fp==NULL){printf("fail to output\n");return -1;}
	fclose(fp);
	// load the testcases
	fp = fopen(argv[1], "r");
    	if (!fp)
    	{
        	printf ("Error reading file!\n");
        	return -1;
    	}
	// pass the testcases to parser
    	yyin = fp;
	return yyparse();
}
int yyerror(const char* s)
{
    extern int yylineno;
    extern char *yytext;
    printf("\n^%d: %s at %s #%d\n", yylineno, s, yytext, (int)(*yytext));
    return 0;
}

void AppendIntToStr(char* str, int num){
	char str_num[50];
	strcpy(str_num,"");
	sprintf(str_num,"%d",num);
	strcat(str,str_num);
	memset(str_num,0,sizeof(str_num));
	return;
}

void Expand(char *str){
	int i,j, len, outlen = 0, num1, num2,len1 = 0, len2 = 0,curr_num = 0;
	char temp_sbl;
	char str_to_out[MAXL];
	len = strlen(str);
	if(len <= 2)
		return;
	for(i = 0 ;i  < len; i ++){
		temp_sbl = str[i];
		if(temp_sbl == '{'){
			str_to_out[outlen] = temp_sbl;
			outlen++;
			continue;
		}
		if(temp_sbl == '-'){
			num1 = curr_num;
			num2 = 0;
			curr_num = 0;
			for(j = i + 1; j <len; j ++){
				if(!isdigit(str[j])){
					break;
				}
				num2 = num2 * 10 + str[j] - '0';
			}
			i = j;
			if(num1 <= num2){
				for(j = num1; j <=num2; j++){
					str_to_out[outlen] = '\0';
					AppendIntToStr(str_to_out,j);
					outlen = strlen(str_to_out);
					if(j<num2){
						str_to_out[outlen] = ',';
						outlen++;
					}
					str_to_out[outlen] = '\0';
				}
			}
			else{
				for(j = num2; j <=num1; j++){
					str_to_out[outlen] = '\0';
					AppendIntToStr(str_to_out,j);
					outlen = strlen(str_to_out);
					if(j<num1){
						str_to_out[outlen] = ',';
						outlen++;
					}
					str_to_out[outlen] = '\0';
				}				
			}
			str_to_out[outlen] = str[i];
			outlen++;
			continue;
		}
		if(temp_sbl == ',' || temp_sbl == '}'){
			str_to_out[outlen] = '\0';
			AppendIntToStr(str_to_out,curr_num);
			outlen = strlen(str_to_out);
			str_to_out[outlen] = temp_sbl;
			outlen++;
			str_to_out[outlen] = '\0';
			curr_num = 0;
			if(temp_sbl == '}')
				break;
			continue;
		}
		curr_num = curr_num * 10 + str[i] - '0';

	}
	str_to_out[outlen] = '\0';
	memset(str,0,sizeof(str));
	RmRedunInt(str_to_out);
	str[0] = '\0';
	strcpy(str,str_to_out);
	memset(str_to_out,0,sizeof(str_to_out));
	return;
}

char *FFormat(const char* str){
	char temp[MAXL],*a;
	int i, j ,len;
	a = (char*)malloc(sizeof(a)*MAXL);
	strcpy(temp,str);
	RmWs(temp);
	Expand(temp);
	len = strlen(temp);
	for(i=0; i < len; i ++){
		a[i] = temp[i];
	}
	a[i] = '\0';
	return a;
}

char *IntersectSet(const char *p1, const char *p2){
	int l1 = strlen(p1), l2 = strlen(p2),count = 0;
	int i, ls1[MAXL],ls2[MAXL],lsout[MAXL],num1=0,num2=0;
	char *a, *np1,*np2,npout[MAXL];
	a = (char*)malloc(sizeof(char)*MAXL);
	np1 = (char*)malloc(sizeof(char)*MAXL);
	np2 = (char*)malloc(sizeof(char)*MAXL);
	np1 = FFormat(p1);
	np2 = FFormat(p2);
	StrToIntList(np1,ls1,&num1);
	StrToIntList(np2,ls2,&num2);
	for(i=0;i<num1;i++){
		if(IsExist(ls1[i],ls2,num2)>0){
			lsout[count] = ls1[i];
			count++;
		}
	}
	memset(a,0,sizeof(a));
	if(count == 0){
		strcpy(a,"{}");
	}
	else{
		IntListToStr(lsout,count,npout);
		strcpy(a,npout);
	}
	memset(ls1,0,sizeof(ls1));
	memset(ls2,0,sizeof(ls2));
	memset(lsout,0,sizeof(lsout));
	memset(np1,0,sizeof(np1));
	memset(np2,0,sizeof(np2));
	memset(npout,0,sizeof(npout));
	return a;
}

void IntListToStr(int list[], int length,char *str){
	int i,j, len = 0;
	char str_num[50];
	str[0] = '{';
	len = 1;
	str[len] = '\0';
	for(i = 0 ; i < length; i ++){
		memset(str_num,0,sizeof(str_num));
		sprintf(str_num,"%d",list[i]);
		strcat(str,str_num);
		len = strlen(str);
		if(i < length - 1)
			str[len] = ',';
		else
			str[len] = '}';
		len++;
		str[len] = '\0';
	}
	str[len] = '\0';
	memset(str_num,0,sizeof(str_num));
	return;
}

int IsExist(int target, int list[], int length){
    if(length==0)
        return 0;
    int i;
    for(i=0;i<length;i++)
        if(list[i]==target)
            return i+1;
    return 0;
}

char *Max(const char *p1){
	int l1 = strlen(p1),count = 0;
	int i, ls1[MAXL],lsout[MAXL],num1=0,num2=0;
	int max = -1;
	char *np1,npout[MAXL],*a;
	a = (char*)malloc(sizeof(char)*MAXL);
	np1 = (char*)malloc(sizeof(char)*MAXL);
	np1 = FFormat(p1);
	StrToIntList(np1,ls1,&num1);
	for(i=0;i<num1;i++){
		if(ls1[i] > max){
			max = ls1[i];
		}
	}
	memset(a,0,sizeof(a));
	if(max < 0){
		strcpy(a,"{}");
		return a;
	}
	lsout[0] = max;
	count++;
	IntListToStr(lsout,count,npout);
	strcpy(a,npout);
	memset(ls1,0,sizeof(ls1));
	memset(lsout,0,sizeof(lsout));
	memset(np1,0,sizeof(np1));
	memset(npout,0,sizeof(npout));
	return a;
}

char *Min(const char *p1){
	int l1 = strlen(p1),count = 0;
	int i, ls1[MAXL],lsout[MAXL],num1=0,num2=0;
	int min = MAXN;
	char *np1,npout[MAXL],*a;
	a = (char*)malloc(sizeof(char)*MAXL);
	np1 = (char*)malloc(sizeof(char)*MAXL);
	np1 = FFormat(p1);
	StrToIntList(np1,ls1,&num1);
	for(i=0;i<num1;i++){
		if(ls1[i] < min){
			min = ls1[i];
		}
	}
	memset(a,0,sizeof(a));
	if(min == MAXN){
		strcpy(a,"{}");
		return a;
	}
	lsout[0] = min;
	count++;
	IntListToStr(lsout,count,npout);
	strcpy(a,npout);
	memset(ls1,0,sizeof(ls1));
	memset(lsout,0,sizeof(lsout));
	memset(np1,0,sizeof(np1));
	memset(npout,0,sizeof(npout));
	return a;
}

char *MinusSet(const char *p1, const char *p2){
	int l1 = strlen(p1), l2 = strlen(p2),count = 0;
	int i, ls1[MAXL],ls2[MAXL],lsout[MAXL],num1=0,num2=0;
	char *a, *np1,*np2,npout[MAXL];
	a = (char*)malloc(sizeof(char)*MAXL);
	np1 = (char*)malloc(sizeof(char)*MAXL);
	np2 = (char*)malloc(sizeof(char)*MAXL);
	np1 = FFormat(p1);
	np2 = FFormat(p2);
	StrToIntList(np1,ls1,&num1);
	StrToIntList(np2,ls2,&num2);
	for(i=0;i<num1;i++){
		if(IsExist(ls1[i],ls2,num2)==0){
			lsout[count] = ls1[i];
			count++;
		}
	}
	memset(a,0,sizeof(a));
	if(count == 0){
		strcpy(a,"{}");
	}
	else{
		IntListToStr(lsout,count,npout);
		strcpy(a,npout);
	}
	memset(ls1,0,sizeof(ls1));
	memset(ls2,0,sizeof(ls2));
	memset(lsout,0,sizeof(lsout));
	memset(np1,0,sizeof(np1));
	memset(np2,0,sizeof(np2));
	memset(npout,0,sizeof(npout));
	return a;
}

void OutputRes(char *p1){
	FILE *fp = fopen("results.txt","a");
	if(fp==NULL){printf("fail to output\n");return;}
	fprintf(fp,"%s\n",p1);
	fclose(fp);
	return;
}

void RmRedunInt(char *str_to_out){
	int i,j ,len;
	int ls_num[1000],count = 0, temp_ls[1000], tempcount = 0;
	char str_temp[MAXL];
	strcpy(str_temp,"");
	str_temp[0] = '\0';
	StrToIntList(str_to_out,temp_ls,&tempcount);
	for(i = 0; i < tempcount; i ++){
		if(IsExist(temp_ls[i],ls_num,count))
			continue;
		ls_num[count] = temp_ls[i];
		count++;
	}
	IntListToStr(ls_num,count,str_temp);
	memset(str_to_out,0,sizeof(str_to_out));
	strcpy(str_to_out,str_temp);
	memset(str_temp,0,sizeof(str_temp));
	return;
}

void StrToIntList(char *str, int list[], int *count){
	int i, j , tempcount = 0, temp_ls[1000], len = strlen(str);
	int curr_num = 0;
	if(len <= 2){
		*count = 0;
		return;
	}
	for(i = 0 ; i < len ; i ++){
		if(str[i] == '{')
			continue;
		if(str[i] == ',' || str[i] == '}'){
			list[tempcount] = curr_num;
			tempcount++;
			curr_num = 0;
			continue;
		}
		curr_num = curr_num * 10 + str[i] - '0';
	}
	*count = tempcount;
	return;
}

char *UnionSet(const char *p1, const char *p2){
	int l1 = strlen(p1), l2 = strlen(p2),count = 0;
	int i, ls1[MAXL],ls2[MAXL],lsout[MAXL],num1=0,num2=0;
	char *a, *np1,*np2,npout[MAXL];
	a = (char*)malloc(sizeof(char)*MAXL);
	np1 = (char*)malloc(sizeof(char)*MAXL);
	np2 = (char*)malloc(sizeof(char)*MAXL);
	np1 = FFormat(p1);
	np2 = FFormat(p2);
	StrToIntList(np1,ls1,&num1);
	StrToIntList(np2,ls2,&num2);
	for(i=0;i<num1;i++){
		lsout[count] = ls1[i];
		count++;
	}
	for(i=0;i<num2;i++){
		if(IsExist(ls2[i],lsout,count)==0){
			lsout[count] = ls2[i];
			count++;
		}
	}
	memset(a,0,sizeof(a));
	if(count == 0){
		strcpy(a,"{}");
	}
	else{
		IntListToStr(lsout,count,npout);
		strcpy(a,npout);
	}
	memset(ls1,0,sizeof(ls1));
	memset(ls2,0,sizeof(ls2));
	memset(lsout,0,sizeof(lsout));
	memset(np1,0,sizeof(np1));
	memset(np2,0,sizeof(np2));
	memset(npout,0,sizeof(npout));
	return a;
}
