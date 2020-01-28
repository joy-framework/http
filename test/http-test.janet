(import tester :prefix "" :exit true)
(import build/http :as http)


(deftest
  (test "get"
    (= 200
       (-> (http/get "http://example.com")
           (get :status))))

  (test "get response headers"
    (= "text/html; charset=UTF-8"
       (-> (http/get "http://example.com")
           (get-in [:headers "Content-Type"]))))

  (test "get body"
    (not
     (empty?
       (-> (http/get "http://example.com")
           (get :body)))))

  (test "get with 302"
    (= 302
       (-> (http/get "httpstat.us/302")
           (get :status))))

  (test "get with follow-redirects"
    (= 200
       (-> (http/get "httpstat.us/302" :follow-redirects true)
           (get :status))))

  (test "post"
    (string/find "\"form\":{\"a\":\"1\",\"b\":\"2\"}"
       (-> (http/post "https://postman-echo.com/post" "a=1&b=2")
           (get :body))))

  (test "delete"
    (= 405
       (-> (http/delete "example.com")
           (get :status)))))

#  (test "post with dictionary"
#    (= 200
#       (-> (http/post "example.com" {:a 1 :b 2})
#           (get :status))))

#  (test "put"
#    (= 200
#       (-> (http/put "example.com" {:a 1 :b 2})
#           (get :status))))

