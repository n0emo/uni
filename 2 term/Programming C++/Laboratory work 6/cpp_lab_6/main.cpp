#include <iostream>

#include "Queue.h"
#include "vector"

int main() {
    system("color F0");

    std::vector<int> vec;
    Queue<int> queue;

    queue.enqueue(4);
    std::cout << "Enqueued 4.\n";
    queue.enqueue(8);
    std::cout << "Enqueued 8.\n";
    queue.enqueue(20);
    std::cout << "Enqueued 20.\n\n";

    std::cout << "Trying peek: " << queue.peek() << "\n\n";

    std::cout << "Using toArray(): ";
    auto arr = queue.toArray();
    for(int i = 0; i < queue.size(); i++) {
        std::cout << arr[i] << " ";
    }

    std::cout << "\n\n";

    while (queue.size() > 0) {
        std::cout <<"dequeued " << queue.dequeue() << '\n';
    }

    std::cout << "\nEnqueuing 6, 2 and 4." << '\n';
    queue.enqueue(6);
    queue.enqueue(2);
    queue.enqueue(4);

    queue.clear();
    std::cout << "Size after clear: " << queue.size() << std::endl << std::endl;

    system("pause");
    return 0;
}
