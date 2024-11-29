(ns user
  (:require [ragtime.jdbc :as jdbc]))

#_{:clj-kondo/ignore [:clojure-lsp/unused-public-var]}
(def config
  {:datastore  (jdbc/sql-database {:connection-uri (System/getenv "DATABASE_URL")})
   :migrations (jdbc/load-resources "migrations")})
