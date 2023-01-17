#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
 
 
 if [[ -z $1 ]]
 then
 echo  'Please provide an element as an argument.'
 else
   if [[  $1 =~ ^[0-9]+$ ]] 
   then
   ELEMENT_TABLE=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) WHERE atomic_number=$1;")
   else
   ELEMENT_TABLE=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) WHERE symbol='$1' OR name='$1';")
   fi
   if [[ -z $ELEMENT_TABLE ]]
   then
   echo 'I could not find that element in the database.'
   else
    echo "$ELEMENT_TABLE" | while IFS=" |" read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
   do
   TYPE_NAME=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE;")
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE_NAME, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
   done 
   fi
 fi
