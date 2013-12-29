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

Purpose
-------

For now, this app serves as a simple example of using
[Dynflow](https://www.github.com/iNecas/dynflow) and
[Dyntask](https://www.github.com/iNecas/dyntask).

However, it does not mean it can't be extended and improved if anyone
finds it useful enough to do so.

The code can be used as base for your integration projects,
especially when calling external commands or services as part of the
integration (which is almost every time:)

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
