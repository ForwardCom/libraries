# makefile for building ForwardCom function libraries
# date: 2018-03-30
# version: 1.00
# license: GPL
# author: Agner Fog

# assembler name:
comp=forw

# object files for libc.li:
objfilesc = startup.ob abort.ob exit.ob time.ob raise_event.ob \
fopen.ob fclose.ob feof.ob ferror.ob fflush.ob fread.ob fwrite.ob fseek.ob ftell.ob remove.ob \
printf.ob fprintf.ob \
getchar.ob putchar.ob puts.ob fgetc.ob fgets.ob gets_s.ob \
atoi.ob printint32.ob printint64.ob \
memcpy.ob memset.ob strlen.ob strcpy.ob strcat.ob
# snprintf.ob fscanf.ob scanf.ob sscanf.ob 

# object files for math.li:
objfilesm = sincos.ob integrate.ob

# make libc.li:
libc.li : $(objfilesc)
	$(comp) -lib $@ $?
    
# make math.li:
math.li : $(objfilesm)
	$(comp) -lib $@ $?
   

# rule for making object file:
%.ob: %.as
	$(comp) -ass $< $@
