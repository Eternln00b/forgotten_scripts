# compiler settings
CC = gcc
FLAGS = -s -Wall -Wextra -Wno-unused-parameter -Wno-unused-variable
OPT_FLAG= -O2 -Ofast

# src file
SRC_FILE = bin/main.c bin/textlamba.c
BIN_NAME = bin/textioconv

# bash scripts
MAIN_SCRIPT = scripts/textioconvshell.sh
TEST_SCRIPT = scripts/textioconvshell-Test.sh

# installations path
BIN_PATH = /usr/local/bin/textioconv
MAIN_SCRIPT_PATH = /usr/local/games/textioconvshell
TST_SCRIPT_PATH = /usr/local/games/textioconvshell-test

# Default target
all:
	@${CC} ${SRC_FILE} ${FLAGS} ${OPT_FLAG} -o ${BIN_NAME}
	@printf "The tool has been compiled under the name ${BIN_NAME}\n"

# toolkit installation
install:
ifneq ($(shell id -u), 0)
	@printf "\nYou have to install this tool as root.\n"
	@exit
else
	@${CC} ${SRC_FILE} ${FLAGS} ${OPT_FLAG} -o ${BIN_PATH}
	@cp ${MAIN_SCRIPT} ${MAIN_SCRIPT_PATH}
	@cp ${TEST_SCRIPT} ${TST_SCRIPT_PATH}
	@chmod +x ${BIN_PATH} ${MAIN_SCRIPT_PATH} ${TST_SCRIPT_PATH}
	@printf "\nThe toolkit has been installed under the name ${MAIN_SCRIPT_PATH}\n"
endif

# toolkit uninstallation
uninstall:
ifneq ($(shell id -u), 0)
	@printf "\nYou have to uninstall this tool as root.\n"
	@exit
else
	@printf "\nThe toolkit is going to be uninstalled.\n\n"
	@[ -f ${BIN_PATH} ] && rm ${BIN_PATH} || printf "${BIN_PATH} wasn't installed.\n"
	@[ -f ${MAIN_SCRIPT_PATH} ] && rm ${MAIN_SCRIPT_PATH} || printf "${MAIN_SCRIPT_PATH} wasn't installed.\n"
	@[ -f ${TST_SCRIPT_PATH} ] && rm ${TST_SCRIPT_PATH} || printf "${TST_SCRIPT_PATH} wasn't installed.\n"
	@printf "\nThe uninstallation process is over.\n"
endif

# Clean default target
clean:
	@printf "\nThe compiled bin ${BIN_NAME} is going to be delete\n"
	@[ -f ${BIN_NAME} ] && rm ${BIN_NAME} || printf "${BIN_NAME} wasn't compiled.\n"
