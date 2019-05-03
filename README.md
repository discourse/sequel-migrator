This teeny-tiny container has a single, very simple, purpose: to run [Sequel
migrations](http://sequel.jeremyevans.net/rdoc/files/doc/migration_rdoc.html)
against a database every time the container is started.  Once the migrations
have run, the container will either terminate, or sits completely silent and
inactive.


# Usage

There are a couple of environment variables that this container needs in order
to work properly:

* **`MIGRATIONS_DIR`**: The directory where all your migration directories are
  available, within the container's filesystem.  You presumably will want to
  mount a volume on this directory, to make the migration files available.  See
  [Migration Directories](#migration-directories) for all the details of how
  the contents of this directory should be laid out.

* **`SEQUEL_DATABASE_URL`**: provides connection details of the database
  against which all migrations will be run.  Note that you're responsible for
  creating this database before running the migrations, unless the database
  adapter does it automatically (as, for example, SQLite does).

You can also modify the behaviour of the container with the following
(optional) environment variables:

* **`PAUSE_ON_COMPLETION`**: if this variable is set to any non-empty string,
  the container will call the `pause` command when the migrations are complete,
  rather than exiting.


# Migration Directories

The directory referenced by the `MIGRATIONS_DIR` environment variable is
expected to contain [migration
files](http://sequel.jeremyevans.net/rdoc/files/doc/migration_rdoc.html#label-Migration+files).
Feel free to use whichever of integer or timestamp migration naming as you
wish.


# Example migrations

Below are some migration patterns to help you get started.


## Create a user

You don't usually have to create users in migrations, because often the database
setup does it for you.  Not around here though, buddy!

    Sequel.migration do
      up   { run "CREATE USER fred PASSWORD 'xyzzy'" }
      down { run "DROP USER fred" }
    end

