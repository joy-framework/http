# http_lib.janet


(defn parse-headers [response]
  (let [str (get response :headers)]
    (->> (string/split "\r\n" str)
         (filter |(string/find ":" $))
         (mapcat |(string/split ":" $ 0 2))
         (map string/trim)
         (apply table)
         (freeze))))


(defn request [method url options]
  (let [options (merge options {:method method})
        response (send-request url options)
        headers (parse-headers response)]
    (merge response {:headers headers})))


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

