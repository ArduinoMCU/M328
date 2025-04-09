# Compier path:
COMP_PATH=./tools/avr-gcc/bin
AVRDUDE_PATH=./tools/avrdude

# MCU and Compiler Settings
MCU=atmega328p
CC=$(COMP_PATH)/avr-gcc
OBJCOPY=$(COMP_PATH)/avr-objcopy
OPTIMIZE=s

# Arduino port for flashing
PORT ?= /dev/ttyUSB0
export PORT

# Compiler and Linker Flags
CFLAGS=-mmcu=$(MCU) -Wall -O$(OPTIMIZE) -Iincludes
LDFLAGS=-mmcu=$(MCU)

# Folder Directories
SRC=src
BUILD=builds
INCLUDES=includes

# Source Files and Output Files
SRCS=$(wildcard $(SRC)/*.c)
OBJS=$(patsubst $(SRC)/%.c, $(BUILD)/%.o, $(SRCS))
ELF=$(BUILD)/main.elf
HEX=$(BUILD)/HEX/firmware.hex
BIN=$(BUILD)/BIN/firmware.bin

# Compile and Build
all: $(HEX) $(BIN)

$(BUILD)/%.o: $(SRC)/%.c | $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@

$(ELF): $(OBJS)
	$(CC) $(LDFLAGS) $^ -o $@

$(HEX): $(ELF)
	$(OBJCOPY) -O ihex $< $@

$(BIN): $(ELF)
	$(OBJCOPY) -O binary $< $@

# Create Build Folder
$(BUILD):
	mkdir $(BUILD)

# Print AVR code Size
size: $(ELF)
	avr-size --mcu=$(MCU) -C $(ELF)

# Clean Up
clean:
	rm $(BUILD)/main.*
	rm $(BUILD)/HEX/*
	rm $(BUILD)/BIN/*

# Flashing (Requires AVRDUDE)
flash: $(BIN) $(HEX)
	$(AVRDUDE_PATH)/avrdude -cusbasp -p$(MCU) -Pusb -Uflash:w:$(BIN):r

flash_arduino: $(BIN) $(HEX)
	$(AVRDUDE_PATH)/avrdude -carduino -p$(MCU) -P $(PORT) -b115200 -Uflash:w:$(BIN):r

# Erase Flash (Requires AVRDUDE)
erase:
	$(AVRDUDE_PATH)/avrdude -cusbasp -p$(MCU) -Pusb -e


.PHONY: all clean flash erase size