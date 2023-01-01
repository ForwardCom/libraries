# makefile for building ForwardCom function libraries
# last modified: 2023-01-01
# version: 1.12
# license: GPL
# author: Agner Fog

# This will make the following libraries for ForwardCom:
# ------------------------------------------------------
# libc.li: Standard C functions
# math.li: Standard C math functions
# libc_light.li: Standard and non-standard functions for small CPUs with limited capabilities,
# does not use mul, div, push, pop, sys_call. Uses 64-bit registers only if supported.

# assembler name:
comp=forw.exe

# object files for libc.li:
objfilesc = startup.ob abort.ob exit.ob time.ob raise_event.ob \
fopen.ob fclose.ob feof.ob ferror.ob fflush.ob fread.ob fwrite.ob fseek.ob ftell.ob remove.ob \
printf.ob fprintf.ob \
getchar.ob putchar.ob puts.ob fgetc.ob fgets.ob gets_s.ob \
atoi.ob printint32.ob printint64.ob divide_int.ob \
memcpy.ob memset.ob strlen.ob strcpy.ob strcat.ob \
# Note: string functions need to be fixed to avoid unaligned memory access
# snprintf.ob fscanf.ob scanf.ob sscanf.ob 

# object files for math.li:
objfilesm = sincos.ob sincosf.ob integrate.ob

# object files for libc_light.li:
objfileslc = startup_light.ob atoi_light.ob \
puts_light.ob print_string_light.ob print_characters_light.ob \
print_hexadecimal_light.ob print_integer_light.ob printf_light.ob \
getch_light.ob gets_light.ob clear_input_light.ob \
multiply_int_light.ob divide_int_light.ob
# putchar_light.ob missing

# make libc.li:
libc.li : $(objfilesc)
	$(comp) -lib $@ $?
    
# make math.li:
math.li : $(objfilesm)
	$(comp) -lib $@ $?

# make libc_light.li:
libc_light.li : $(objfileslc)
	$(comp) -lib $@ $?
   

# rule for making object file:
%.ob: %.as
	$(comp) -ass -debug=3 -O2 $< $@
