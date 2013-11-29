commons
=======

Commons server infrastructure for sharing paths in the park

to create the database

install postgres. then log in as the postgres user and create the datapark user;

	psql -U postgres -h localhost
	create role datapark login;
	create role datapark owner datapark;

then create the databases/tables in datapark

	cat create_db.sql | psql -U datapark -h localhost datapark



