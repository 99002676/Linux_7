#!/bin/bash
RESULT_CSV="Results.csv"
printf "NAME,EMAIL,GIT-URL,CLONE-STATUS,BUILD-STATUS,CPPCHECK,VALGRIND
" > $RESULT_CSV
OLDIFS=$IFS
IFS=','
while IFS=',' read -r NAME EMAIL REPO; do
    [[ $NAME != 'Name' ]] && printf "$NAME," >> $RESULT_CSV 
    [[ $EMAIL != 'EmailID' ]] && printf "$EMAIL," >> $RESULT_CSV
    if [ "$REPO" != 'Repo_link' ]; then
        printf "$REPO," >> $RESULT_CSV
        
        git clone "$REPO"
        [[ $? == 0 ]] && printf "Clone Success," >> $RESULT_CSV
        [[ $? != 0 ]] && printf "Clone failed," >> $RESULT_CSV
        
        REPO=`echo "$REPO" | cut -d'/' -f5`
        MAKE_DIR=`find "$REPO" -name "Makefile" -exec dirname {} \;`
        make -C "$MAKE_DIR"
		
        [[ $? == 0 ]] && printf "build Success," >> $RESULT_CSV
        [[ $? != 0 ]] && printf "build failed," >> $RESULT_CSV
        
        ERRORS=`cppcheck "$MAKE_DIR" | grep 'error' | wc -l`
        printf "$ERRORS," >> $RESULT_CSV
        make test -C "$MAKE_DIR"
        
        EXE=`find "$MAKE_DIR" -name "Test*.out"`
        valgrind "./$EXE" 2>> valgrinderr.csv
        VALGRINDERR=`grep "ERROR SUMMARY" valgrinderr.csv`
        printf "${VALGRINDERR:25:1} \n" >> $RESULT_CSV
        
    fi
done < Input.csv
IFS=$OLDIFS