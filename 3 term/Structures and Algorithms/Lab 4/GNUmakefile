name = cpp_lab_4
sources = main.cpp strs.cpp
headers = -I .
cxxflags = -Wall -g

$(name): $(sources)
	c++ $(cxxflags) $(headers) -o $(name) $(sources)

.PHONY: run
run: $(name)
	./$(name)

clean:
	rm $(name) *.o *~
