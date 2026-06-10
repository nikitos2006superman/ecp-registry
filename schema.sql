-- Схема SQLite-версии БД АИС учёта ЭЦП (демонстрационная)
-- Соответствует SQL-схеме PostgreSQL из Приложения 1 диплома

CREATE TABLE departments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    short_name TEXT,
    head_id INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE employees (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    middle_name TEXT,
    snils TEXT UNIQUE,
    inn TEXT,
    position TEXT NOT NULL,
    department_id INTEGER REFERENCES departments(id),
    email TEXT,
    phone TEXT,
    is_active INTEGER DEFAULT 1,
    hired_at DATE,
    dismissed_at DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE certification_authorities (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    ogrn TEXT,
    is_accredited INTEGER DEFAULT 1,
    accreditation_date DATE,
    contacts TEXT
);

CREATE TABLE tokens (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    serial_number TEXT NOT NULL UNIQUE,
    token_type TEXT NOT NULL,
    model TEXT,
    purchase_date DATE,
    status TEXT DEFAULT 'in_storage',
    current_holder_id INTEGER REFERENCES employees(id),
    notes TEXT
);

CREATE TABLE certificates (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    serial_number TEXT NOT NULL UNIQUE,
    signature_type TEXT NOT NULL,
    owner_id INTEGER NOT NULL REFERENCES employees(id),
    ca_id INTEGER REFERENCES certification_authorities(id),
    token_id INTEGER REFERENCES tokens(id),
    issued_at DATE NOT NULL,
    valid_from DATE NOT NULL,
    valid_until DATE NOT NULL,
    status TEXT DEFAULT 'active',
    purpose TEXT,
    revocation_date DATE,
    revocation_reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE powers_of_attorney (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    poa_number TEXT NOT NULL UNIQUE,
    principal_certificate_id INTEGER REFERENCES certificates(id),
    representative_id INTEGER NOT NULL REFERENCES employees(id),
    representative_certificate_id INTEGER REFERENCES certificates(id),
    powers_description TEXT NOT NULL,
    powers_codes TEXT,
    issued_at DATE NOT NULL,
    valid_from DATE NOT NULL,
    valid_until DATE NOT NULL,
    status TEXT DEFAULT 'active',
    revocation_date DATE,
    fns_registered INTEGER DEFAULT 0,
    xml_file_path TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE token_transactions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    token_id INTEGER NOT NULL REFERENCES tokens(id),
    employee_id INTEGER REFERENCES employees(id),
    transaction_type TEXT NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    act_number TEXT,
    operator_id INTEGER REFERENCES employees(id),
    notes TEXT
);

CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    employee_id INTEGER UNIQUE REFERENCES employees(id),
    role TEXT NOT NULL DEFAULT 'employee',
    is_active INTEGER DEFAULT 1,
    last_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE audit_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER REFERENCES users(id),
    action TEXT NOT NULL,
    entity_type TEXT NOT NULL,
    entity_id INTEGER,
    details TEXT,
    ip_address TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_certs_owner ON certificates(owner_id);
CREATE INDEX idx_certs_valid_until ON certificates(valid_until);
CREATE INDEX idx_certs_status ON certificates(status);
CREATE INDEX idx_poa_representative ON powers_of_attorney(representative_id);
CREATE INDEX idx_audit_timestamp ON audit_log(timestamp);
