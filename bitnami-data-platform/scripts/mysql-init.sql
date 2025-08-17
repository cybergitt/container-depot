-- CREATE TABLE IF NOT EXISTS test (id SERIAL PRIMARY KEY, name VARCHAR(50));

BEGIN;

-- structure setup

CREATE TABLE test (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- data setup

INSERT INTO test (name) 
VALUES ('User 1');

INSERT INTO test (name) 
VALUES ('User 2');

COMMIT;