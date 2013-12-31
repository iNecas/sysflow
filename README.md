Sysflow
=======

App using Dynflow for parallel execution of external commands and tracking
the status.

Installation
------------

```bash
cp config/database.yml{.example,}
bundle install
rake db:migrate
bundle exec rails s
```

Usage
-----

Go to `http://localhost:3000`, fill in commands to run (each line will be run
in parallel) and hit "Run". The task detail will be shown with the
current status of the commands. You can keep the pages refreshing to
see current status.

Reusing in another apps
-----------------------

The actions and services defined in Sysflow can be used in other apps
that run [Dynflow](https://www.github.com/iNecas/dynflow) on backend.
All one needs is to add the dependency into Gemfile:

```ruby
gem 'sysflow', git: 'git@github.com:iNecas/sysflow.git'
```

and run the following code in the initialization phase of the application
(perhaps in `config/initializers/sysflow.rb`):

```ruby
Sysflow.dynflow_load
```

If [Dyntask](https://www.github.com/iNecas/dyntask) is present, it
adds the actions to eager load paths, so that code reloading works
in development mode as well, by calling:

```ruby
Sysflow.dynflow_load(true)
```

Purpose
-------

For now, this app serves as a simple example of using
[Dynflow](https://www.github.com/iNecas/dynflow) and
[Dyntask](https://www.github.com/iNecas/dyntask).

The Dynflow actions and connectors can also be used in another
apps that run Dynflow on backend.

TODO
----

 * Polling for the updates

 * Updating the status though web sockets (with fallback to polling)


License
-------

MIT

Author
------

Ivan Nečas
