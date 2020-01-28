(declare-project
  :name "http"
  :description "A janet http client library"
  :author "Sean Walker"
  :license "MIT"
  :url "https://github.com/joy-framework/http"
  :repo "git+https://github.com/joy-framework/http")


(declare-native
  :name "http"
  :embedded ["http_lib.janet"]
  :lflags ["-lcurl"]
  :source ["http.c"])
