# students

Webapp for managing some educational organization database

## Prerequisites

You will need [Leiningen][] 2.0.0 or above installed.

[leiningen]: https://github.com/technomancy/leiningen

## Running

To start a web server for the application, run:

```console
export DATABASE_URL="jdbc:postgres://<host>:<port>?user=<user>&password=<password>"

lein ring server
```

## Building and running JAR for production

You will need Java version 21 or newer. To compile application to JAR file and
start using jetty, run:

```console
lein ring uberjar

# DATABASE_URL is slightly different format because we are using Jetty here
export DATABASE_URL="jdbc:postgresql://<host>:<port>?user=<user>&password=<password>"

java -jar target/students-0.1.0-SNAPSHOT-standalone.jar
```
