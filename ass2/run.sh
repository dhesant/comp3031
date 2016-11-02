#!/bin/bash

bison -d setfunc.y
flex -o setfunc.lex.yy.c setfunc.lex
gcc *.c -o test -lm
./test testcase.txt
