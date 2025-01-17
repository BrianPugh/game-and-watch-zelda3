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
TARGET = gw_zelda3


######################################
# building variables
######################################
# debug build?
DEBUG = 0
# optimization
OPT = -O3


INTFLASH_BANK ?= 2

EXTFLASH_OFFSET ?= 1048576

EXTFLASH_SIZE_MB ?= 15

EXTFLASH_SIZE ?= $(shell echo "$$(( $(EXTFLASH_SIZE_MB) * 1024 * 1024 ))")

EXTFLASH_ADDRESS ?= $(shell echo "$$(( $(EXTFLASH_OFFSET) + 0x90000000 ))")

LARGE_FLASH ?= 0
export LARGE_FLASH  # Used in stm32h7x_spiflash.cfg
ifeq ($(LARGE_FLASH), 0)
PROGRAM_VERIFY="verify"
else
# Currently verify is broken for large chips
PROGRAM_VERIFY=""
endif

export USE_4K_ERASE_CMD=0	# Used in stm32h7x_spiflash.cfg

# Screenshot support allocates 150kB of external flash
ENABLE_SCREENSHOT ?= 0

# Limit to 30 fps for improved stability
LIMIT_30FPS ?= 1

# Overclock level: 0 (no overclocking), 1 (intermediate overclocking), or 2 (max overclocking)
OVERCLOCK ?= 2

RENDER_FPS ?= 0

PATCH_DIALOGUES ?= 0

# Savestate support allocates 178kB of external flash
ENABLE_SAVESTATE ?= 0

# Increase UI speed (item menu, etc.)
FASTER_UI ?= 1

# Display battery indicator in item menu
BATTERY_INDICATOR ?= 1

# Extended screensize (0 for default screen size 256x224, 1 for full-height 256x240, 2 for full screen 320x240)
EXTENDED_SCREEN ?= 1

# Item switch on L/R. Also allows reordering of items in inventory by pressing Y+direction.
# Hold X, L, or R inside of the item selection screen to assign items to those buttons.
# If X is reassigned, Select opens the map. Push Select while paused to save or quit.
# When L or R are assigned items, those buttons will no longer cycle items.
FEATURE_SWITCH_LR ?= 0
# Allow turning while dashing
FEATURE_TURN_WHILE_DASHING ?= 0
# Allow mirror to be used to warp to the Dark World
FEATURE_MIRROR_TO_DARK_WORLD ?= 0
# Collect items (like hearts) with sword instead of having to touch them
FEATURE_COLLECT_ITEMS_WITH_SWORD ?= 0
# Level 2-4 sword can be used to break pots
FEATURE_BREAK_POTS_WITH_SWORD ?= 0
# Disable the low health beep
FEATURE_DISABLE_LOW_HEALTH_BEEP ?= 0
# Avoid waiting too much at the start
FEATURE_SKIP_INTRO_ON_KEYPRESS ?= 1
# Display max rupees/bombs/arrows with orange/yellow color
FEATURE_SHOW_MAX_ITEMS_IN_YELLOW ?= 0
# Allows up to four bombs active at a time instead of two.
FEATURE_MORE_ACTIVE_BOMBS ?= 0
# Can carry 9999 rupees instead of 999
FEATURE_CARRY_MORE_RUPEES ?= 0
# Enable various zelda bug fixes
FEATURE_MISC_BUG_FIXES ?= 0
# Allow bird travel to be cancelled by hitting the X key
FEATURE_CANCEL_BIRD_TRAVEL ?= 0
# Enable some more advanced zelda bugfixes that change game behavior
FEATURE_GAME_CHANGING_BUG_FIXES ?= 0
# Enable this to limit the ItemSwitchLR item cycling to the first 4 items.
FEATURE_SWITCH_LR_LIMIT ?= 0

