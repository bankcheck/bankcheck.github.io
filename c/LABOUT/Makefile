# Your C compiler (eg, "cc" or "gcc")
CC=	cc

# program to use for installation -- this may or may not preserve
# old versions (or whatever). assumes that it takes parameters:
# copy source dest
CP=	cp

# Defines for your operating system
#
#DEFINES=-DSYSV -DSOLARIS

# Options for your compiler (eg, "-g" for debugging, "-O" for
# optimizing, or "-g -O" for both under GCC)
COPT= -g -O $(DEFINES)

# Version of "make" you want to use
#MAKE=gnumake
MAKE=make

# Your ranlib utility (use "touch" if you don't have ranlib)
RANLIB= ranlib
#RANLIB=	touch

# Destination directory for installation of binaries
DEST=/usr/local/etc

# Names of any auxiliary libraries your system may require (e.g., -lsocket)
# If you want to link against a resolver library, specify it here.
AUXLIB= -lresolv -lsocket -lnsl

# DBM library should be specified if it is an external library or
# you with to use a different one than what is included in libc
DBMLIB= -ldbm

# Flags to pass to the linker (eg, -static for static binaries under GCC,
# or -Bstatic for static binaries under SunOS 4.1.x)
LDFL= -g

# Objects to include in libfwall for SYSV
SYSVOBJ= signal.o

CFLAGS= $(COPT)

OBJS=   labout.o

EXEFILE=labout

all: $(EXEFILE)

.c.o:
	@echo 'Compiling $< ...'
	@$(CC) -c $(CFLAGS) $<

rebuild: clean all

$(EXEFILE): $(OBJS)
	@echo 'Linking $@ ...'
	@if [ "$(OSTYPE)" = "solaris" ]; then \
		$(CC) $(LDFL) -o $@ $(OBJS) $(AUXLIB); \
	else \
		$(CC) $(LDFL) -o $@ $(OBJS); \
	fi

clean:
	@echo 'Removing files ...'
	@rm -f core $(EXEFILE) $(OBJS)

install:	all
	@echo 'Installing files to $(DEST) ...'
	@if [ -f $(DEST)/$(EXEFILE) ]; then \
		mv $(DEST)/$(EXEFILE) $(DEST)/$(EXEFILE).old; \
	fi
	@$(CP) $(EXEFILE) $(DEST)
	@chmod 755 $(DEST)/$(EXEFILE)

