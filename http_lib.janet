# http_lib.janet


(defn merged-table [arr]
  (var output @{})

  (let [parts (partition 2 arr)]
    (each [k v] parts
      (if (get output k)
        (put output k (array/concat @[(get output k)] @[v]))
        (put output k v))))

  output)


(defn parse-headers [response]
  (let [str (get response :headers "")]
    (->> (string/split "\r\n" str)
         (filter |(string/find ":" $))
         (mapcat |(string/split ":" $ 0 2))
         (map string/trim)
         (merged-table)
         (freeze))))


(defn prep-headers [headers]
  (when headers
    (map |(string/format "%s: %s" (first $) (last $)) (pairs headers))))


(defn request [method url options]
  (let [options (merge options {:method method})
        options (update options :headers prep-headers)
        response (send-request url options)
        headers (parse-headers response)]
    (if-let [error-msg (response :error)]
      (errorf "%s" error-msg))
    (merge response {:headers headers})))


(defn form-encode [dict]
  (if (not (dictionary? dict))
    ""
    (do
      (var output @"")
      (var i 0)
      (def len (length dict))

      (eachp [k v] dict
        (buffer/push-string output (string k "=" v))
        (when (< (++ i) len)
          (buffer/push-string output "&")))

      (string output))))


(defn get
  "Sends a get request with libcurl"
  [url & options]
  (request "GET" url (table ;options)))


(defn head
  "Sends a head request with libcurl"
  [url & options]
  (request "HEAD" url (table ;options)))


(defn trace
  "Sends a trace request with libcurl"
  [url & options]
  (request "TRACE" url (table ;options)))


(defn post
  "Sends a post request with libcurl"
  [url body & options]
  (request "POST" url (merge (table ;options)
                        {:body body})))


(defn put
  "Sends a put request with libcurl"
  [url body & options]
  (request "PUT" url (merge (table ;options)
                       {:body body})))


(defn patch
  "Sends a patch request with libcurl"
  [url body & options]
  (request "PATCH" url (merge (table ;options)
                         {:body body})))


(defn delete
  "Sends a delete request with libcurl"
  [url & options]
  (request "DELETE" url (table ;options)))

