STATIC?=0
CC=gcc

LIBOUT=libLogHelper.so
MODE=cvr
CCFLAGS= -shared


# make static lib
ifeq ($(STATIC), 1)
LIBOUT=libLogHelper.a
CCFLAGS=
MODE=rcs
endif


CCFLAGS+=-fPIC -Wall -Werror -Wextra -Wno-unknown-pragmas


OBJ=log_helper.o

all: clean log_helper.c
	$(CC) -c $(CCFLAGS) log_helper.c -o $(OBJ)
	ar $(MODE) $(LIBOUT) $(OBJ)
	mkdir -p ../lib
	cp $(LIBOUT) ../lib/


clean:
	rm -rf $(LIBOUT) *.o *.a server
