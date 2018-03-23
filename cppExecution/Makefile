CPPCOMPILER= g++
CPPFLAGS= -std=c++11 -Wall -g3
TARGET= resilience

all:
	$(CPPCOMPILER) $(CPPFLAGS) -c -o main.o main.cpp
	$(CPPCOMPILER) $(CPPFLAGS) -c -o network.o network.cpp
	$(CPPCOMPILER) $(CPPFLAGS) -o $(TARGET) main.o network.cpp

clean:
	rm *.o $(TARGET)
