#include <algorithm>
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

template <typename T>
std::vector<std::vector<T>> subgraphs(const Graph<T> &graph)
{
	std::map<T, bool> visited;
	std::vector<std::vector<T>> result;

	for(const auto &v : graph)
	{
		visited.insert({v.first,  false});
	}

	while(!visited.empty())
	{
		std::vector<T> result_current;

		std::stack<T> stack;
		stack.push((*visited.begin()).first);

		while(!stack.empty())
		{
			T current = top(stack);
			stack.pop();
			if(visited[current]) continue;
			visited[current] = true;

			result_current.emplace_back(current);
			auto edges_search = graph.find(current);
			if(edges_search == graph.end())
			{
				std::terminate();
			}

			for(const auto &edge : edges_search->second)
			{
				stack.push(edge);
			}
		}
		result.emplace_back(std::move(result_current));

		for(auto it = visited.begin(); it != visited.end();)
		{
			if(it->second)
			{
				it = visited.erase(it);
			}
			else 
			{
				++it;
			}
		}
	}
	return result;
}

template <typename T>
void print_vec(const std::vector<T> &vec, std::string_view delim = ", ")
{
	if(vec.empty()) return;
	auto it = vec.begin();
	std::cout << *it;
	for(++it; it != vec.end(); ++it)
	{
		std::cout << delim << *it;
	}
	std::cout << '\n';
}

int main()
{
	auto graph = std::make_unique<Graph<int>>(Graph<int>{
		{1, {1, 2, 3}},
		{2, {1, 2, 3}},
		{3, {1, 2}},
		{4, {6, 5}},
		{5, {4}},
		{6, {}},
		{7, {}}
		
	});

	std::cout << "Graph:\n";
	graph_print(*graph);
	std::cout << '\n';

	std::cout << "DFS: ";
	print_vec(dfs<int>(*graph, 1));
	std::cout << '\n';

	std::cout << "BFS: ";
	print_vec(bfs<int>(*graph, 1));
	std::cout << '\n';

	std::cout << "Subgraphs:\n";
	for (const auto &vec : subgraphs<int>(*graph))
	{
		print_vec(vec);
	}
	std::cout << std::endl;

	return 0;
}
