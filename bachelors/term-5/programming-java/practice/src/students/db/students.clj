(ns students.db.students
  (:require [hugsql.core :as hugsql]))

(hugsql/def-db-fns "sql/students.sql")
