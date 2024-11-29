(ns students.db.faculties
  (:require [hugsql.core :as hugsql]))

(hugsql/def-db-fns "sql/faculties.sql")
