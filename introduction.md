# Introduction to Ruby with the FreeCodeCamp API and Microservices Projects

FreeCodeCamp's MERN stack curriculum features five projects in the API and Microservices section that introduce backend development with simple but increasingly difficult tasks.  While you can do as much frontend work as you like with these projects, their specifications and tests only concern the backend so the emphasis is on the MongoDB, Express, and Node parts of the stack.

A fairly common question in the FreeCodeCamp forums concerns implementation of these APIs in a framework, commonly Flask or Django (sorry Ruby).  Since the project tests are all basic blackbox API tests, the framework should not matter as long as the responses are correct.  So, let's do the projects in Ruby.  Even better, let's use the repl.it Ruby on Rails template so that we don't have to host or deploy.

## Prerequisites

1. This is not an API tutorial.  You really should have already completed the API and Microservices projects at FreeCodeCamp or have that level of understanding of APIs, JSON, and the usual HTTP verbs.
1. This is not a Ruby tutorial.  Check out any number of other fine Ruby resources on the web.  I like the Ruby Koans.  Ruby is friendly enough that if you already know a language and can search the internet, you should be fine.
1. This is not a Ruby on Rails tutorial.  Just go read the Ruby on Rails guides that we'll be referencing repeatedly.  We'll be letting Rails do most of the work anyway by leveraging Ruby and Rail's "convention over configuration" philosophy.  But if you look at a Rails project directory and squint, it looks like a Node/Express project anyway.
1. You should be familiar with working on projects on repl.it and with git.  Ideally you have a repl.it account and a Github account that you can link so that you can push your project to Github as you work.

## What We'll Learn

1. The main difference between this project and the FreeCodeCamp projects, beside the framework, is testing.  FreeCodeCamp does not introduce testing in its JavaScript projects until later, but we'll be using Ruby's test facilities from the start.
2. We'll use the Ruby on Rails guides, especially the basic build a blog guide, as an example to implement these APIs.  So, you'll learn some Ruby on Rails as we go.
1. We'll also see some of the coding reduction that Ruby on Rails offers over Express and friends and Django.  We'll probably spend more time testing than coding, so welcome to the real world.

## Initial Configuration

Let's get to work and get the project configured so that in the next episode we can implement the first project, a time server.

1. Log on to repl.it, creating an account if necessary, and create a new repl.  Near the end of the project type list, you'll find the Rails template.  Select that one.
1. Once it's loaded, look around and read the readme.  You'll note that we have to bind the app to 0.0.0.0, allow all hosts, and allow the app to be iframed.  Follow the directions in the readme.  This won't work, but it's a good start.
1. Go ahead and run the app.  You should see the normal welcome to Rails splash page.
1. Link your Github account (make one if necessary) to your repl.it account and commit and push your work.

Note that we have some problems already.  The FreeCodeCamp won't work as yet, since we don't have a working CORS configuration.  Also, we're using Ruby 2.5, which hit EOL in April 2021.  Unless you're following along on repl.it, run the latest version 3 of Ruby and update those gems.

Now that we have some semblance of a project, it's time to start implementing the FreeCodeCamp projects in earnest, beginning with the time server.