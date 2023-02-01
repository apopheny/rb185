DROP TABLE IF EXISTS expenses;

CREATE TABLE expenses(
  id serial PRIMARY KEY,
  amount numeric(6,2) NOT NULL,
  memo text NOT NULL,
  created_on date NOT NULL
  DEFAULT date(now()),
  check (amount > 0)
);

INSERT INTO expenses(amount, memo, created_on)
VALUES
(112.38, 'utilities', '2023-01-04'),
(55.36, 'gas', '2023-01-10'),
(19.95, 'vitamins', DEFAULT);