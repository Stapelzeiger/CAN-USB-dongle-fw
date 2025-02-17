##############################################################################
# Build global options
#

# Compiler options here.
USE_OPT = -Os -ggdb -fomit-frame-pointer -falign-functions=16

# C specific options here (added to USE_OPT).
USE_COPT =

# C++ specific options here (added to USE_OPT).
USE_CPPOPT = -fno-rtti

# Enable this if you want the linker to remove unused code and data
USE_LINK_GC = yes

# Linker extra options here.
USE_LDOPT =

# Enable this if you want link time optimizations (LTO)
USE_LTO = no

# If enabled, this option allows to compile the application in THUMB mode.
USE_THUMB = yes

# Enable this if you want to see the full log while compiling.
USE_VERBOSE_COMPILE = no

# If enabled, this option makes the build process faster by not compiling
# modules not used in the current configuration.
USE_SMART_BUILD = no

#
# Build global options
##############################################################################

##############################################################################
# Architecture or project specific options
#

# Stack size to be allocated to the Cortex-M process stack. This stack is
# the stack used by the main() thread.
USE_PROCESS_STACKSIZE = 0x400

# Stack size to the allocated to the Cortex-M main/exceptions stack. This
# stack is used for processing interrupts and exceptions.
USE_EXCEPTIONS_STACKSIZE = 0x400

# Enables the use of FPU on Cortex-M4 (no, softfp, hard).
USE_FPU = no

#
# Architecture or project specific options
##############################################################################

##############################################################################
# Project, sources and paths
#

TARGET = CAN-USB-dongle-RevA

ifeq ($(TARGET), nucleo)
include src/board/nucleo/board.mk
LDSCRIPT = rules/STM32F302x8.ld
endif

ifeq ($(TARGET), CAN-USB-dongle-RevA)
include src/board/CAN-USB-dongle/RevA/board.mk
LDSCRIPT = rules/STM32F302x8.ld
endif

# Define project name here
PROJECT = firmware

# Imported source files and paths
CHIBIOS = ChibiOS
# Startup files.
include $(CHIBIOS)/os/common/ports/ARMCMx/compilers/GCC/mk/startup_stm32f3xx.mk
# HAL-OSAL files (optional).
include $(CHIBIOS)/os/hal/hal.mk
include $(CHIBIOS)/os/hal/ports/STM32/STM32F3xx/platform.mk
include $(CHIBIOS)/os/hal/osal/rt/osal.mk
# RTOS files (optional).
include $(CHIBIOS)/os/rt/rt.mk
include $(CHIBIOS)/os/rt/ports/ARMCMx/compilers/GCC/mk/port_v7m.mk
# Project sources
include src/src.mk

# C sources that can be compiled in ARM or THUMB mode depending on the global
# setting.
CSRC = $(STARTUPSRC) \
       $(KERNSRC) \
       $(PORTSRC) \
       $(OSALSRC) \
       $(HALSRC) \
       $(PLATFORMSRC) \
       $(CHIBIOS)/os/hal/lib/streams/chprintf.c \
	   $(BOARDSRC) \
	   $(PROJCSRC)

# C++ sources that can be compiled in ARM or THUMB mode depending on the global
# setting.
CPPSRC = $(PROJCPPSRC)

# List ASM source files here
ASMSRC = $(STARTUPASM) $(PORTASM) $(OSALASM) $(PROJASMSRC)

INCDIR = $(STARTUPINC) $(KERNINC) $(PORTINC) $(OSALINC) \
         $(HALINC) $(PLATFORMINC) $(CHIBIOS)/os/various \
         $(CHIBIOS)/os/hal/lib/streams $(PROJINC) $(BOARDINC)

#
# Project, sources and paths
##############################################################################

##############################################################################
# Compiler settings
#

MCU  = cortex-m4

#TRGT = arm-elf-
TRGT = arm-none-eabi-
CC   = $(TRGT)gcc
CPPC = $(TRGT)g++
# Enable loading with g++ only if you need C++ runtime support.
# NOTE: You can use C++ even without C++ support if you are careful. C++
#       runtime support makes code size explode.
LD   = $(TRGT)gcc
#LD   = $(TRGT)g++
CP   = $(TRGT)objcopy
AS   = $(TRGT)gcc -x assembler-with-cpp
AR   = $(TRGT)ar
OD   = $(TRGT)objdump
NM   = $(TRGT)nm
SZ   = $(TRGT)size
HEX  = $(CP) -O ihex
BIN  = $(CP) -O binary

# ARM-specific options here
AOPT =

# THUMB-specific options here
TOPT = -mthumb -DTHUMB

# Define C warning options here
CWARN = -Wall -Wextra -Wundef -Wstrict-prototypes

# Define C++ warning options here
CPPWARN = -Wall -Wextra -Wundef

#
# Compiler settings
##############################################################################

##############################################################################
# Start of user section
#

# List all user C define here, like -D_DEBUG=1
UDEFS =

# Define ASM defines here
UADEFS =

# List all user directories here
UINCDIR =

# List the user directory to look for the libraries here
ULIBDIR =

# List all user libraries here
ULIBS =

#
# End of user defines
##############################################################################

GLOBAL_SRC_DEP = src/src.mk

RULESPATH = rules
include $(RULESPATH)/rules.mk

CMakeLists.txt: package.yml
	python packager/packager.py

.PHONY: tests
tests: CMakeLists.txt
	@mkdir -p build/tests
	@cd build/tests; \
	cmake ../..; \
	make ; \
	./tests;

.PHONY: flash
flash: build/$(PROJECT).elf
	openocd -f openocd.cfg -c "program build/$(PROJECT).elf verify reset" -c "shutdown"

.PHONY: dfu
dfu: build/$(PROJECT).bin
	dfu-util -a 0 -d 0483:df11 --dfuse-address 0x08000000 -D build/$(PROJECT).bin