# ChatApp

This is a simple chat API only application built using Ruby on Rails and ActionCable. Users can create chat rooms and chat with other users in real time.

## Features

- Users can create applications and chat rooms
- Users can join chat rooms
- Users can chat with other users in real time
- Users can search for a partial match for a message in a chat room

## Built With

- [rbenv](https://github.com/rbenv/rbenv)
- [Ruby v3.3.0](https://www.ruby-lang.org/en/)
- [Ruby on Rails v7.1.3.2](https://rubyonrails.org/)

## Dependencies

- [MySQL](https://www.mysql.com/)
- [Redis](https://redis.io/)
- [Elasticsearch](https://www.elastic.co/)
- [ActionCable](https://guides.rubyonrails.org/action_cable_overview.html)
- [Sidekiq](https://sidekiq.org/)

## Running the application

In order to run the application, you only need to have Docker and Docker Compose installed on your machine. thats by simply cloning the repository and running the following command:

```bash
docker compose up
```

After the app container is up and running, you need to create the elastic search index by running the following command:

```bash
docker compose exec app bash -c "bin/rails console"
```

and then run the following command inside the rails console:

```ruby
Message.import force: true
```

## Problems faced

### Problem 1: Chat/Message number and Sidekiq isolation (Solved)

When creating the message, I need to specify the message number in the chat room by simply incrementing the last message number by 1. This raises the problem of race conditions when two messages are created at the same time. This problem can be solved in different ways (make  serializable isolation level queries, optimistic locking), but I chose to use Sidekiq queues for some reason, and I was quite wrong to do that XD.

The Problem is that I need to return the message number to the user after creating the message, but the message number is only known after the message is processed by Sidekiq.

The Problem being that Sidekiq runs in isolation, so I can't use the `ActionCable.server.broadcast` method in the worker. I tried all sorts of things to make it work, but I couldn't be able to figure out the right way to do it. So, I gave up on returning the message number to the user after creating the message and just returned the message content.

Before giving up completely on this one and because Sidekiq does not have hooks like the native Action Job I tried implementing the same job in the native Action Job and set up the after_perform hook to broadcast the message number to the chat room. And fortunately, **it worked**, damn you Sidekiq.

### Problem 2: Authentication using Devise and Devise JWT (Solved)

I tried to implement authentication using Devise and Devise JWT but I couldn't be able to make it work. I even found an [issue](https://github.com/heartcombo/devise/issues/5473) on the Devise JWT repository that is exactly the same problem I was facing, but the solution provided didn't work for me.

I tried downgrading the `Devise`, `Devise-Jwt`, and `Rails` gems all without success.

So I only use it inside the `ApplicationCable::Connection` class to authenticate the user.

Caveat: When using the POST /signup route, the user is created but the response is an error message saying that `Your application has sessions disabled. To write to the session you must first configure a session store`. I tried to fix it by adding the `config.session_store :cookie_store, key: '_interslice_session'` line to the `config/initializers/devise.rb` file, but it didn't work.

After documenting the problem, I didn't want to give up on it, and fortunately, I found an [issue](https://github.com/waiting-for-dev/devise-jwt/issues/235#issuecomment-1680376388) that lead me to the solution.

### Problem 3: Dockerize the application (Solved)

I tried to dockerize the application in the development environment, but I couldn't be able to make it work. For some reason, the app contianer does not wait for the db container to be ready before starting the application. And even after the db container is ready, the app container does not connect to the db even though the configurations are right!

When I tried running in the production environment, it worked perfectly. It connected successfully to the db container but the caveat is that now the connection requires an SSL certificate.

After sometime debugging, I was able to make it work in the development environment. And I don't know why it didn't work before, but I'm glad it's working now.
