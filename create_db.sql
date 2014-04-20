
drop function if exists notify_trigger() cascade;
drop table items cascade;
drop table users cascade;
drop table likes cascade;
drop table comments cascade;

create table users (id bigserial primary key, 
	username varchar(256) unique not null,
	firstname varchar(256),
	lastname varchar(256),
	twitter varchar(256),
	facebook varchar(256),
	profile_pic bytea,
	url varchar(1024),
	email varchar(1024),
	gravatarid varchar(255)
);
create table items ( 
	id bigserial primary key, 
	who bigserial references users(id), 
	tstart bigint not null, 
	tend bigint, 
	lat numeric(20,17), 
	lon numeric(20,17),
	image bytea,
	video bytea,
	audio bytea,
	data bytea,
	thumbnail bytea,
	prev bigserial references items(id),
	url varchar(4096) not null
);
create table likes (id bigserial primary key, 
	username varchar(256) unique not null, 
	item bigserial not null references items(id)
);
create table comments (id bigserial primary key, 
	username varchar(256) unique not null,
	item bigserial not null references items(id),
	time bigint not null, 
	image bytea,
	body text
);

CREATE FUNCTION notify_trigger() RETURNS trigger AS $$
DECLARE
BEGIN
  PERFORM pg_notify('watchers', TG_TABLE_NAME || ',' || TG_OP || ',' || NEW.id);
  RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER watched_table_trigger AFTER INSERT OR UPDATE OR DELETE ON users FOR EACH ROW EXECUTE PROCEDURE notify_trigger();
CREATE TRIGGER watched_table_trigger AFTER INSERT OR UPDATE OR DELETE ON items FOR EACH ROW EXECUTE PROCEDURE notify_trigger();
CREATE TRIGGER watched_table_trigger AFTER INSERT OR UPDATE OR DELETE ON likes FOR EACH ROW EXECUTE PROCEDURE notify_trigger();
CREATE TRIGGER watched_table_trigger AFTER INSERT OR UPDATE OR DELETE ON comments FOR EACH ROW EXECUTE PROCEDURE notify_trigger();