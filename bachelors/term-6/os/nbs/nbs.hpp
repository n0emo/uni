/*
 * A simple build system to build in C++
 */

/*
 * MIT License
 *
 * Copyright (c) 2024 Albert Shefner
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#ifndef NBS_HPP
#define NBS_HPP

#include <cassert>
#include <cstdint>
#include <ctime>

#include <algorithm>
#include <functional>
#include <iostream>
#include <memory>
#include <sstream>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#ifdef _WIN32
#define WIN32_LEAN_AND_MEAN
#include <Windows.h>
#else
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#endif

#if __cpp_exceptions
	#define NBS_THROW(E) throw E
#else
	#define NBS_THROW(E) abort()
#endif

#ifndef NBSAPI
#define NBSAPI
#endif

#define TODO(thing) assert(0 && thing "is not implemented.")

// TODO: multiprocessed target building
// TODO: generate targets in nbs::c
// TODO: determine user toolchain (compiler, etc.)
// TODO: support for MSVC syntax
// TODO: CLI class for easy CLI app building
// TODO: maybe nbs::unit for unit testing
// TODO: nbs::config
// TODO: cover nbs with tests
// TODO: properly annotate
// TODO: use string_view

namespace nbs
{
typedef std::vector<std::string> strvec;

NBSAPI void self_update(int argc, char **argv, const std::string &source);

namespace os
{
struct Path {
    std::string buf;

    Path() = default;
    Path(const std::string &str);
    Path(const char *str);

    Path &operator /=(const Path &other);
    Path operator /(const Path &other) const;
    Path &operator /=(const std::string &other);
    Path operator /(const std::string &other) const;
    Path &operator /=(const char *other);
    Path operator /(const char *other) const;
};

using path = Path;

enum ProcessError
{
    PROCESS_WAIT_ERROR,
    PROCESS_EXIT_STATUS_ERROR,
    PROCESS_EMPTY_CMD_ERROR,
    PROCESS_CREATE_ERROR,
#ifdef _WIN32
    PROCESS_GET_EXIT_CODE_ERROR,
    PROCESS_GET_HANDLE_ERROR,
#else
    PROCESS_SIGNAL_ERROR,
    PROCESS_EXEC_ERROR,
#endif
};

struct Process
{
#ifdef _WIN32
    HANDLE handle;
    Process(HANDLE handle);
#else
    int pid;
    Process(int pid);
#endif
    void await() const;
};

struct Cmd
{
    strvec items;

    Cmd();
    Cmd(const std::string &cmd);
    Cmd(const std::initializer_list<std::string> &cmd);

    void append(const std::string &item);
    void append_many(const strvec &items);
    void append_many_prefixed(const std::string &prefix, const strvec &items);

    std::string to_string() const;
    void run() const;
    Process run_async() const;
    void run_or_die(const std::string &message) const;
    std::unique_ptr<char *[]> to_c_argv() const;
};

NBSAPI void await_processes(const std::vector<Process> &processes);

#ifdef _WIN32
std::string windows_error_code_to_str(DWORD error);
std::string windows_last_error_str();
#endif

typedef std::vector<path> pathvec;

NBSAPI strvec paths_to_strs(const pathvec &paths);
NBSAPI pathvec strs_to_paths(const strvec &paths);
NBSAPI long compare_last_mod_time(const path &path1, const path &path2);
NBSAPI bool make_directory_if_not_exists(const path &path);
NBSAPI bool exists(const path &path);
NBSAPI void rename(const os::path &from, const path &to);
NBSAPI long last_write_time(const os::path &path);
} // namespace os

namespace str
{
NBSAPI std::string join(const std::string &sep, const strvec &strings);
NBSAPI std::string trim_to(const std::string &str, const std::string &chars = "\n\r ");
NBSAPI std::string trim_right_to(const std::string &str, const std::string &chars = "\n\r ");
NBSAPI std::string trim_left_to(const std::string &str, const std::string &chars = "\n\r ");
NBSAPI strvec split(const std::string &str, const std::string &delim);
NBSAPI std::string change_extension(const std::string &file, const std::string &new_extension);
} // namespace str

namespace log
{
enum LogLevel
{
    Info = 0,
    Warning = 1,
    Error = 2,
};

NBSAPI std::string log_level_str(LogLevel level);
NBSAPI void log(LogLevel level, const std::string &message);
NBSAPI void info(const std::string &message);
NBSAPI void warning(const std::string &message);
NBSAPI void error(const std::string &message);
} // namespace log

namespace graph
{
template <typename T>
using Edges = std::unordered_set<T>;

template <typename T>
using Graph = std::unordered_map<T, Edges<T>>;

enum GraphError
{
    CycleDependency,
    VertexNotFound
};

template <typename T>
NBSAPI std::unordered_set<T> find_roots(const Graph<T> &graph);

template <typename T>
NBSAPI std::vector<std::vector<T>> topological_levels(
    const Graph<T> &graph, const Edges<T> &roots);
} // namespace graph

namespace target
{
enum BuildError
{
    BUILD_CMD_ERROR,
    BUILD_NO_RULE_FOR_TARGET_ERROR,
    BUILD_CYCLE_DEPENDENCY_ERROR,
};

struct Target
{
    os::path output;
    std::vector<os::Cmd> cmds;
    os::pathvec dependencies;

    Target(const os::path &output, const os::Cmd &cmd, const os::pathvec &dependencies = {});
    Target(const os::path &output, const std::vector<os::Cmd> &cmds, const os::pathvec &dependencies = {});

    void build() const;
};

struct TargetMap
{
    std::unordered_map<std::string, Target> targets;

    TargetMap() = default;

    void insert(Target &target);
    bool remove(const std::string &target);
    void build(const std::string &output) const;
    void build_if_needs(const std::string &output) const;
    bool needs_rebuild(const os::path &output) const;
};
} // namespace target

namespace c
{
enum class Compiler
{
    CC,
    CXX,
    GCC,
    GXX,
    CLANG,
    CLANGXX,
    MSVC,
};

struct CDefaults
{
    Compiler compiler = Compiler::CXX;
    std::string standard;
    strvec flags;
    os::pathvec include_paths;
    os::pathvec libs;
    os::pathvec lib_paths;
    strvec defines;
    strvec other_flags;
};

NBSAPI CDefaults *get_cdefaults();
struct CompileOptions
{
    Compiler compiler = get_cdefaults()->compiler;
    std::string standard = get_cdefaults()->standard;
    strvec flags = get_cdefaults()->flags;
    os::pathvec include_paths = get_cdefaults()->include_paths;
    os::pathvec libs = get_cdefaults()->libs;
    os::pathvec lib_paths = get_cdefaults()->lib_paths;
    strvec defines = get_cdefaults()->defines;
    strvec other_flags = get_cdefaults()->other_flags;

    os::Cmd cmd(const os::pathvec &sources, const strvec &additional_flags = {}) const;
    os::Cmd exe_cmd(const os::path &output, const os::pathvec &sources) const;
    os::Cmd obj_cmd(const os::path &output, const os::path &source) const;
    os::Cmd static_lib_cmd(const os::path &output, const os::pathvec &sources) const;
    os::Cmd dynamic_lib_cmd(const os::pathvec &sources) const; // TODO
};

NBSAPI std::string comp_str(Compiler comp);
NBSAPI Compiler current_compiler();

}; // namespace c

namespace wget {
enum class WgetBackend {
    Wget,
    Curl,
    PowerShell,
};

void make_available(const os::path &path, const std::string &url, WgetBackend backend = WgetBackend::Curl);
}; // namespace wget

namespace vcpkg
{
struct TargetTriplet {
    std::string triplet;
    bool is_static;

    std::string to_string() const;
};

struct Vcpkg {
    TargetTriplet triplet;
    nbs::os::path root;

    Vcpkg();

    Vcpkg &with_triplet(const std::string &triplet);
    Vcpkg &with_root(const nbs::os::path &path);
    nbs::os::pathvec include_paths() const;
    nbs::os::pathvec library_paths() const;

    void install() const;
};
}; // namespace vcpkg
}; // namespace nbs

// -------------------------------
//
//        Implementation
//
// -------------------------------

#ifdef NBS_IMPLEMENTATION

namespace nbs
{
NBSAPI void self_update(int argc, char **argv, const std::string &source)
{
    assert(argc > 0);
    std::string exe(argv[0]);

    if (os::compare_last_mod_time(source, exe) < 0) return;

    log::info("Updating");
    log::info("Renaming " + exe + " to " + exe + ".old");
    os::rename(exe, exe + ".old");

    os::Cmd compile_cmd;
    compile_cmd.append_many({c::comp_str(c::current_compiler()), source});
#if defined(_MSC_VER) && !defined(__clang__)
    compile_cmd.append_many({"-Fe:" + exe, "-FC", "-EHsc", "-nologo"});
#else
    compile_cmd.append_many({"-o", exe});
#endif
    compile_cmd.run_or_die("Error during self_update!!!");

    os::Cmd exe_cmd(exe);
    for (int i = 1; i < argc; i++)
    {
        exe_cmd.append(argv[i]);
    }
    exe_cmd.run();

    exit(0);
}

namespace os
{
Path::Path(const std::string &str) : buf(str) {}
Path::Path(const char *str) : buf(str) {}

// TODO: Windows...
Path &Path::operator /=(const Path &other) {
    if (this->buf.back() != '/') {
        this->buf.push_back('/');
    }

    auto iter = other.buf.begin();
    if (*iter == '/') {
        iter++;
    }

    this->buf.append(iter, other.buf.end());

    return *this;
}

Path Path::operator /(const Path &other) const {
    return Path(*this) /= other;
}

Path &Path::operator /=(const std::string &other) {
    return *this /= Path(other);
}

Path Path::operator /(const std::string &other) const {
    return *this / Path(other);
}

Path &Path::operator /=(const char *other) {
    return *this /= Path(other);
}

Path Path::operator /(const char *other) const {
    return *this / Path(other);
}

#ifdef _WIN32
Process::Process(HANDLE handle)
    : handle(handle)
{
}
#else
Process::Process(int pid)
    : pid(pid)
{
}
#endif

void Process::await() const
{
#ifdef _WIN32
    DWORD result = WaitForSingleObject(handle, INFINITE);

    if (result == WAIT_FAILED)
    {
        log::error(os::windows_last_error_str());
        // TODO: Error
        throw PROCESS_WAIT_ERROR;
    }

    DWORD exit_status;
    // TODO: Error
    if (!GetExitCodeProcess(handle, &exit_status)) throw PROCESS_GET_EXIT_CODE_ERROR;

    // TODO: Error
    if (exit_status != 0) throw PROCESS_EXIT_STATUS_ERROR;

    CloseHandle(handle);
#else
    while (true)
    {
        int status = 0;
        if (waitpid(pid, &status, 0) < 0)
        {
            // TODO: Error
            throw PROCESS_WAIT_ERROR;
        }

        if (WIFEXITED(status))
        {
            int exit_status = WEXITSTATUS(status);
            if (exit_status == 0) return;
            // TODO: Error
            else throw PROCESS_EXIT_STATUS_ERROR;
        }

        // TODO: Error
        if (WIFSIGNALED(status)) throw PROCESS_WAIT_ERROR;
    }
#endif
}

NBSAPI void await_processes(const std::vector<Process> &processes)
{
    for (const auto &proc : processes)
    {
        proc.await();
    }
}

Cmd::Cmd()
{
}

Cmd::Cmd(const std::string &cmd)
{
    append(cmd);
}

Cmd::Cmd(const std::initializer_list<std::string> &cmd)
{
    append_many(cmd);
}

void Cmd::append(const std::string &item)
{
    items.emplace_back(item);
}

void Cmd::append_many(const strvec &items)
{
    for (auto item : items)
    {
        append(item);
    }
}

void Cmd::append_many_prefixed(const std::string &prefix, const strvec &items)
{
    for (auto item : items)
    {
        append(prefix + item);
    }
}

std::string Cmd::to_string() const
{
    // TODO: escape item
    if (items.empty())
        return "";

    std::stringstream ss;
    for (size_t i = 0; i < items.size() - 1; i++)
    {
        ss << items[i] << " ";
    }
    ss << items[items.size() - 1];

    return ss.str();
}

void Cmd::run() const
{
    run_async().await();
}

Process Cmd::run_async() const
{
    // TODO: Error
    if (items.empty()) throw PROCESS_EMPTY_CMD_ERROR;

    std::string args_str = to_string();
    log::info("CMD: " + args_str);

#ifdef _WIN32
    char *args = (char *)args_str.c_str(); // TODO: Proper Cmd.to_string
    STARTUPINFO startupinfo;
    ZeroMemory(&startupinfo, sizeof(startupinfo));
    startupinfo.cb = sizeof(startupinfo);

    startupinfo.hStdInput = GetStdHandle(STD_INPUT_HANDLE);
    // TODO: Error
    if (startupinfo.hStdInput == INVALID_HANDLE_VALUE) throw PROCESS_GET_HANDLE_ERROR;

    startupinfo.hStdOutput = GetStdHandle(STD_OUTPUT_HANDLE);
    // TODO: Error
    if (startupinfo.hStdOutput == INVALID_HANDLE_VALUE) throw PROCESS_GET_HANDLE_ERROR;

    startupinfo.hStdError = GetStdHandle(STD_ERROR_HANDLE);
    // TODO: Error
    if (startupinfo.hStdError == INVALID_HANDLE_VALUE) throw PROCESS_GET_HANDLE_ERROR;

    startupinfo.dwFlags |= STARTF_USESTDHANDLES;

    PROCESS_INFORMATION process_info;
    ZeroMemory(&process_info, sizeof(process_info));

    BOOL success = CreateProcessA(NULL, args, NULL, NULL, TRUE, 0, NULL, NULL, &startupinfo, &process_info);
    // TODO: Error
    if (!success) throw PROCESS_CREATE_ERROR;

    CloseHandle(process_info.hThread);

    return process_info.hProcess;
#else
    int p = fork();
    if (p < 0) throw PROCESS_CREATE_ERROR;
    else if (p == 0)
    {
        auto args = to_c_argv();
        execvp(args[0], args.get());
        throw PROCESS_EXEC_ERROR;
    }
    return p;
#endif
}

void Cmd::run_or_die(const std::string &message) const
{
    try {
        run();
    // TODO: Error
    } catch (int) {
        nbs::log::error(message);
        exit(1);
    }
}

std::unique_ptr<char *[]> Cmd::to_c_argv() const
{
    auto result = std::make_unique<char *[]>(items.size() + 1);
    for (size_t i = 0; i < items.size(); i++)
    {
        result[i] = (char *)items[i].c_str();
    }
    result[items.size()] = NULL;
    return result;
}

#ifdef _WIN32
std::string windows_error_code_to_str(DWORD error)
{
    // https://stackoverflow.com/questions/1387064/how-to-get-the-error-message-from-the-error-code-returned-by-getlasterror

    LPSTR messageBuffer = nullptr;

    DWORD size = FormatMessage(
        FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS, nullptr, error,
        MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), reinterpret_cast<LPSTR>(&messageBuffer), 0, nullptr);

    return messageBuffer;
}

std::string windows_last_error_str()
{
    DWORD error = GetLastError();
    return windows_error_code_to_str(error);
}
#endif

NBSAPI strvec paths_to_strs(const pathvec &paths)
{
    strvec result;
    for (const path &path : paths)
    {
        result.push_back(path.buf);
    }
    return result;
}

NBSAPI pathvec strs_to_paths(const strvec &paths)
{
    size_t size = paths.size();
    pathvec result(size);
    std::copy_n(paths.begin(), size, result.begin());
    return result;
}

NBSAPI long compare_last_mod_time(const path &path1, const path &path2)
{
    long time1 = os::last_write_time(path1);
    long time2 = os::last_write_time(path2);
    return time1 - time2;
}

NBSAPI bool make_directory_if_not_exists(const path &path)
{
#if _WIN32
    // TODO: Error handling
    CreateDirectory(path.buf.c_str(), NULL);
    return true;
#else
    if (exists(path)) {
        return true;
    }

    return mkdir(path.buf.c_str(), 0777) == 0;
#endif
}

NBSAPI bool exists(const path &path)
{
    struct stat st{};
    return stat(path.buf.c_str(), &st) == 0;
}

NBSAPI void rename(const os::path &from, const path &to) {
#if _WIN32
    MoveFileEx(from.buf.c_str(), to.buf.c_str(), MOVEFILE_REPLACE_EXISTING);
#else
    // TODO: Error handling
    int ret = std::rename(from.buf.c_str(), to.buf.c_str());
    if (ret != 0) throw "Could not rename directory";
#endif
}

NBSAPI long last_write_time(const os::path &path) {
#if _WIN32
    const int64_t WINDOWS_TICK = 10000000;
    const int64_t SEC_TO_UNIX_EPOCH = 11644473600LL;

    HANDLE hfile = CreateFile(
        path.buf.c_str(),
        GENERIC_READ,
        FILE_SHARE_READ|FILE_SHARE_WRITE,
        NULL,
        OPEN_EXISTING,
        FILE_ATTRIBUTE_NORMAL,
        NULL
    );
    FILETIME last_write;
    // TODO: Error handling
    GetFileTime(hfile, NULL, NULL, &last_write);
    int64_t val = *(int64_t *) &last_write;
    val = val / WINDOWS_TICK - SEC_TO_UNIX_EPOCH;
    CloseHandle(hfile);
    return val;
#else
    struct stat st{};
    stat(path.buf.c_str(), &st);
    return st.st_ctimespec.tv_sec;
#endif
}
} // namespace os

namespace str
{
NBSAPI std::string join(const std::string &sep, const strvec &strings)
{
    if (strings.empty())
        return "";

    if (strings.size() == 1)
        return strings[0];

    std::stringstream ss;
    for (size_t i = 0; i < strings.size() - 1; i++)
    {
        ss << strings[i];
        ss << sep;
    }
    ss << strings.back();

    return ss.str();
}

NBSAPI std::string trim_to(const std::string &str, const std::string &chars)
{
    return trim_right_to(trim_left_to(str), chars);
}

NBSAPI std::string trim_right_to(const std::string &str, const std::string &chars)
{
    size_t count = str.size();
    while (count > 0 && chars.find(str[count - 1]) == std::string::npos)
    {
        count--;
    }
    return str.substr(0, count);
}

NBSAPI std::string trim_left_to(const std::string &str, const std::string &chars)
{
    size_t index = 0;
    while (index < str.size() && chars.find(str[index]) == std::string::npos)
    {
        index++;
    }
    return str.substr(index);
}

NBSAPI strvec split(const std::string &str, const std::string &delim)
{
    if (str.empty())
        return {""};

    strvec result;
    size_t index = 0;
    size_t count = 0;

    for (size_t i = 0; i < str.size(); i++)
    {
        char c = str[i];
        if (delim.find(c) == std::string::npos)
        {
            count++;
        }
        else
        {
            result.emplace_back(str.substr(index, count));
            index = i + 1;
            count = 0;
        }
    }
    result.emplace_back(str.substr(index, count));

    return result;
}

NBSAPI std::string change_extension(const std::string &file, const std::string &new_extension)
{
    return trim_right_to(file, ".") + new_extension;
}
} // namespace str

namespace log
{
static LogLevel minimal_level = Info;

NBSAPI std::string log_level_str(LogLevel level)
{
    switch (level)
    {
    case Info:
        return "INFO";
    case Warning:
        return "WARNING";
    case Error:
        return "ERROR";
    default:
        return "UNKNOWN LOG LEVEL";
    }
}

NBSAPI void log(LogLevel level, const std::string &message)
{
    if (level < minimal_level)
        return;

    (level == Info ? std::cout : std::cerr) << '[' << log_level_str(level) << "] " << message << '\n';
}

NBSAPI void info(const std::string &message)
{
    log(Info, message);
}

NBSAPI void warning(const std::string &message)
{
    log(Warning, message);
}

NBSAPI void error(const std::string &message)
{
    log(Error, message);
}

} // namespace log

namespace graph
{
template <typename T>
NBSAPI std::unordered_set<T> find_roots(const Graph<T> &graph)
{
    std::unordered_set<T> result;

    for (const auto &pair : graph)
    {
        result.insert(pair.first);
    }

    for (const auto &pair : graph)
    {
        for (const auto &vertex : pair.second)
        {
            result.erase(vertex);
        }
    }

    return result;
}

template <typename T>
NBSAPI std::vector<std::vector<T>> topological_levels(
    const Graph<T> &graph, const Edges<T> &roots
) {
    struct Vertex
    {
        const T &name;
        const std::unordered_set<T> &edges;
        ptrdiff_t level;
        bool has_level;
        bool traversing;

        Vertex(const T &name, const Edges<T> &edges)
            : name(name), edges(edges), level(0), has_level(false), traversing(false)
        {
        }
        Vertex(const T &name, const Edges<T> &edges, ptrdiff_t level, bool has_level)
            : name(name), edges(edges), level(level), has_level(has_level), traversing(false)
        {
        }
    };

    std::unordered_map<T, Vertex> vertices;
    for (const auto &pair : graph)
    {
        vertices.insert({pair.first, Vertex(pair.first, pair.second)});
    }

    ptrdiff_t max_level = 0;
	
    std::function<void(Vertex &, ptrdiff_t)> do_search =
        [&](Vertex &vertex, ptrdiff_t level) -> void {
            if (vertex.traversing) throw CycleDependency;

            vertex.traversing = true;

            ptrdiff_t v_level = vertex.has_level ? vertex.level : -1;
            if (v_level <= level) {
                vertex.level = level;
                vertex.has_level = true;
            }

            for (const T &edge : vertex.edges)
            {
                auto vertex_search = vertices.find(edge);
                if (vertex_search == vertices.end()) throw VertexNotFound;
                Vertex &v = vertex_search->second;

				do_search(v, level + 1);
            }

            vertex.traversing = false;

            if (level > max_level)
                max_level = level;
        };

    Vertex root("", roots);

	do_search(root, -1);

    std::vector<std::vector<T>> result(max_level + 1);

    for (const auto &v : vertices)
    {
        if (!v.second.has_level) continue;
        if (v.second.level < 0) continue;

        result[v.second.level].emplace_back(v.first);
    }

    return result;
}
} // namespace graph

namespace target
{
Target::Target(const os::path &output, const os::Cmd &cmd, const os::pathvec &dependencies)
    : output(output), cmds({cmd}), dependencies(dependencies)
{
}
Target::Target(const os::path &output, const std::vector<os::Cmd> &cmds, const os::pathvec &dependencies)
    : output(output), cmds(cmds), dependencies(dependencies)
{
}

void Target::build() const
{
    for (const auto &cmd : cmds)
    {
        cmd.run();
    }
}

void TargetMap::insert(Target &target)
{
    targets.insert({target.output.buf, target});
}

bool TargetMap::remove(const std::string &target_output)
{
    return targets.erase(target_output) > 0;
}

void TargetMap::build(const std::string &output) const
{
    auto target_it = targets.find(output);
    if (target_it == targets.end()) throw BUILD_NO_RULE_FOR_TARGET_ERROR;
    auto target = target_it->second;

    for (const auto &dep : target.dependencies)
    {
        if (os::exists(dep))
            continue;

        build(dep.buf);
    }

    target.build();
}

void TargetMap::build_if_needs(const std::string &output) const
{
    if (!needs_rebuild(output)) return;

    auto target = targets.find(output)->second; // TODO: error handling
    graph::Graph<std::string> graph;
    for (const auto &p : targets)
    {
        graph::Edges<std::string> edges;
        for (const auto &e : p.second.dependencies)
        {
            edges.insert(e.buf);
            graph[e.buf];
        }
        graph[p.first] = edges;
    }

    std::vector<std::vector<std::string>> levels;
    try {
        levels = graph::topological_levels<std::string>(graph, {target.output.buf});
    } catch (graph::GraphError e) {
        switch (e)
        {
        case graph::CycleDependency:
            throw BUILD_CYCLE_DEPENDENCY_ERROR;
        case graph::VertexNotFound:
            throw BUILD_NO_RULE_FOR_TARGET_ERROR;
        default:
            assert(0 && "Unreachable");
        }
    }

    for (ptrdiff_t i = levels.size() - 1; i >= 0; i--)
    {
        std::vector<os::Process> processes;
        for (const auto &t_name : levels[i])
        {
            auto t_search = targets.find(t_name); 
            if (t_search != targets.end())
            {
                if (!needs_rebuild(t_name))
                    continue;
                auto t = t_search->second;
                try {
                    os::Process p = t.cmds[0].run_async();
                    processes.emplace_back(p); // TODO: multiple commands
                } catch (os::ProcessError e) {
                    throw BUILD_CMD_ERROR;
                }
            }
            else if (!os::exists(t_name)) throw BUILD_NO_RULE_FOR_TARGET_ERROR;
        }

        try {
            await_processes(processes);
        } catch (os::ProcessError e) {
            throw BUILD_CMD_ERROR;
        }
    }
}

bool TargetMap::needs_rebuild(const os::path &output) const
{
    if (!os::exists(output)) return true;

    auto target_it = targets.find(output.buf);
    if (target_it == targets.end())
        TODO("needs_rebuild error handling");
    auto target = target_it->second;

    for (const auto &dep : target.dependencies)
    {
        if (((targets.find(dep.buf) != targets.end()) && needs_rebuild(dep)) ||
            (((targets.find(dep.buf) != targets.end()) && !os::exists(dep)) ||
             (os::exists(dep) && (os::compare_last_mod_time(output, dep) < 0))))
        {
            return true;
        }
    }
    return false;
}
} // namespace target

namespace c {
static CDefaults cdefaults;

NBSAPI std::string comp_str(Compiler comp)
{
    switch (comp)
    {
    case Compiler::CC:
        return "cc";
    case Compiler::CXX:
        return "c++";
    case Compiler::GCC:
        return "gcc";
    case Compiler::GXX:
        return "g++";
    case Compiler::CLANG:
        return "clang";
    case Compiler::CLANGXX:
        return "clang++";
    case Compiler::MSVC:
        return "cl.exe";
    default:
        return "UNKNOWN COMPILER";
    }
}

NBSAPI Compiler current_compiler()
{
//  Clang C++ emulates GCC, so it has to appear early.
#if defined __clang__ && !defined(__ibmxl__) && !defined(__CODEGEARC__)
    return Compiler::CLANGXX;

// MINGW32
#elif defined(__MINGW32__)
    TODO("mingw")

//  GNU C++:
#elif defined(__GNUC__) && !defined(__ibmxl__)
    return Compiler::GXX;

//  Microsoft Visual C++
#elif defined _MSC_VER
    return Compiler::MSVC;
#endif

    TODO("Unknown compiler");
}

NBSAPI CDefaults *get_cdefaults()
{
    return &cdefaults;
}

os::Cmd CompileOptions::cmd(const os::pathvec &sources, const strvec &additional_flags) const
{
    // TODO: fucking windows pain
    os::Cmd cmd;

    cmd.append(comp_str(compiler));
    if (!standard.empty())
        cmd.append("-std=" + standard);

    cmd.append_many(additional_flags);

    cmd.append_many(flags);
    cmd.append_many_prefixed("-I", os::paths_to_strs(include_paths));
    cmd.append_many_prefixed("-D", defines);
    cmd.append_many(other_flags);

    cmd.append_many(os::paths_to_strs(sources));

    cmd.append_many_prefixed("-L", os::paths_to_strs(lib_paths));
    cmd.append_many_prefixed("-l", os::paths_to_strs(libs));

    return cmd;
}

os::Cmd CompileOptions::exe_cmd(const os::path &output, const os::pathvec &sources) const
{
    strvec additional_flags;
    if (compiler == Compiler::MSVC)
    {
        additional_flags.emplace_back("-Fe:" + output.buf);
    }
    else
    {
        additional_flags.emplace_back("-o");
        additional_flags.emplace_back(output.buf);
    }

    return this->cmd(sources, additional_flags);
}

os::Cmd CompileOptions::obj_cmd(const os::path &output, const os::path &source) const
{
    strvec additional_flags;
    additional_flags.emplace_back("-c");
    if (compiler == Compiler::MSVC)
    {
        additional_flags.emplace_back("-Fo:" + output.buf);
    }
    else
    {
        additional_flags.emplace_back("-o");
        additional_flags.emplace_back(output.buf);
    }
    return this->cmd({source}, additional_flags);
}

os::Cmd CompileOptions::static_lib_cmd(const os::path &output, const os::pathvec &objects) const
{
    os::Cmd cmd({"ar", "r", output.buf});
    cmd.append_many(os::paths_to_strs(objects));
    return cmd;
}
} // namespace c

namespace wget {
void make_available(const os::path &path, const std::string &url, WgetBackend backend) {
    if (exists(path)) return;

    switch (backend) {
        case WgetBackend::Wget: {
            TODO("download with Curl");
        } break;

        case WgetBackend::Curl: {
            auto cmd = os::Cmd({"curl", "-L", "-o", path.buf, url});
            cmd.run();
        } break;

        case WgetBackend::PowerShell: {
            TODO("download with PowerShell");
        } break;
    }
}
} // namespace wget

namespace vcpkg {
std::string TargetTriplet::to_string() const {
    return triplet;
}

Vcpkg::Vcpkg() : root("vcpkg_installed") {}

Vcpkg &Vcpkg::with_triplet(const std::string &triplet) {
    bool is_static = triplet.find("-static") != std::string::npos;
    this->triplet = TargetTriplet { triplet, is_static };
    return *this;
}

Vcpkg &Vcpkg::with_root(const nbs::os::path &path) {
    this->root = path;
    return *this;
}

nbs::os::pathvec Vcpkg::include_paths() const {
    return { root / triplet.to_string() / "include" };
}

nbs::os::pathvec Vcpkg::library_paths() const {
    return { root / triplet.to_string() / "lib" };
}

void Vcpkg::install() const {
    nbs::os::Cmd({
        "vcpkg", "install",
        "--triplet=" + triplet.to_string(),
        "--vcpkg-root=" + root.buf,
    }).run();
}
} // namespace vcpkg
} // namespace nbs

#endif // NBS_IMPLEMENTATION
#endif // NBS_HPP
