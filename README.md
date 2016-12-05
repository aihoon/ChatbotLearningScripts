# Chatbot Training Scripts
This is a repository to manage the chatbot training scripts.

## Prerequisite

### Windows OS
* Install OpenSSH via https://sourceforge.net/projects/sshwindows/files/latest/download
* Install WinScp via https://winscp.net/dwonload/WinSCP-5.9.3-Setup.exe

### OS X
* None

### Ubuntu
* None

## How to train Korean chatbot

0. Prepare ${PROJECT_NAME}.test.txt and {$PROJECT_NAME}.train.txt in any directory(${BIN}).

1. Open Windows Console and go to ${BIN} directory.

2. Copy three files from this repository to ${BIN} directory.

3. Execute training_chatbot_client script with appropriate three input arguments.<br/>
   BASH/DOS> ***chatbot_training_client.{sh,bat} start ${PROJECT_NAME} ${SERVER_NUM}*** <br/>
   where ${SERVER_NUM} is the last IP of the server based on 10.122.64.\* <br/>

4. [Optional] <br/>
   If you want, you can check whether the training is still running or not. <br/>
   BASH/DOS> ***training_chatbot_client.{sh,bat} check ${PROJECT_NAME} ${SERVER_NUM}*** <br/>

5. [Optional] <br/>
   If you find something wrong, you can stop the training at any time. <br/>
   BASH/DOS> ***training_chatbot_client.{sh,bat} stop ${PROJECT_NAME} ${SERVER_NUM}*** <br/>

6. [Optional] You can remove all the information in the directory, /data1/MindsBot/data/Project/${PROJECT_NAME}. <br/>
   BASH/DOS> ***training_chatbot_client.sh remove ${PROJECT_NAME} ${SERVER_NUM}*** <br/>

7. You can update chatbot server, 52.34.51.12:8990, with the {$PROJECT_NAME} training. <br/>
   BASH/DOS> ***training_chatbot_client.sh update ${PROJECT_NAME} ${SERVER_NUM}*** <br/>

## Note

1. You MUST type the password of the server whenever you try to connect to the server with scp or ssh.
