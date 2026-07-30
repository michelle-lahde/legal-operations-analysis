-- Attorneys table
CREATE TABLE attorneys (
    attorney_id INT PRIMARY KEY,
    attorney_name VARCHAR(100) NOT NULL,
    seniority_level VARCHAR(50),
    hourly_rate DECIMAL(10, 2)
);

-- Matters table
CREATE TABLE matters (
    matter_id INT PRIMARY KEY,
    matter_name VARCHAR(200),
    practice_area VARCHAR(50),
    case_type VARCHAR(100),
    lead_attorney_id INT,
    start_date DATE,
    end_date DATE,
    case_outcome VARCHAR(50),
    budgeted_cost DECIMAL(15, 2),
    settlement_award_amount DECIMAL(15, 2),
    client_name VARCHAR(100),
    FOREIGN KEY (lead_attorney_id) REFERENCES attorneys(attorney_id)
);

-- Billing table
CREATE TABLE billing (
    billing_id INT PRIMARY KEY,
    matter_id INT,
    attorney_id INT,
    billing_date DATE,
    hours_worked DECIMAL(6, 1),
    hourly_rate DECIMAL(10, 2),
    amount DECIMAL(12, 2),
    billable_status VARCHAR(50),
    FOREIGN KEY (matter_id) REFERENCES matters(matter_id),
    FOREIGN KEY (attorney_id) REFERENCES attorneys(attorney_id)
);

-- Expenses table
CREATE TABLE expenses (
    expense_id INT PRIMARY KEY,
    matter_id INT,
    expense_date DATE,
    expense_type VARCHAR(100),
    amount DECIMAL(12, 2),
    vendor VARCHAR(100),
    FOREIGN KEY (matter_id) REFERENCES matters(matter_id)
);