FEATURES := 0
FEATURES := $(shell echo "$$(( $(FEATURES) | $(FEATURE_SWITCH_LR) << 1 ))")
FEATURES := $(shell echo "$$(( $(FEATURES) | $(FEATURE_TURN_WHILE_DASHING) << 2 ))")
FEATURES := $(shell echo "$$(( $(FEATURES) | $(FEATURE_MIRROR_TO_DARK_WORLD) << 3 ))")
FEATURES := $(shell echo "$$(( $(FEATURES) | $(FEATURE_COLLECT_ITEMS_WITH_SWORD) << 4 ))")
FEATURES := $(shell echo "$$(( $(FEATURES) | $(FEATURE_BREAK_POTS_WITH_SWORD) << 5 ))")
FEATURES := $(shell echo "$$(( $(FEATURES) | $(FEATURE_DISABLE_LOW_HEALTH_BEEP) << 6 ))")
FEATURES := $(shell echo "$$(( $(FEATURES) | $(FEATURE_SKIP_INTRO_ON_KEYPRESS) << 7 ))")
FEATURES := $(shell echo "$$(( $(FEATURES) | $(FEATURE_SHOW_MAX_ITEMS_IN_YELLOW) << 8 ))")
FEATURES := $(shell echo "$$(( $(FEATURES) | $(FEATURE_MORE_ACTIVE_BOMBS) << 9 ))")
FEATURES := $(shell echo "$$(( $(FEATURES) | $(FEATURE_CARRY_MORE_RUPEES) << 11 ))")
FEATURES := $(shell echo "$$(( $(FEATURES) | $(FEATURE_MISC_BUG_FIXES) << 12 ))")
FEATURES := $(shell echo "$$(( $(FEATURES) | $(FEATURE_CANCEL_BIRD_TRAVEL) << 13 ))")
FEATURES := $(shell echo "$$(( $(FEATURES) | $(FEATURE_GAME_CHANGING_BUG_FIXES) << 14 ))")
FEATURES := $(shell echo "$$(( $(FEATURES) | $(FEATURE_SWITCH_LR_LIMIT) << 15 ))")


# Disables all game customizations altogether
VANILLA_GAMEPLAY ?= 0
ifneq ($(VANILLA_GAMEPLAY), 0)
PATCH_DIALOGUES=0
FASTER_UI=0
BATTERY_INDICATOR=0
FEATURES=0
EXTENDED_SCREEN=0
endif


# Language
DIALOGUES_LANGUAGE ?= us
ifeq ($(DIALOGUES_LANGUAGE), us)
LOCALIZED_ROM=
LOCALIZED_ROM_PATH=
else
LOCALIZED_ROM=zelda3_$(DIALOGUES_LANGUAGE).sfc
LOCALIZED_ROM_PATH=zelda3/tables/$(LOCALIZED_ROM)
endif


# Configure Game & Watch target device mario|zelda
GNW_TARGET ?= mario

# Set the preprocessor options
ifeq ($(GNW_TARGET),mario)
	GNW_TARGET_ZELDA = 0
	GNW_TARGET_MARIO = 1
else ifeq ($(GNW_TARGET),zelda)
	GNW_TARGET_ZELDA = 1
	GNW_TARGET_MARIO = 0
else
$(error Invalid GNW_TARGET. Valid values {mario|zelda})
endif



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
Core/Src/bq24072.c \
Core/Src/main.c \
Core/Src/gw_flash.c \
Core/Src/crc32.c \
Core/Src/stm32h7xx_it.c \
Core/Src/stm32h7xx_hal_msp.c \
Core/Src/system_stm32h7xx.c \
Core/Src/porting/zelda_assets_in_intflash.c \
Core/Src/porting/zelda_assets_in_ram.c \
Core/Src/porting/zelda_assets_in_extflash.c \
Core/Src/porting/common.c \
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
zelda3/snes/dsp.c \
zelda3/sprite_main.c \
zelda3/tagalong.c \
zelda3/third_party/opus-1.3.1-stripped/opus_decoder_amalgam.c \
zelda3/tile_detect.c \
zelda3/overlord.c \


# Version and URL for the STM32CubeH7 SDK
SDK_VERSION ?= v1.8.0
SDK_URL ?= https://raw.githubusercontent.com/STMicroelectronics/STM32CubeH7

# Local path for the SDK
SDK_DIR ?= Drivers


# SDK C sources
SDK_C_SOURCES =  \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_adc.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_adc_ex.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_cortex.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_dac_ex.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_dac.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_dma_ex.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_dma.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_dma2d.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_exti.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_flash_ex.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_flash.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_gpio.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_hsem.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_i2c_ex.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_i2c.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_jpeg.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_ltdc_ex.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_ltdc.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_mdma.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_ospi.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_pwr_ex.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_pwr.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_rcc_ex.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_rcc.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_rtc_ex.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_rtc.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_sai_ex.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_sai.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_spi_ex.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_spi.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_tim_ex.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_tim.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_wwdg.c \
Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal.c \


# SDK ASM sources
SDK_ASM_SOURCES =  \
Drivers/CMSIS/Device/ST/STM32H7xx/Source/Templates/gcc/startup_stm32h7b0xx.s

