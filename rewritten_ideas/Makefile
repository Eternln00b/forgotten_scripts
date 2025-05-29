# Compilation information
CC_X86_64 = x86_64-w64-mingw32-gcc
CC_i686 = i686-w64-mingw32-gcc
FLAGS_i686 = -m32 -s -Wall -Wextra -Wno-unused-parameter -Wno-unused-variable
FLAGS_x86_64 = -m64 -s -Wall -Wextra -Wno-unused-parameter -Wno-unused-variable

# Necessary file information
SRC_FILES = src/main.c src/shellcodefuncs.c

# Backdoor .exe names 
BIN_i686 = backdoor-i686.exe
BIN_X86_64 = backdoor-X86_64.exe

# Default target
all: x86_64

# Compile for x86_64 architecture
x86_64:
	@${CC_X86_64} ${FLAGS_x86_64} ${SRC_FILES} -o ${BIN_X86_64}
	@printf "\n[!] The backdoor has been compiled for the x86_64 architecture under the name ${BIN_X86_64}\n"

# Compile for i686 architecture
i686:
	@${CC_i686} ${FLAGS_i686} ${SRC_FILES} -o ${BIN_i686}
	@printf "\n[!] The backdoor has been compiled for the i686 architecture under the name ${BIN_i686}\n"

# Clean target
clean:
	@printf "\n[x] The backdoor ${BIN_X86_64} is going to be delete for good.\n"
	@[ -f ${BIN_X86_64} ] && rm ${BIN_X86_64} || printf "The backdoor ${BIN_X86_64} wasn't compiled...\n"
	@printf "\n[x] The backdoor ${BIN_i686} is going to be delete for good.\n"
	@[ -f ${BIN_i686} ] && rm ${BIN_i686} || printf "The backdoor ${BIN_i686} wasn't compiled...\n"

