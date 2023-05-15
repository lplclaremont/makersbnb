DROP TABLE IF EXISTS users, listings, dates, dates_users_join;

CREATE TABLE users(
  id SERIAL PRIMARY KEY,
  name text,
  email text,
  password text
);

CREATE TABLE listings(
  id SERIAL PRIMARY KEY,
  listing_name text,
  listing_description text,
  price int,
  user_id int,
  constraint fk_user foreign key(user_id)
    references users(id) 
    on delete cascade
);

CREATE TABLE dates(
  id SERIAL PRIMARY KEY,
  date date,
  listing_id int,
  constraint fk_listing foreign key(listing_id)
    references listings(id)
    on delete cascade,
  booked_by_user int,
  constraint fk_user foreign key(booked_by_user)
    references users(id)
    on delete set null
);

CREATE TABLE dates_users_join(
  user_id int,
  constraint fk_user foreign key(user_id)
    references users(id)
    on delete cascade,
  dates_id int,
  constraint fk_dates foreign key(dates_id)
    references dates(id)
    on delete cascade
);

TRUNCATE TABLE users, listings, dates, dates_users_join RESTART IDENTITY;

INSERT INTO users(name, email, password) VALUES
('Shrek', 'shrek@swamp.com', '$2a$12$hX0Z4NXcrNZTWfWfKszW/eUFLU.ajoIE1QbAN6SHy/WGuZ5flsMrW'),
('Fiona', 'fiona@farfaraway.com', '$2a$12$iPm6cit/e1/d28nCpbRsHebtWAKTO9pXY68ZlX/8XgNQoOShI4q5S'),
('Donkey', 'donkey@donkey.com', '$2a$12$/VB68Mtdk1i93tQuw5BtaeZRAGdBp2jDubwh4ZngYuKrMYu3kobh.');

INSERT INTO listings(listing_name, listing_description, price, user_id) VALUES
('Swamp', 'Lovely swamp. Shrek lives here. Scenic outhouse. Donkey not included!', '69', '1'),
('Far Far Away Castle', 'Big castle. Very far away.', '420', '2');

INSERT INTO dates(date, listing_id) VALUES
('2023-05-12', '1'),
('2023-05-13', '1'),
('2023-05-12', '2');

INSERT INTO dates_users_join(user_id, dates_id) VALUES
('3', '1'),
('2', '1'),
('3', '2');
