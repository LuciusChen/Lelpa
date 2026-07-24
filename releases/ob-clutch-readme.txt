Org-Babel backend for MySQL/PostgreSQL/SQLite/JDBC databases via clutch-db.

Supported block types:
  #+begin_src mysql
  #+begin_src postgresql
  #+begin_src sqlite

Optional generic block (supports all backends including JDBC):
  #+begin_src clutch :backend pg
  #+begin_src clutch :backend oracle
  #+begin_src clutch :backend sqlserver

Header arguments:
  :connection                name from `clutch-connection-alist'
  :backend                   mysql|pg|postgresql|sqlite|oracle|sqlserver|...
  :host :port :user :password :database

JDBC backends (oracle, sqlserver, db2, snowflake, redshift) require
clutch-db-jdbc.el to be loaded and clutch-jdbc-agent.jar to be available.
Use :connection to reference a pre-configured clutch-connection-alist entry,
or supply :host/:port/:user/:database inline.  Port defaults to the JDBC
driver default when omitted.
