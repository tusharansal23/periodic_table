#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

ELEMENT=$($PSQL "SELECT elements.atomic_number
FROM elements
WHERE elements.atomic_number::VARCHAR = '$1'
OR elements.symbol = '$1'
OR elements.name = '$1'")

if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
  exit
fi

DATA=$($PSQL "SELECT elements.atomic_number,
elements.name,
elements.symbol,
types.type,
properties.atomic_mass,
properties.melting_point_celsius,
properties.boiling_point_celsius
FROM elements
JOIN properties USING(atomic_number)
JOIN types USING(type_id)
WHERE elements.atomic_number = $ELEMENT")

IFS='|' read -r ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$DATA"

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
