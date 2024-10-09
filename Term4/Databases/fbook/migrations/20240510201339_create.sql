CREATE TABLE IF NOT EXISTS customers (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    surname TEXT NOT NULL,
    address TEXT NOT NULL,
    phone TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS materials (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    price REAL NOT NULL,
    stock REAL NOT NULL
);

CREATE TABLE IF NOT EXISTS sizes (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS book_orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    datetime TIMESTAMP NOT NULL,
    cost REAL NOT NULL,
    number_of_turns INTEGER NOT NULL,
    size_id INTEGER NOT NULL,
    material_id INTEGER NOT NULL,
    FOREIGN KEY(customer_id) REFERENCES customers(id),
    FOREIGN KEY(material_id) REFERENCES materials(id),
    FOREIGN KEY(size_id) REFERENCES sizes(id)
);

CREATE TABLE IF NOT EXISTS painting_orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    datetime TIMESTAMP NOT NULL,
    cost REAL NOT NULL,
    width INTEGER NOT NULL,
    height INTEGER NOT NULL,
    FOREIGN KEY(customer_id) REFERENCES customers(id)
);
