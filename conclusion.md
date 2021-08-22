# Conclusion

## Which Framework?

This choice has to be guided by the languages you use and how much of
the code you to implement.  [Django](https://www.djangoproject.com/)
and [Rails](https://rubyonrails.org/) do much of the work of a dynamic
site for you, as long as you are willing to do it their way.
[NodeJS](https://nodejs.org/) gives you nearly infinite choices as
long as you can implement the code to tie everything together.  You
can also try other frameworks like
[Flask](https://flask.palletsprojects.com/) or
[Rocket](https://rocket.rs/), that like [NodeJS](https://nodejs.org/),
leave most of the choices to you.

Also, don't fall into the trap of thinking that
[Django](https://www.djangoproject.com/) or
[Rails](https://rubyonrails.org/) will free you from front end
JavaScript.  They both do a great job of producing dynamic content,
but it's hard to avoid the UI complexity that eventually leads to
[Vue](https://vuejs.org/), [React](https://reactjs.org/),
[JQuery](https://jquery.com/), or the like.

Pay attention to the commonalities and web development is much easier.
Get familiar with the HTTP verbs and their usages, basic URL routing,
HTTP statuses, and returning data.  This is all common across all
frameworks.  Get familiar with your framework's testing methodology
and test everything.  Aim for complete coverage.  If your code does
something, test that it does that something correctly.
[Django](https://www.djangoproject.com/) and
[Rails](https://rubyonrails.org/) both have excellent integrated
testing suites (and a few alternatives).
[NodeJS](https://nodejs.org/) has an abundance of options for back end
and front end code.

## Where Now?

Go forth and build something.

At some point, you have to stop following tutorials and build
something your way.  That point is much earlier than you feel
comfortable doing it.  Tutorials are only useful up to the "hello,
world" stage because once you can input, process, and output
information, you need to start build things yourself.  Keep the
references handy and by all means ransack tutorials for useful
information, but don't do the copy/paste tutorial method that leads
straight to tutorial hell.  And don't buy the "type it and you'll
remember it" hogwash either.  You have to learn the how and then go
do.

It doesn't have to be original, it just has to be yours.  Don't worry
about the "don't reinvent the wheel" adage people like to spout
online.  Build a blog.  Everyone knows what a blog is.  Everyone knows
how they work from the outside.  Everyone always asks, "Why build your
own blog when you can just use FancyBlog 3.1.4?"  Because everyone
that ever built anything started building something that was too easy
for any expert to build.  Everyone's first program was their
generation's equivalent of the blog, so don't let them lie about it.

Why a blog?  Everyone knows what they are.  They have articles.
Implement that.  They have multiple authors.  Implement that.  They
can have comments.  Implement that.  They can have multiple users.
Implement users.  Separate the authors and the readers.  Implement
authentication.  They have readers who are not nice.  Implement
controls for not nice users.  Customize your articles to have
categories or images or code or even markdown.  Customize your users
to have detailed profiles or achievements.  Pick and choose what you
want and feel free to ransack tutorials and the internet for help.
Test everything as you go.  Once it's working, get it hosted and you
can join the countless people on the web with unread blogs, but at
least you won't be on Medium.  Once you finish, you'll have a working,
completely tested, self hosted, site that you built.

Why not something else?  Change the articles to products and comments
to reviews, add some business logic, and you have a storefront.  Rip
off the front end, generalize the back end, add some useful
information, and you have an API.  It's "hello, world" all over again.

So, go forth and build.
