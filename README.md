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
```

Send get requests!

```clojure
(= @{:status 200 :body "..." :headers {"Content-Type" "text/html; charset=UTF-8" ...}}
   (http/get "example.com"))
```

... and post requests!

```clojure
(http/post "example.com" "param1=value1&param2=value2")
```

follow redirects!

```clojure
(http/get "httpstat.us/302" :follow-redirects true)
```

send custom http methods too!

*head, trace, delete, put, and patch supported

```clojure
(http/delete "example.com/accounts/1")
```
