(defproject students "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :min-lein-version "2.0.0"
  :dependencies [[com.h2database/h2 "2.3.232"]
                 [com.layerware/hugsql "0.5.3"]
                 [compojure "1.6.1"]
                 [dev.weavejester/ragtime "0.10.1"]
                 [hiccup "2.0.0-RC4"]
                 [org.clojure/clojure "1.10.0"]
                 [org.postgresql/postgresql "42.7.4"]
                 [ring/ring-defaults "0.3.2"]
                 [ring/ring-json "0.5.1"]]
  :aot [students.core]
  :plugins [[lein-ring "0.12.5"]]
  :javac-options ["-target" "1.8" "-source" "1.8" "-Xlint:-options"]
  :ring {:handler students.handler/app}
  :aliases {"migrate"  ["run" "-m" "user/migrate"]
            "rollback" ["run" "-m" "user/rollback"]}
  :profiles
  {:dev {:dependencies [[javax.servlet/servlet-api "2.5"]

                        [ring/ring-mock "0.3.2"]]}
   :uberjar {:aot :all
             :main students.core}})
