(ns students.db.core)

(def db {:connection-uri (System/getenv "DATABASE_URL")})
