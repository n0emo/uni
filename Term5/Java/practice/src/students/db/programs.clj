(ns students.db.programs
  (:require [hugsql.core :as hugsql]))

(hugsql/def-db-fns "sql/programs.sql")
