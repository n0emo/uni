(ns students.db.disciplines
  (:require [hugsql.core :as hugsql]))

(hugsql/def-db-fns "sql/disciplines.sql")
