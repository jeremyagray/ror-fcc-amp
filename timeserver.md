# Time Server Microservice Project

This API responds to GET requests with a JSON object containing the number of milliseconds since the epoch (unix time) and a UTC time string:

```
{
  "unix": 1627703332000,
  "utc": "Sat, 31 Jul 2021 03:48:52 GMT"
}
```

This data is easily produced with the Date methods `getTime()` and `toUTCString()`, respectively.  The project specifications say

1. `GET /api` returns a JSON object for now.
2. `GET /api/:date` should return JSON corresponding to `date`.  `date` should be parseable by `new Date(date)` in JavaScript.  Beware, because `Date()` can parse quite a lot of strings.
3. An invalid date will trigger an error response:

```
{
  "error": "Invalid Date"
}
```

The plan is simple.  Since this API doesn't have to store data, we don't need to worry with a database or models yet.  We just need to translate the JavaScript we have into some Ruby.  So, we need to implement two `GET` routes (with and without the date string parameter).  To do this, we'll have to create the routes and some code to compute the output and figure out what the Ruby equivalents of the JavaScript `getTime()` and `toUTCString()`.