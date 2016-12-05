#!/bin/bash

if [ "$#" -ne "2" ]; then
    echo " USAGE: chatbot_training_server.sh COMMAND PROJECT_NAME "
    echo "        where COMMAND is start, check, stop, or remove."
    exit
fi

CMD="$1"
PROJ_NAME="$2"
TEST_FILE=${PROJ_NAME}.test.txt
TRAIN_FILE=${PROJ_NAME}.train.txt
SRC_DIR="/data1/MindsBot/data"
TAR_DIR="/data1/MindsBot/data/Project/${PROJ_NAME}"
BIN_DIR="/data1/MindsBot/bin"
CHECK_FILE="check.txt"

if [ "${CMD}" == "start" ]; then
    
    echo -e "\n # Check if ${TEST_FILE} exists."
    if [ ! -f "${SRC_DIR}/${TEST_FILE}" ]; then
        echo -e " @ Error: test file not found ${TEST_FILE}"
        exit
    fi
    
    echo -e "\n # Check if ${TRAIN_FILE} exists."
    if [ ! -f ${SRC_DIR}/${TRAIN_FILE} ]; then
        echo -e " @ Error: train file not found ${TRAIN_FILE}"
        exit
    fi
    
    echo -e "\n # Check if ${TAR_DIR} exists."
    if [ -d ${TAR_DIR} ]; then
        echo -e "\n @ Error: ${TAR_DIR} directory already exists.\n"
        exit
    fi
    
    echo -e "\n # Make project directory, ${PROJ_NAME} and copy the test and train files to it"
    mkdir ${TAR_DIR}
    mv -f ${SRC_DIR}/${TEST_FILE} ${TAR_DIR}
    mv -f ${SRC_DIR}/${TRAIN_FILE} ${TAR_DIR}
    
    echo -e "\n # Run preprocessing."
    cd ${SRC_DIR}; ./mk_data.sh ${PROJ_NAME}
    
    
    echo -e "\n # Run training ..."
    cd ${BIN_DIR}
    THEANO_FLAGS=device=gpu nohup python train.py ${PROJ_NAME} kor > ${PROJ_NAME}.log 2>&1 &
    echo " # Training process"
    ps -efl | grep "python.*${PROJ_NAME}" | grep -v grep
    echo -e "\n # Check the result in a few hours...\n"
    
elif [ "${CMD}" == "check" ]; then

    ps aux | grep -e python | grep -e ${PROJ_NAME} | grep -v grep > ${CHECK_FILE}

    if [ ! -s ${CHECK_FILE} ]; then
        echo -e "\n # Training process for ${PROJ_NAME} doesn't exist. Training might be done.\n"
    else
        echo -e "\n # Training process for ${PROJ_NAME} is still running...\n"
    fi
    
elif [ "${CMD}" == "stop" ]; then

    PID=$(ps aux | grep -E "python.*${PROJ_NAME}" | grep -v grep | awk '{print $2;}');
    if [ -z ${PID} ]; then
        echo -e "\n # Training process for ${PROJ_NAME} doesn't exist. Training might be done.\n"
    else
        echo -e "\n # Training process for ${PROJ_NAME} is going to be killed.\n"
        kill -9 ${PID}
    fi

elif [ "${CMD}" == "remove" ]; then

    PID=$(ps aux | grep -E "python.*${PROJ_NAME}" | grep -v grep | awk '{print $2;}');
    if [ -z ${PID} ]; then
        echo -e "\n # Training process for ${PROJ_NAME} doesn't exist. Training might be done.\n"
    else
        echo -e "\n # Training process for ${PROJ_NAME} is killed.\n"
        kill -9 ${PID}
    fi

    echo -e " # Training directory, ${TAR_DIR} is deleted.\n"
    rm -rf ${TAR_DIR}

elif [ "${CMD}" == "update" ]; then

    PID=$(ps aux | grep "server.py" | grep -v grep | awk '{print $2;}');
    if [ -z ${PID} ]; then
        echo -e "\n @ Warning: server process not found.\n"
    else
        echo -e "\n # Server is reloaded.\n"
        kill -9 ${PID}
        cd ${BIN_DIR}
        python server_html.py ${PROJ_NAME} > ${PROJ_NAME}_server.log 2>&1 &
        echo -e "\n # Now, you can check the chatbot training result from http://52.34.51.12:8990/?query=\${YOUR_QUESTION}"
    fi

else
    
    echo -e "\n @ Error: command not found, ${CMD}.\n"
    exit

fi