# SDK headers
SDK_HEADERS = \
Drivers/CMSIS/Device/ST/STM32H7xx/Include/stm32h7b0xx.h \
Drivers/CMSIS/Device/ST/STM32H7xx/Include/stm32h7xx.h \
Drivers/CMSIS/Device/ST/STM32H7xx/Include/system_stm32h7xx.h \
Drivers/CMSIS/Include/cmsis_compiler.h \
Drivers/CMSIS/Include/cmsis_gcc.h \
Drivers/CMSIS/Include/cmsis_version.h \
Drivers/CMSIS/Include/core_cm7.h \
Drivers/CMSIS/Include/mpu_armv7.h \
Drivers/STM32H7xx_HAL_Driver/Inc/Legacy/stm32_hal_legacy.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_ll_adc.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_adc.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_adc_ex.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_cortex.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_dac_ex.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_dac.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_def.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_dma_ex.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_dma.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_dma2d.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_exti.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_flash_ex.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_flash.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_gpio_ex.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_gpio.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_hsem.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_i2c_ex.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_i2c.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_jpeg.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_ltdc_ex.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_ltdc.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_mdma.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_ospi.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_pwr_ex.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_pwr.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_rcc_ex.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_rcc.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_rtc_ex.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_rtc.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_sai_ex.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_sai.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_spi_ex.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_spi.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_tim.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_tim_ex.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_wwdg.h \
Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal.h \



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
ECHO  = echo
PYTHON:=/usr/bin/env python3
 
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
-DSTM32H7B0xx \
-DBATTERY_INDICATOR=$(BATTERY_INDICATOR) \
-DENABLE_SCREENSHOT=$(ENABLE_SCREENSHOT) \
-DGNW_TARGET_MARIO=$(GNW_TARGET_MARIO) \
-DGNW_TARGET_ZELDA=$(GNW_TARGET_ZELDA) \
-DLIMIT_30FPS=$(LIMIT_30FPS) \
-DOVERCLOCK=$(OVERCLOCK) \
-DRENDER_FPS=$(RENDER_FPS) \
-DFEATURES=$(FEATURES) \
-DENABLE_SAVESTATE=$(ENABLE_SAVESTATE) \
-DFASTER_UI=$(FASTER_UI) \
-DEXTENDED_SCREEN=$(EXTENDED_SCREEN) \
-DDIALOGUES_LANGUAGE=$(DIALOGUES_LANGUAGE)


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
CFLAGS += -g -gdwarf-2 #-O0
endif


# Generate dependency information
CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)"


#######################################
# LDFLAGS
#######################################


LDFLAGS += -Wl,--defsym=__EXTFLASH_OFFSET__=$(EXTFLASH_OFFSET)
LDFLAGS += -Wl,--defsym=__EXTFLASH_TOTAL_LENGTH__=$(EXTFLASH_SIZE)
LDFLAGS += -Wl,--defsym=ENABLE_SCREENSHOT=$(ENABLE_SCREENSHOT)
LDFLAGS += -Wl,--defsym=ENABLE_SAVESTATE=$(ENABLE_SAVESTATE)

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
# download SDK files
#######################################
$(SDK_DIR)/%:
	$(V)$(ECHO) [ WGET ] $(notdir $@)
	$(V)wget -q $(SDK_URL)/$(SDK_VERSION)/$@ -P $(dir $@)

.PHONY: download_sdk
download_sdk: $(SDK_HEADERS) $(SDK_C_SOURCES) $(SDK_ASM_SOURCES)


#######################################
# build the application
#######################################
# list of objects
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o) $(SDK_C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES) $(SDK_C_SOURCES)))
# list of ASM program objects
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(SDK_ASM_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(SDK_ASM_SOURCES)))



# function used to generate prerequisite rules for SDK objects
define sdk_obj_prereq_gen
$(BUILD_DIR)/$(patsubst %.c,%.o,$(patsubst %.s,%.o,$(notdir $1))): $1

endef
# note: the blank line above is intentional

# generate all object prerequisite rules
$(eval $(foreach obj,$(SDK_C_SOURCES) $(SDK_ASM_SOURCES),$(call sdk_obj_prereq_gen,$(obj))))



$(BUILD_DIR)/%.o: %.c Makefile $(SDK_HEADERS) | $(BUILD_DIR) 
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

$(BUILD_DIR)/%.o: %.s Makefile $(SDK_HEADERS) | $(BUILD_DIR)
	$(AS) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/$(TARGET).elf: assets_extraction $(OBJECTS) Makefile
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	$(SZ) $@

$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(HEX) $< $@
	
$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(BIN) $< $@	
	

assets_extraction: Core/Src/porting/zelda_assets_in_extflash.c Core/Src/porting/zelda_assets_in_intflash.c Core/Src/porting/zelda_assets_in_ram.c

Core/Src/porting/zelda_assets_%.c: scripts/bundle_all_assets.py scripts/update_all_assets.py zelda3/tables/zelda3_assets.dat | $(BUILD_DIR)
	$(PYTHON) ./scripts/bundle_all_assets.py
	$(PYTHON) ./scripts/update_all_assets.py


