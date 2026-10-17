(ns user
  (:require [ragtime.jdbc :as jdbc]
            [ragtime.repl :as repl]))

(def config
  {:datastore  (jdbc/sql-database {:connection-uri (System/getenv "DATABASE_URL")})
   :migrations (jdbc/load-resources "migrations")})

#_{:clj-kondo/ignore [:clojure-lsp/unused-public-var]}
(defn migrate []
  (repl/migrate config))

#_{:clj-kondo/ignore [:clojure-lsp/unused-public-var]}
(defn rollback []
  (repl/rollback config))
