(ns students.db.marks
  (:require [hugsql.core :as hugsql]))

(hugsql/def-db-fns "sql/marks.sql")
