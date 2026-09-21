# Build tools per language

Every migrated lab gets one real build tool for its language, and that tool is pinned in the
course `mise.toml` `[tools]` section so `mise install` inside the course directory is enough to
build it.

The root `mise.toml` already pins `cmake`, `ninja`, `typst`, `typstyle` for the whole monorepo
— do **not** repeat those in a course config. Only add what the course itself needs.

Verify a tool name before writing it: `mise registry | grep -i <tool>`. After editing
`[tools]`, run `mise install` in the course directory to confirm it resolves.

## C / C++ — CMake + Ninja

Nothing goes in `[tools]` (inherited from the root). Course root `CMakeLists.txt`:

```cmake
cmake_minimum_required(VERSION 3.14)

project(programming-c)

add_subdirectory(lab-1)
add_subdirectory(lab-2)
```

`lab-1/CMakeLists.txt`:

```cmake
add_executable(lab-1 src/main.c)
target_link_libraries(lab-1 m)       # only when the lab uses <math.h>
```

For C++ set the standard per target: `target_compile_features(lab-1 PRIVATE cxx_std_17)`.
Qt labs additionally need `find_package(Qt6 REQUIRED COMPONENTS Widgets)`, `set(CMAKE_AUTOUIC
ON)` / `AUTOMOC` / `AUTORCC`, and `qt6` in `[tools]`.

