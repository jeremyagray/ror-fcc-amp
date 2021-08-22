# File Metadata Microservice Project

As we come to the end, we have an easy project that has some
difficulties.  The actual API part is easy; we post some information,
process it, and return some simple JSON.  This project is actually
trivial in [Express](https://expressjs.com/) since you can use the
[NodeJS](https://nodejs.org/) package
[Multer](https://github.com/expressjs/multer) to do the heavy lifting
of processing the file upload.  Replacing
[Multer](https://github.com/expressjs/multer) will be the first
difficulty.  The second will be the requirement of an actual form in
an actual HTML page, which while a part of all these projects, is only
required here.  The third difficulty is that we have to upload a file,
not a value, and we have to make sure that is done correctly.

## [Specifications](https://www.freecodecamp.org/learn/apis-and-microservices/apis-and-microservices-projects/file-metadata-microservice)

The [specifications](https://www.freecodecamp.org/learn/apis-and-microservices/apis-and-microservices-projects/file-metadata-microservice) are straightforward:

1. Submit a form that includes a file upload.
1. The form file input field has the `name` attribute set to `upfile`.
1. The JSON response is `{ "name": "filename", "type": "filetype",
   "size": "bytes" }`.

### Test Inputs

The HTML form page is fetched and parsed for two items:

1. `assert(doc.querySelector('input[type="file"]'));`
2. `assert(doc.querySelector('input[name="upfile"]'));`

The API endpoint `/api/fileanalyse` is then POSTed with
```
{
  "upfile": <file blob>,
  "name": <file name>
}
```
from which the API should find the size and file type.

## Models

Since the API doesn't need to save anything, no models are necessary.

## Routes

With only one endpoint and one verb, the only route necessary is
```
# File metadata.
  post "/api/fileanalyse", to: "file_metadata#info"
```

## Controllers

Let's generate the controller in the usual way and adding the one method needed.
```
rails generate controller FileMetadata --skip-routes
```
Add the rudimentary `info` method to begin running the FreeCodeCamp tests against the project.
```
  def info
    render json: { "name": params[:name], "type": "text/plain", "size": "42" }
  end
```
We don't have to worry about string versus integer version of the `size` as the tests only assert its existence.  If you run the FreeCodeCamp tests at this point, the project at least passes the "have your own project" test.  You can always code `info` to return the correct answers for the test to make sure everything is correctly connected.

We're not on our own with the form, either, since it's included in the original project boilerplate.  The relevant bits being:
```
<form enctype="multipart/form-data" method="POST" action="/api/fileanalyse">
  <input id="inputfield" type="file" name="upfile">
  <input id="button" type="submit" value="Upload">
</form>
```
Now, we just have to get this into a page that [Rails](https://rubyonrails.org/) will generate and serve for us.  Thankfully, the [Getting Started with Rails](https://guides.rubyonrails.org/getting_started.html) guide shows all the steps we need to serve a page, so following those steps, just drop the above form code into `app/views/file_metadata/index.html.erb`, add the empty `index` method to the controller, and add the root route pointed at `file_metadata#index`.  Run the tests, and the first three should pass.

Finally, we need to calculate the size and get the file type.  [Ruby](https://www.ruby-lang.org/) has a host of `File` methods, one of which is `File.size`, which we can call on the uploaded file.  Just like in [NodeJS](https://nodejs.org/), there is a [Ruby](https://www.ruby-lang.org/) gem to solve our type problem.  Simply add  `mimemagic` through the [repl.it](https://repl.it/) packager (or the traditional way if you are not using [repl.it](https://repl.it/)), and use it to get the MIME type.  Lastly, to get the name, you may try to find it in `params` since it looks like it should be uploaded from the [specifications](https://www.freecodecamp.org/learn/apis-and-microservices/apis-and-microservices-projects/file-metadata-microservice).  If you `puts params` in your controller and run the tests, you will see something like:
```
  Parameters: {"upfile"=>#<ActionDispatch::Http::UploadedFile:0x00007f358c8fd2e8 @tempfile=#<Tempfile:/home/runner/ror-fcc-amp/RackMultipart20210806-103-7sftzp>, @original_filename="icon", @content_type="image/png", @headers="Content-Disposition: form-data; name=\"upfile\"; filename=\"icon\"\r\nContent-Type: image/png\r\n">}
```
which shows that the file name should be accessible as `params[:upfile].original_filename`.  Putting all this together gives the final method:
```
  def info
    name = params[:upfile].original_filename
    type = MimeMagic.by_magic(File.open(params[:upfile])).type
    size = params[:upfile].size
    render json: { "name": name, "type": type, "size": size }
  end
```
which is almost as easy as
[Multer](https://github.com/expressjs/multer).  Rerun the tests, and
all pass.  Not to bad.

## Looking Forward

Now that the last project is finished, hopefully you can better appreciate the similarities and differences between the [NodeJS](https://nodejs.org/) and [Rails](https://rubyonrails.org/) approaches.  You've also got a good model now of how to run a [Rails](https://rubyonrails.org/) site that serves dynamic pages and an API which might interact with another app or frontend.  Hopefully you also have some insight into how testing will help with your [NodeJS](https://nodejs.org/) projects like they do with [Rails](https://rubyonrails.org/).

Since we've shown that the framework doesn't matter when it comes to testing an API implementation from the outside, now we have an answer to all the questions about "Can I do this in Framework X?" and it is yes.  So, if you want more practice, repeat the projects in [Flask](https://flask.palletsprojects.com/), or [Django](https://www.djangoproject.com/), or [Rocket](https://rocket.rs/).  Before we ponder the future, let's commit, push, and [carry on](conclusion.md).
