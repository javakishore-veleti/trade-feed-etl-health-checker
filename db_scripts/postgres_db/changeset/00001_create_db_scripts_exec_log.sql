CREATE TABLE IF NOT EXISTS db_scripts_exec_log (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    file_name VARCHAR(255) UNIQUE NOT NULL,
    file_size BIGINT NOT NULL,
    file_created_dt TIMESTAMP NOT NULL,
    md5_value VARCHAR(32) GENERATED ALWAYS AS (md5(file_name || file_size::text || file_created_dt::text)) STORED,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(255) DEFAULT CURRENT_USER,
    updated_by VARCHAR(255) DEFAULT CURRENT_USER
);
