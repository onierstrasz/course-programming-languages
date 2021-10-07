
# Basic Makefile
# A Basic Makefile consists of comments, macros, dependency lines and commands:

# These are the files make should recognize
.SUFFIXES: .c

# Version of the C compiler; compile options:
CC		= cc
CFLAGS	= -O

# Generic rules -- how to make .o files from .cpp files:
.c.o:
	$(CC) $(CFLAGS) -c $<

# What to make or remove:
ALL = helloWorld memory helloMain strCopy \
	myEcho fptrs lrev self free sizeof crunch

# The first rule defines what to make by default
# (Could be many things)
all : $(ALL)

# Run tests; silently execute commands
test : all lrevtest selftest
	@chmod 0755 check
	# Platform dependent:
	# @./check crunch 'hello!! world!!'
	@./check 'fptrs A' 'A -> 65'	
	@echo "(no free test)"
	@./check helloMain 'hello world!'
	@./check helloWorld 'hello world!'
	@./check memory 'Text is here:*'
	@./check 'myEcho hello' './myEcho hello '
	@./check 'sizeof' 'sizeof("abcd") = 5*sizeof(&main) = 4'
	@./check 'strCopy' 'hello world!*hello world!*hello world!'

# helloMain is made by linking together the object files:
helloMain : helloMain.o hello.h hello.o
	cc $@.o hello.o -o $@

# Other dependencies ...
helloWorld : helloWorld.c
	cc $? -o $@

memory : memory.c
	cc $? -o $@

strCopy : strCopy.c
	cc $? -o $@

myEcho : myEcho.c
	cc $? -o $@

fptrs : fptrs.c
	cc $? -o $@

lrev : lrev.c
	cc $? -o $@

lrevtest : lrev
	@echo "!!! lrev is BROKEN (on Intel Mac) !!!"

lrevtestBROKEN :	
	@./lrev lrev.c > t
	@./lrev t > t1
	@diff lrev.c t1
	@echo "PASSED lrev TEST"
	@rm -f t t1

self : self.c
	cc $? -o $@

selftest : self
	@-./self > t	# ignore return error
	@diff t self.c
	@echo "PASSED self test"
	@rm -f t

free : free.c
	cc $? -o $@

sizeof : sizeof.c
	cc $? -o $@

crunch : crunch.c
	cc $? -o $@

clean :
	rm -rf *.o $(ALL)
