CC = nvcc

# If necessary, add path to cl.exe below
# CFLAGS_WIN = -ccbin ""

all: hello add dot sales

allexe: hello.exe add.exe dot.exe sales.exe

hello add dot sales: % : %.cu
	$(CC) $(CFLAGS) -o $@ $^

hello.exe add.exe dot.exe sales.exe: %.exe : %.cu
	$(CC) $(CFLAGS_WIN) -o $@ $^

clean:
	$(RM) hello add dot sales
	$(RM) hello.exe add.exe dot.exe sales.exe
	$(RM) hello.lib add.lib dot.lib sales.lib
	$(RM) hello.exp add.exp dot.exp sales.exp
