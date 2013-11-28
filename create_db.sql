create role datapark login;
create database datapark owner datapark;
create table users (id bigserial primary key, username varchar(256) unique not null);
create table commons ( id bigserial primary key, who varchar(255) references users(username), tstart timestamp, tend timestamp, uri varchar(4096) );
