##########################################################################################################################
# File automatically-generated by tool: [projectgenerator] version: [3.10.0-B14] date: [Sat Nov 21 15:39:30 CET 2020] 
##########################################################################################################################

# ------------------------------------------------
# Generic Makefile (based on gcc)
#
# ChangeLog :
#	2017-02-10 - Several enhancements + project update mode
#   2015-07-22 - first version
# ------------------------------------------------

######################################
# target
######################################
TARGET = gw_base


######################################
# building variables
######################################
# debug build?
DEBUG = 1
# optimization
OPT = -Og


INTFLASH_BANK ?= 2

EXTFLASH_OFFSET ?= 1048576

EXTFLASH_SIZE_MB ?= 15

EXTFLASH_SIZE ?= $(shell echo "$$(( $(EXTFLASH_SIZE_MB) * 1024 * 1024 ))")



#######################################
# paths
#######################################
# Build path
BUILD_DIR = build

######################################
# source
######################################
# C sources
C_SOURCES =  \
Core/Src/lcd.c \
Core/Src/buttons.c \
Core/Src/main.c \
Core/Src/xip_from_flash.c \
Core/Src/gw_flash.c \
Core/Src/flashapp.c \
Core/Src/sha256.c \
Core/Src/stm32h7xx_it.c \
Core/Src/stm32h7xx_hal_msp.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_cortex.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_ltdc.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_ltdc_ex.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_rcc.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_rcc_ex.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_flash.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_flash_ex.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_gpio.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_hsem.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_dma.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_dma_ex.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_mdma.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_pwr.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_pwr_ex.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_i2c.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_i2c_ex.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_exti.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_tim.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_tim_ex.c \
Core/Src/system_stm32h7xx.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_spi.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_spi_ex.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_ospi.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_sai.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_sai_ex.c \
Core/Src/porting/zelda_assets.c \
zelda3/config.c \
zelda3/zelda_rtl.c \
zelda3/misc.c \
zelda3/nmi.c \
zelda3/poly.c \
zelda3/attract.c \
zelda3/snes/ppu.c \
zelda3/snes/dma.c \
zelda3/spc_player.c \
zelda3/util.c \
zelda3/audio.c \
zelda3/overworld.c \
zelda3/ending.c \
zelda3/select_file.c \
zelda3/dungeon.c \
zelda3/messaging.c \
zelda3/hud.c \
zelda3/load_gfx.c \
zelda3/ancilla.c \
zelda3/player.c \
zelda3/sprite.c \
zelda3/player_oam.c \
zelda3/snes/apu.c \
zelda3/snes/dsp.c \
zelda3/sprite_main.c \
zelda3/tagalong.c \
zelda3/third_party/opus-1.3.1-stripped/opus_decoder_amalgam.c \
zelda3/tile_detect.c \
zelda3/overlord.c \

# ASM sources
ASM_SOURCES =  \
startup_stm32h7b0xx.s


#######################################
# binaries
#######################################
PREFIX = arm-none-eabi-
# The gcc compiler bin path can be either defined in make command via GCC_PATH variable (> make GCC_PATH=xxx)
# either it can be added to the PATH environment variable.
ifdef GCC_PATH
CC = $(GCC_PATH)/$(PREFIX)gcc
AS = $(GCC_PATH)/$(PREFIX)gcc -x assembler-with-cpp
CP = $(GCC_PATH)/$(PREFIX)objcopy
SZ = $(GCC_PATH)/$(PREFIX)size
else
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc -x assembler-with-cpp
CP = $(PREFIX)objcopy
SZ = $(PREFIX)size
endif
HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S
 
#######################################
# CFLAGS
#######################################
# cpu
CPU = -mcpu=cortex-m7

# fpu
FPU = -mfpu=fpv5-d16

# float-abi
FLOAT-ABI = -mfloat-abi=hard

# mcu
MCU = $(CPU) -mthumb $(FPU) $(FLOAT-ABI)

# macros for gcc
# AS defines
AS_DEFS = 

# C defines
C_DEFS =  \
-DINTFLASH_BANK=$(INTFLASH_BANK) \
-DUSE_HAL_DRIVER \
-DSTM32H7B0xx


# AS includes
AS_INCLUDES = 

# C includes
C_INCLUDES =  \
-ICore/Inc \
-ICore/Inc/porting \
-IDrivers/STM32H7xx_HAL_Driver/Inc \
-IDrivers/STM32H7xx_HAL_Driver/Inc/Legacy \
-IDrivers/CMSIS/Device/ST/STM32H7xx/Include \
-IDrivers/CMSIS/Include \
-I. \


# compile gcc flags
ASFLAGS = $(MCU) $(AS_DEFS) $(AS_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

CFLAGS = $(MCU) $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections
CFLAGS += -DHEADLESS

ifeq ($(DEBUG), 1)
CFLAGS += -g -gdwarf-2 -O0
endif


# Generate dependency information
CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)"


#######################################
# LDFLAGS
#######################################


