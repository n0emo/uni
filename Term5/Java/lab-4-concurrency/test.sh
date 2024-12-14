#!/bin/bash

echo "Generating 10000000 random numbers"
for i in {1..10000000}; do echo -n "$RANDOM "; done > test.txt

echo "Testing single threaded computation"
time lein run -- -s test.txt
echo "Testing parallel computation"
time lein run -- -p test.txt

rm test.txt
