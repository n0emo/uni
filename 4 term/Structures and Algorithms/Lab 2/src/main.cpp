#include <exception>
#include <iostream>
#include <map>
#include <memory>
#include <set>
#include <stack>
#include <queue>
#include <unordered_map>

template <typename T>
using Graph = std::map<T, std::set<T>>;

template <typename T>
void graph_print(const Graph<T>& graph)
{
	for(const auto &edge: graph)
	{
		std::cout << edge.first;
		if(!edge.second.empty())
		{
			std::cout << " -> {";
			auto it = edge.second.begin();
			std::cout << *it;
			for(++it; it != edge.second.end(); ++it)
			{
				std::cout << ", " << *it;
			}
			std::cout << "}";
		}

		std::cout << "\n";
	}
}

template <typename T>
T top(const std::stack<T> &stack)
{
	return stack.top();
}

template <typename T>
T top(const std::queue<T> &queue)
{
	return queue.front();
}

template <typename Container, typename T>
std::vector<T> search(const Graph<T> &graph, const T& root)
{
	std::unordered_map<T, bool> visited;
	std::vector<T> result;

	Container cont;
	cont.push(root);

	while(!cont.empty())
	{
		T current = top(cont);
		cont.pop();
		if(visited[current]) continue;
		visited[current] = true;

		result.emplace_back(current);
		auto edges_search = graph.find(current);
		if(edges_search == graph.end())
		{
			std::terminate();
		}

		for(const auto &edge : edges_search->second)
		{
			cont.push(edge);
		}
	}

	return result;
}

template <typename T>
std::vector<T> bfs(const Graph<T> &graph, const T& root)
{
	return search<std::queue<T>, T>(graph, root);
}

template <typename T>
std::vector<T> dfs(const Graph<T> &graph, const T& root)
{
	return search<std::stack<T>, T>(graph, root);
}

// TODO
template <typename T>
std::vector<std::vector<T>> forest(const Graph<T> &graph)
{
	std::map<T, bool> visited;

	for(const auto &v : graph)
	{
		visited.insert({v.first,  false});
	}
}

int main()
{
	auto graph = std::make_unique<Graph<int>>(Graph<int>{
		{1, {1, 2, 3}},
		{2, {5, 2, 3, 6}},
		{3, {4, 2}},
		{4, {1, 5}},
		{5, {2}},
		{6, {}}
	});

	graph_print(*graph);

	std::cout << "DFS:";
	for (const auto& v : dfs<int>(*graph, 1))
	{
		std::cout << " " << v;
	}
	std::cout << std::endl;

	std::cout << "BFS:";
	for (const auto& v : bfs<int>(*graph, 1))
	{
		std::cout << " " << v;
	}
	std::cout << std::endl;

	return 0;
}
