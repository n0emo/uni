CREATE TABLE IF NOT EXISTS Customers (
    id INTEGER NOT NULL PRIMARY KEY,
    name TEXT NOT NULL,
    surname TEXT NOT NULL,
    address TEXT NOT NULL,
    phone TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS BookOrders (
    id INTEGER NOT NULL PRIMARY KEY,
    customerId INTEGER NOT NULL,
    datetime TEXT NOT NULL,
    cost REAL NOT NULL,
    numberOfTurns INTEGER NOT NULL,
    size TEXT NOT NULL,
    materialId INTEGER NOT NULL,
    FOREIGN KEY(customerId) REFERENCES Customers(id),
    FOREIGN KEY(materialId) REFERENCES Materials(id)
);

CREATE TABLE IF NOT EXISTS PaintingOrders (
    id INTEGER NOT NULL PRIMARY KEY,
    customerId INTEGER NOT NULL,
    datetime TEXT NOT NULL,
    cost REAL NOT NULL,
    width INTEGER NOT NULL,
    height INTEGET NOT NULL,
    FOREIGN KEY(customerId) REFERENCES Customers(id)
);

CREATE TABLE IF NOT EXISTS Materials (
    id INTEGER NOT NULL PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    price REAL NOT NULL,
    stock REAL NOT NULL
);

CREATE VIEW MaterialStockView AS
SELECT id, name, stock FROM Materials
ORDER BY stock DESC;
