(ns students.db.groups
  (:require [hugsql.core :as hugsql]))

(hugsql/def-db-fns "sql/groups.sql")
