CREATE TABLE IF NOT EXISTS trade_feed_ingest_log (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    account_id BIGINT,
    trade_feed_type VARCHAR(255) NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_location  VARCHAR(255) NOT NULL,
    file_location_technolgoy  VARCHAR(50) NOT NULL DEFAULT 'FileSystem',
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(255) DEFAULT CURRENT_USER,
    updated_by VARCHAR(255) DEFAULT CURRENT_USER
);