LDFLAGS += -Wl,--defsym=__EXTFLASH_OFFSET__=$(EXTFLASH_OFFSET)
LDFLAGS += -Wl,--defsym=__EXTFLASH_TOTAL_LENGTH__=$(EXTFLASH_SIZE)

ifeq ($(INTFLASH_BANK), 1)
	INTFLASH_ADDRESS = 0x08000000
else ifeq ($(INTFLASH_BANK), 2)
	INTFLASH_ADDRESS = 0x08100000
endif

LDFLAGS += -Wl,--defsym=__INTFLASH__=$(INTFLASH_ADDRESS)

# link script
LDSCRIPT = STM32H7B0VBTx_FLASH.ld

# libraries
LIBS = -lc -lm -lnosys 
LIBDIR = 
LDFLAGS += $(MCU) -specs=nano.specs -T$(LDSCRIPT) $(LIBDIR) $(LIBS) -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref -Wl,--gc-sections

# default action: build all
all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET)_extflash.bin $(BUILD_DIR)/$(TARGET)_intflash.bin


#######################################
# build the application
#######################################
# list of objects
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))
# list of ASM program objects
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SOURCES)))

$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR) 
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

$(BUILD_DIR)/%.o: %.s Makefile | $(BUILD_DIR)
	$(AS) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) Makefile
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	$(SZ) $@

$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(HEX) $< $@
	
$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(BIN) $< $@	
	
$(BUILD_DIR):
	mkdir $@		



OPENOCD ?= openocd
OCDIFACE ?= scripts/interface_jlink.cfg #interface/jlink.cfg
FLASH_MULTI ?= scripts/flash_multi.sh

#flash: $(BUILD_DIR)/$(TARGET).bin
#	dd if=$(BUILD_DIR)/$(TARGET).bin of=$(BUILD_DIR)/$(TARGET)_flash.bin bs=1024 count=128
#	$(OPENOCD) -f $(OCDIFACE) -c "transport select hla_swd" -f "target/stm32h7x.cfg" -c "reset_config none; program $(BUILD_DIR)/$(TARGET)_flash.bin 0x08000000 verify reset exit"

#.PHONY: flash


$(BUILD_DIR)/$(TARGET)_extflash.bin: $(BUILD_DIR)/$(TARGET).elf | $(BUILD_DIR)
#	$(V)$(ECHO) [ BIN ] $(notdir $@)
	$(V)$(BIN) -j ._extflash -j .extflash_text -j .extflash_rodata $< $(BUILD_DIR)/$(TARGET)_extflash.bin

$(BUILD_DIR)/$(TARGET)_intflash.bin: $(BUILD_DIR)/$(TARGET).elf | $(BUILD_DIR)
#	$(V)$(ECHO) [ BIN ] $(notdir $@)
	$(V)$(BIN) -j .isr_vector -j .text -j .rodata -j .ARM.extab -j .preinit_array -j .init_array -j .fini_array -j .data $< $(BUILD_DIR)/$(TARGET)_intflash.bin




# Programs the internal flash using a new OpenOCD instance
flash_intflash: $(BUILD_DIR)/$(TARGET)_intflash.bin
	$(OPENOCD) -f $(OCDIFACE) -c "program $< $(INTFLASH_ADDRESS) verify reset exit"
.PHONY: flash_intflash

flash_extflash: $(BUILD_DIR)/$(TARGET)_extflash.bin
	$(FLASH_MULTI) $(BUILD_DIR)/$(TARGET)_extflash.bin $(EXTFLASH_OFFSET)
.PHONY: flash_extflash

# Programs both the external and internal flash.
flash:
	$(V)$(MAKE) flash_intflash
	$(V)$(MAKE) flash_extflash
#	$(V)$(RESET_DBGMCU_CMD)
	$(V)$(MAKE) reset_dbgmcu 
.PHONY: flash


reset_dbgmcu:
	# Reset the DBGMCU configuration register (DBGMCU_CR)
	$(V)$(OPENOCD) -f ${OCDIFACE} -c "init; reset halt; mww 0x5C001004 0x00000000; resume; exit;"
.PHONY: reset_dbgmcu

# Starts openocd and attaches to the target. To be used with 'flash_intflash_nc' and 'gdb'
openocd:
	$(OPENOCD) -f $(OCDIFACE).cfg -c "init; halt"
.PHONY: openocd

dump_logs: $(BUILD_DIR)/$(TARGET).elf
	$(V)./scripts/dump_logs.sh
.PHONY: dump_logs


size: $(BUILD_DIR)/$(TARGET).elf
	$(V)./scripts/size.sh $<
.PHONY: size



GDB ?= $(PREFIX)gdb

debug: $(BUILD_DIR)/$(TARGET).elf
	$(GDB) $< -ex "target extended-remote :3333"
.PHONY: debug


#######################################
# clean up
#######################################
clean:
	-rm -fR $(BUILD_DIR)
  
#######################################
# dependencies
#######################################
-include $(wildcard $(BUILD_DIR)/*.d)

# *** EOF ***
