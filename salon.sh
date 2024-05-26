#!/bin/bash
 
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"


 echo -e "\n~~~~~ Salon Shop ~~~~~\n"

 echo -e "\nWelcome to CleanCut Salon, How may we help you\n"

SERVICE_MENU(){
if [[ $1 ]]
  then
    echo -e "\n$1"
  fi


  AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY  service_id" | sed -E 's/ \|/)/')
  
  echo -e "\nPick a number from the following services\n"
  echo "$AVAILABLE_SERVICES"

  read SERVICE_ID_SELECTED

  SERVICE_SELECTED=$($PSQL "SELECT service_id FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
  
  if [[ -z $SERVICE_SELECTED ]]
  
  then
  SERVICE_MENU "\nThe service you have chosen does not exist\n"

  else

  echo "What is your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_PHONE_INPUT=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")

  if [[ -z $CUSTOMER_PHONE_INPUT ]]
  then
   echo "I don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    echo "What time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
    read SERVICE_TIME
    CUSTOMER_INFO_INPUT=$($PSQL "INSERT INTO customers (name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
   
    CUSTOMER_ID_INPUT=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME'")
    APPOINTMENT_INFO_INPUT=$($PSQL "INSERT INTO appointments (service_id, customer_id, time) VALUES ($SERVICE_ID_SELECTED, $CUSTOMER_ID_INPUT, '$SERVICE_TIME')")
    
    echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
    else

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    
    echo "What time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"

    read SERVICE_TIME 

    CUSTOMER_ID_INPUT=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    APPOINTMENT_INFO_INPUT=$($PSQL "INSERT INTO appointments (service_id, customer_id, time) VALUES ($SERVICE_ID_SELECTED, $CUSTOMER_ID_INPUT, $SERVICE_TIME)")
    
    echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

    fi 

    



  fi

}


SERVICE_MENU