# http

A janet http client

## Install

Add to your `project.janet` file

```clojure
{:dependencies ["https://github.com/joy-framework/http"]}
```

## Use

```clojure
(import http)

(= @{:status 200 :body "..." :headers {"Content-Type" "text/html; charset=UTF-8" ...}}
   (http/get "example.com"))
```
