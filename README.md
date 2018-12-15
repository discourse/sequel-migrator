This teeny-tiny container has a single, very simple, purpose: to run [Sequel
migrations](http://sequel.jeremyevans.net/rdoc/files/doc/migration_rdoc.html)
against a database every time the container is started.  Once the migrations
have run, the container is completely silent and inactive until the next time
it is started, when it'll run whatever migrations are in the migrations dir at
that time.


# Usage

There are a number of things that this container needs in order to work properly:

* `MIGRATIONS_DIR` environment variable (and associated volume): The directory
   where all your migration directories are available, within the container's
   filesystem.  See [Migration Directories](#migration-directories) for all the
   details of how the contents of this directory should be laid out.

* `SEQUEL_DATABASE_URL` environment variable: the database against which all
   migrations will be run.  Note that you're responsible for creating this
   database before running the migrations, unless the database adapter does
   it automatically (as, for example, SQLite does).

* `RUN_UID` environment variable: specify the *numeric* UID to run the migrations
   as.  This is important for some database engines, either because they use
   files on disk (*a la* sqlite) or because you can use peer authentication (as
   Postgres allows).  If not specified, the migrations will be run as an
   unspecified non-privileged user.


# Migration Directories

The directory referenced by the `MIGRATIONS_DIR` environment variable is
expected to contain [migration
files](http://sequel.jeremyevans.net/rdoc/files/doc/migration_rdoc.html#label-Migration+files).
Feel free to use whichever of integer or timestamp migration naming as you
wish.

Note that the migration files must be readable by the UID specified in the
`RUN_UID` environment variable, as that is the user the migrations are
run as.


# Example migrations

Below are some migration patterns to help you get started.


## Create a user

You don't usually have to create users in migrations, because often the database
setup does it for you.  Not around here though, buddy!

    Sequel.migration do
      up   { run "CREATE USER fred PASSWORD 'xyzzy'" }
      down { run "DROP USER fred" }
    end

