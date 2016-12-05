#!/bin/bash

# Check input arguments...
if [ "$#" -ne "3" ] 
then
    echo 
    echo "   # USAGE"
    echo "     $ chatbot_training_client.sh COMMAND PROJECT_NAME SERVER_NUMBER"
    echo "       where COMMAND is start, check, stop, remove, or update."
    exit
fi

# Define variables...
CMD_TYPE="$1"
PROJ_NAME="$2"
SERVER_NUM="$3"
TEST_FILE=${PROJ_NAME}.test.txt
TRAIN_FILE=${PROJ_NAME}.train.txt
SERVER_IP=10.122.64.${SERVER_NUM}
BASE_DIR="/data1/MindsBot/data"
SCR_DIR="/data1/MindsBot/script"
SERVER_SH="chatbot_training_server.sh"


# if [ "${CMD_TYPE}" == "start" ]
#     then
#     echo "start"
# elif [ "${CMD_TYPE}" == "check" ]
#     then
#     echo "check"
# fi
# exit

if [ "${CMD_TYPE}" == "start" ]; then

    # Check if test file exists...
    if [ ! -f ${TEST_FILE} ]; then
        echo " @ Error: file not found, ${TEST_FILE}\n"
        exit
    fi

    # Check if train file exists...
    if [ ! -f ${TRAIN_FILE} ]; then
        echo " @ Error: file not found, ${TRAIN_FILE}.\n"
        exit
    fi

    echo -e "\n # Copy test and train files to server.\n"
    scp ${PROJ_NAME}.*.txt msl@${SERVER_IP}:${BASE_DIR}

    echo -e "\n # Copy scriptfile to server.\n"
    scp ${SERVER_SH} msl@${SERVER_IP}:${SCR_DIR}

    echo -e "\n # Run the server training script, \"${SERVER_SH}\".\n"
    SERVER_CMD="cd ${SCR_DIR};chmod u+x ${SERVER_SH}; ./${SERVER_SH} start ${PROJ_NAME}"
    ssh msl@${SERVER_IP} ${SERVER_CMD}

elif [ "${CMD_TYPE}" == "check"  || 
       "${CMD_TYPE}" == "stop"   || 
       "${CMD_TYPE}" == "remove" || 
       "${CMD_TYPE}" == "update" ]; then

    SERVER_CMD="cd ${SCR_DIR}; ./${SERVER_SH} ${CMD_TYPE} ${PROJ_NAME}"
    ssh msl@${SERVER_IP} ${SERVER_CMD}

else

    echo -e "\n command, \"${CMD_TYPE}\", is NOT defined.\n"

fi

