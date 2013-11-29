drop table commons;
drop table users;
create table users (id bigserial primary key, username varchar(256) unique not null);
create table commons ( id bigserial primary key, who varchar(255) references users(username), tstart bigint not null, tend bigint, url varchar(4096) not null);