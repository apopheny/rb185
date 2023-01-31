CREATE TABLE expenses(
  id serial PRIMARY KEY,
  amount numeric(6,2) NOT NULL,
  memo text NOT NULL,
  created_on date NOT NULL
  DEFAULT date(now()),
  check (amount > 0)
);