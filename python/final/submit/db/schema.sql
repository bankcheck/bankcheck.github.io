DROP TABLE IF EXISTS user;

CREATE TABLE user ( 
    userid TEXT PRIMARY KEY, 
    passwd TEXT,
    createDt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    token NUMERIC DEFAULT 1000000, 
    avatar TEXT
);

DROP TABLE IF EXISTS portfolio;

CREATE TABLE portfolio ( 
    userid TEXT, 
    code TEXT,
    qty INTEGER NOT NULL,
    PRIMARY KEY(userid, code)
);

DROP TABLE IF EXISTS trans;

CREATE TABLE trans ( 
    transId INTEGER PRIMARY KEY AUTOINCREMENT, 
    userid TEXT NOT NULL, 
    code TEXT NOT NULL,
    qty INTEGER NOT NULL,
    price   NUMERIC NOT NULL,
    createDt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS crypto;

CREATE TABLE crypto ( 
    code TEXT PRIMARY KEY, 
    crypto_name TEXT, 
    ticker TEXT NOT NULL
);