# FIXME Handle patching dialogue.txt in restool.py?
#zelda3/tables/dialogue.txt: zelda3/tables/zelda3.sfc zelda3/tables/dialogue.txt.patched
#zelda3/tables/dialogue.txt.patched: scripts/dialogue.txt.diff
#	cd zelda3 && make tables/dialogue.txt
#	if [ $(PATCH_DIALOGUES) -gt 0 ]; then \
#		echo 'Patching dialogues file'; \
#		if [ -e $@ ]; then patch -R zelda3/tables/dialogue.txt $@; fi; \
#		patch zelda3/tables/dialogue.txt $<; \
#		cp scripts/dialogue.txt.diff $@; \
#	fi

zelda3/tables/zelda3_assets.dat: zelda3/tables/zelda3.sfc $(LOCALIZED_ROM_PATH) | $(BUILD_DIR)
	@if [ "$(LOCALIZED_ROM)" ]; then \
		$(ECHO) 'Extracting dialogues from localized ROM: $(LOCALIZED_ROM)'; \
		cd zelda3/tables; \
		$(PYTHON) restool.py --extract-dialogue -r $(LOCALIZED_ROM); \
		$(ECHO) "Extracting game resources with localized dialogues"; \
		$(PYTHON) restool.py --extract-from-rom --languages=$(DIALOGUES_LANGUAGE) -r zelda3.sfc; \
	else \
		$(ECHO) "Extracting game resources"; \
		cd zelda3/tables; $(PYTHON) restool.py --extract-from-rom -r zelda3.sfc; \
	fi
	
$(BUILD_DIR):
	mkdir $@		



OPENOCD ?= openocd
ADAPTER ?= jlink
OCDIFACE ?= scripts/interface_$(ADAPTER).cfg

#flash: $(BUILD_DIR)/$(TARGET).bin
#	dd if=$(BUILD_DIR)/$(TARGET).bin of=$(BUILD_DIR)/$(TARGET)_flash.bin bs=1024 count=128
#	$(OPENOCD) -f $(OCDIFACE) -c "transport select hla_swd" -f "target/stm32h7x.cfg" -c "reset_config none; program $(BUILD_DIR)/$(TARGET)_flash.bin 0x08000000 verify reset exit"

#.PHONY: flash


$(BUILD_DIR)/$(TARGET)_extflash.bin: $(BUILD_DIR)/$(TARGET).elf | $(BUILD_DIR)
#	$(V)$(ECHO) [ BIN ] $(notdir $@)
	$(V)$(BIN) -j ._itcram_hot -j ._dtcram_hot -j ._ahbram_hot -j ._ram_exec -j ._extflash $< $(BUILD_DIR)/$(TARGET)_extflash.bin

$(BUILD_DIR)/$(TARGET)_intflash.bin: $(BUILD_DIR)/$(TARGET).elf | $(BUILD_DIR)
#	$(V)$(ECHO) [ BIN ] $(notdir $@)
	$(V)$(BIN) -j .isr_vector -j .text -j .rodata -j .ARM.extab -j .preinit_array -j .init_array -j .fini_array -j .data $< $(BUILD_DIR)/$(TARGET)_intflash.bin




# Programs the internal flash using a new OpenOCD instance
flash_intflash: $(BUILD_DIR)/$(TARGET)_intflash.bin
	$(OPENOCD) -f $(OCDIFACE) -c "init; halt; program $< $(INTFLASH_ADDRESS) $(PROGRAM_VERIFY); exit"
.PHONY: flash_intflash

flash_extflash: $(BUILD_DIR)/$(TARGET)_extflash.bin
	$(OPENOCD) -f $(OCDIFACE) -c "init; halt; program $< $(EXTFLASH_ADDRESS) $(PROGRAM_VERIFY); exit"
.PHONY: flash_extflash

# Programs both the external and internal flash.
flash:
	$(V)$(MAKE) flash_extflash
	$(V)$(MAKE) flash_intflash
	$(V)$(MAKE) reset_dbgmcu 
.PHONY: flash


reset:
	$(OPENOCD) -f $(OCDIFACE) -c "init; reset; exit"
.PHONY: reset

reset_dbgmcu:
	# Reset the DBGMCU configuration register (DBGMCU_CR)
	$(V)$(OPENOCD) -f ${OCDIFACE} -c "init; reset halt; mww 0x5C001004 0x00000000; resume; exit;"
.PHONY: reset_dbgmcu

# Starts openocd and attaches to the target. To be used with 'flash_intflash_nc' and 'gdb'
openocd:
	$(OPENOCD) -f $(OCDIFACE) -c "init; halt"
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
	-rm -fR Core/Src/porting/zelda_assets_*.c
	cd zelda3 && make clean
  
#######################################
# dependencies
#######################################
-include $(wildcard $(BUILD_DIR)/*.d)

# *** EOF ***
