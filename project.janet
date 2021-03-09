(declare-project
  :name "http"
  :description "A janet http client library"
  :author "Sean Walker"
  :license "MIT"
  :dependencies ["https://github.com/joy-framework/tester"]
  :url "https://github.com/joy-framework/http"
  :repo "git+https://github.com/joy-framework/http")

(def WIN_CURL {
  :x64 { 
    :download-url "https://curl.se/windows/dl-7.75.0_4/curl-7.75.0_4-win64-mingw.zip"
    :lib-path     "./curl/curl-7.75.0-win64-mingw/lib/"
    :bin-path     "./curl/curl-7.75.0-win64-mingw/bin/"
    :include-path "./curl/curl-7.75.0-win64-mingw/include/" }
  :x86 {
    :download-url "https://curl.se/windows/dl-7.75.0_4/curl-7.75.0_4-win32-mingw.zip"
    :lib-path     "./curl/curl-7.75.0-win32-mingw/lib/"
    :bin-path     "./curl/curl-7.75.0-win32-mingw/bin/"
    :include-path "./curl/curl-7.75.0-win32-mingw/include/" }
  })

(defn curl-paths [path-type &opt file]
  (string ((WIN_CURL (os/arch)) path-type) (or file "")))

(def JANET_BINPATH (os/getenv "JANET_BINPATH"))

(def o (os/which))

(def cflags
  (case o
    :windows ["-I." (string "-I" (curl-paths :include-path))]
    #default
    '[]))

(def lflags
  (case o
    :windows [(curl-paths :lib-path "libcurl.a") (curl-paths :lib-path "libcurl.dll.a")]
    #default
    '["-lcurl"]))

(declare-native
  :name "http"
  :embedded ["http_lib.janet"]
  :lflags [;default-lflags ;lflags]
  :cflags [;default-cflags ;cflags]
  :source ["http.c"])


(defn windows-download-curl []
  (os/execute ["powershell.exe" "-command" 
    "& Invoke-RestMethod -Method Get" "-Uri" (curl-paths :download-url) "-OutFile" "curl.zip"] :p))

(defn windows-unzip-curl []
  (os/execute ["powershell.exe" "-command" 
    "Expand-Archive -Force -Path curl.zip -DestinationPath curl"] :p))

(defn windows-install-curl-dlls []
  (def dll-files (string/replace-all "/" "\\" (curl-paths :bin-path "libcurl-x64*")))
  (print "copy " dll-files " to " JANET_BINPATH)
  (os/execute 
    ["cmd.exe" "/c" "copy" dll-files JANET_BINPATH] :p))

(phony "install-deps" []
  (case o
    :windows (do
      (windows-download-curl)
      (windows-unzip-curl))
    #default 
      nil))
    
(phony "install" []
  (case o
    :windows 
      (windows-install-curl-dlls)
    #default 
      nil))
