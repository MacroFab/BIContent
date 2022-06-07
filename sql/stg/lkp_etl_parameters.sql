-- lkp_etl_parameters.sql

DROP TABLE IF EXISTS stg.lkp_etl_parameters;

CREATE TABLE IF NOT EXISTS stg.lkp_etl_parameters
(
    etl_name         VARCHAR(50) ENCODE zstd  NOT NULL,
    param_name       VARCHAR(50) ENCODE zstd  NOT NULL,
    param_str_value  VARCHAR(50) ENCODE zstd  NULL,
    param_int_value  INTEGER     ENCODE az64  NULL,
    param_date_value TIMESTAMP   ENCODE az64  NULL,
    active           BOOLEAN     ENCODE zstd  NOT NULL,
    created          TIMESTAMP   ENCODE az64  NOT NULL
)
DISTSTYLE AUTO
SORTKEY AUTO
;

INSERT INTO stg.lkp_etl_parameters VALUES
('mysql_etl_workflow', 'last_execution', NULL, NULL, NULL, TRUE, GETDATE()),
('mysql_etl_workflow', 'min_created', NULL, NULL, '2019-01-01', TRUE, GETDATE()),
('dw_etl_workflow', 'last_execution', NULL, NULL, NULL, TRUE, GETDATE()),
('airtable_etl_workflow', 'last_execution', NULL, NULL, NULL, TRUE, GETDATE()),
('jira_etl_workflow', 'last_execution', NULL, NULL, NULL, TRUE, GETDATE()),
('salesforce_etl_workflow', 'last_execution', NULL, NULL, NULL, TRUE, GETDATE())
;