Tasks (extend the root templates; this is exactly term-1's config):

```toml
[tasks.configure]
extends = "cmake:configure"
sources = ["CMakeLists.txt", "lab-*/CMakeLists.txt"]
outputs = ["build/build.ninja"]

[tasks.build]
extends = "cmake:build"
depends = ["configure"]
sources = ["lab-*/src/**", "lab-*/CMakeLists.txt", "CMakeLists.txt"]
outputs = { auto = true }
```

`.gitignore`: `build/`, `reports/`.

## Rust — Cargo

```toml
[tools]
rust = "latest"
```

Course root `Cargo.toml` as a workspace, one member per lab (the term-5 computer-graphics
pattern):

```toml
[workspace]
members = ["lab-1", "lab-2"]
resolver = "2"

[workspace.dependencies]
anyhow = "1"
```

`lab-1/Cargo.toml` uses `anyhow = { workspace = true }` for anything shared.

```toml
[tasks.build]
description = "Build every lab"
run = "cargo build --workspace"
sources = ["Cargo.toml", "Cargo.lock", "lab-*/Cargo.toml", "lab-*/src/**"]
outputs = { auto = true }

[tasks.run]
description = "Run one lab"
usage = 'arg "<num>" help="lab number"'
run = 'cargo run -p lab-{{ usage.num }}'
```

`.gitignore`: `target/`, `reports/`. Commit `Cargo.lock`.

## Python — uv

```toml
[tools]
uv = "latest"
python = "3.13"
```

`pyproject.toml` at the course root, labs as packages or plain scripts under `lab-N/`:

```toml
[project]
name = "computer-science"
version = "0.1.0"
requires-python = ">=3.13"
dependencies = ["numpy>=2.2", "matplotlib>=3.10"]

[dependency-groups]
dev = ["ipykernel>=6.29"]
```

```toml
[tasks.sync]
description = "Install the Python environment"
run = "uv sync"
sources = ["pyproject.toml", "uv.lock"]
outputs = { auto = true }

[tasks.run]
description = "Run one lab"
usage = 'arg "<num>" help="lab number"'
depends = ["sync"]
run = 'uv run lab-{{ usage.num }}/main.py'
```

`.gitignore`: `.venv/`, `__pycache__/`, `reports/`. Commit `uv.lock`.

## Java — Maven

```toml
[tools]
java = "temurin-21"
maven = "latest"
```

Maven needs a JDK on `PATH`, so `java` is pinned alongside it, not optional.

Multi-module build: a parent `pom.xml` at the course root listing one module per lab.

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0">
  <modelVersion>4.0.0</modelVersion>

  <groupId>ru.pgups.uni</groupId>
  <artifactId>programming-java</artifactId>
  <version>1.0-SNAPSHOT</version>
  <packaging>pom</packaging>

  <modules>
    <module>lab-1</module>
    <module>lab-2</module>
  </modules>

  <properties>
    <maven.compiler.release>21</maven.compiler.release>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
  </properties>
</project>
```

`lab-1/pom.xml`, with the exec plugin configured so `mvn -pl lab-1 exec:java` needs no
`-Dexec.mainClass` on the command line:

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0">
  <modelVersion>4.0.0</modelVersion>

  <parent>
    <groupId>ru.pgups.uni</groupId>
    <artifactId>programming-java</artifactId>
    <version>1.0-SNAPSHOT</version>
  </parent>

  <artifactId>lab-1</artifactId>

  <build>
    <plugins>
      <plugin>
        <groupId>org.codehaus.mojo</groupId>
        <artifactId>exec-maven-plugin</artifactId>
        <version>3.5.0</version>
        <configuration>
          <mainClass>ru.pgups.lab1.Main</mainClass>
        </configuration>
      </plugin>
    </plugins>
  </build>
</project>
```

Maven's standard layout applies: sources go to `lab-1/src/main/java/<package>/`, tests to
`lab-1/src/test/java/`, resources to `lab-1/src/main/resources/`. This is the one place the
repo's plain `lab-N/src/` convention gives way — listings in the report then read from the
full path:

```typ
#code-file(read("./src/main/java/ru/pgups/lab1/Main.java"), name: "Main.java")
```

```toml
[tasks.build]
description = "Compile every lab"
run = "mvn -q compile"
sources = ["pom.xml", "lab-*/pom.xml", "lab-*/src/**"]
outputs = { auto = true }

[tasks.test]
description = "Run every lab's tests"
run = "mvn -q test"

[tasks.run]
description = "Run one lab"
usage = 'arg "<num>" help="lab number"'
run = 'mvn -q -pl lab-{{ usage.num }} exec:java'
```

`.gitignore`: `target/`, `reports/`. Maven writes a `target/` per module, so the single
top-level entry covers `lab-*/target/` too only if it is written `target/` without a leading
slash — keep it that way.

## Clojure — Leiningen

```toml
[tools]
java = "temurin-21"
leiningen = "latest"
```

Leiningen has no workspace concept, so each lab keeps its own `project.clj` (this is how
`bachelors/term-5/programming-java` is laid out) and tasks `cd` into the lab:

```toml
[tasks.build]
description = "Build one lab's uberjar"
usage = 'arg "<num>" help="lab number"'
dir = "lab-{{ usage.num }}"
run = "lein uberjar"

[tasks.run]
description = "Run one lab"
usage = 'arg "<num>" help="lab number"'
dir = "lab-{{ usage.num }}"
run = "lein run"
```

`.gitignore`: `target/`, `reports/`.

## Other languages

| Language | Tool | `[tools]` entry |
| --- | --- | --- |
| Go | go modules | `go = "latest"` |
| C# / .NET | `dotnet` | `dotnet = "latest"` |
| Kotlin | Gradle | `java = "temurin-21"`, `gradle = "latest"` |
| Scala | sbt | `java = "temurin-21"`, `sbt = "latest"` |
| Zig | `zig build` | `zig = "latest"` |
| R | Rscript | `r = "latest"` — check `mise registry` first |
| Haskell | Cabal | `ghc = "latest"` |
| Node / web | npm or pnpm | `node = "latest"` |

Pattern for any of them: one config file at the course root or per lab, a `build` task and a
`run <num>` task, `sources`/`outputs` declared, outputs gitignored.

## When there is no viable build tool

WinAsm `.wap` projects, MASM-only assembly, .NET Framework `.sln`, MathCAD worksheets, Delphi
— these cannot be built on this machine. Do not fabricate a build:

- migrate the report only;
- leave the sources in place under `lab-N/src/` (still kebab-cased);
- add no `[tools]` entry and no build task for that course;
- note it in the commit body and in what you report back to the user.

The report still references the sources with `#code-file(read("./src/lab_1.asm"), name:
"lab_1.asm")` — listings work regardless of whether anything can compile them.
