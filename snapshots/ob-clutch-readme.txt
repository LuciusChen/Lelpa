Org-Babel backend for clutch database connections.

Supported block types:
  #+begin_src mysql
  #+begin_src postgresql
  #+begin_src sqlite
  #+begin_src mongodb
  #+begin_src redis

Optional generic block (supports all clutch backends including JDBC):
  #+begin_src clutch :backend pg
  #+begin_src clutch :backend oracle
  #+begin_src clutch :backend sqlserver
  #+begin_src clutch :backend mongodb
  #+begin_src clutch :backend redis

Header arguments:
  :connection                name from `clutch-connection-alist'
  :backend                   mysql|pg|postgresql|sqlite|mongodb|redis|...
  :host :port :user :password :database
  :ssh-host :tramp

JDBC backends (oracle, sqlserver, db2, snowflake, redshift) require
clutch-db-jdbc.el to be loaded and clutch-jdbc-agent.jar to be available.
Use :connection to reference a pre-configured clutch-connection-alist entry,
or supply :host/:port/:user/:database inline.  Port defaults to the JDBC
driver default when omitted.
