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
