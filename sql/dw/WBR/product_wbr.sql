DROP TABLE IF EXISTS dw.fct_product_wbr;

CREATE TABLE dw.fct_product_wbr
(
    frequency         VARCHAR(7)    ENCODE zstd,
    activity_date     DATE          ENCODE az64,
    category          VARCHAR(25)   ENCODE zstd,
    metric_order      SMALLINT      ENCODE az64,
    metric            VARCHAR(80)   ENCODE zstd,
    actual            NUMERIC(6,3)  ENCODE az64,
    target            NUMERIC(6,3)  ENCODE az64
)
DISTSTYLE AUTO
SORTKEY AUTO
;

-- Sample to load weekly data
TRUNCATE TABLE dw.fct_product_wbr;

INSERT INTO dw.fct_product_wbr VALUES
('weekly', '2022-04-18', 'Product', 1, 'Internal Tools - CES Composite Score [C]', 6.74, NULL),
('weekly', '2022-04-25', 'Product', 1, 'Internal Tools - CES Composite Score [C]', 6.17, NULL),
('weekly', '2022-05-02', 'Product', 1, 'Internal Tools - CES Composite Score [C]', 6.19, NULL),
('weekly', '2022-05-09', 'Product', 1, 'Internal Tools - CES Composite Score [C]', 5.58, NULL),
('weekly', '2022-05-16', 'Product', 1, 'Internal Tools - CES Composite Score [C]', 5.12, NULL),
('weekly', '2022-05-23', 'Product', 1, 'Internal Tools - CES Composite Score [C]', 3.89, NULL),
('weekly', '2022-05-30', 'Product', 1, 'Internal Tools - CES Composite Score [C]', 6.77, NULL),
('weekly', '2022-04-18', 'Product', 2, 'OEM - Signups (Organic)', 54, NULL),
('weekly', '2022-04-25', 'Product', 2, 'OEM - Signups (Organic)', 56, NULL),
('weekly', '2022-05-02', 'Product', 2, 'OEM - Signups (Organic)', 66, NULL),
('weekly', '2022-05-09', 'Product', 2, 'OEM - Signups (Organic)', 39, NULL),
('weekly', '2022-05-16', 'Product', 2, 'OEM - Signups (Organic)', 40, NULL),
('weekly', '2022-05-23', 'Product', 2, 'OEM - Signups (Organic)', 34, NULL),
('weekly', '2022-05-30', 'Product', 2, 'OEM - Signups (Organic)', 32, NULL),
('weekly', '2022-04-18', 'Product', 3, 'OEM - Signups (Invited)', 7, NULL),
('weekly', '2022-04-25', 'Product', 3, 'OEM - Signups (Invited)', 12, NULL),
('weekly', '2022-05-02', 'Product', 3, 'OEM - Signups (Invited)', 5, NULL),
('weekly', '2022-05-09', 'Product', 3, 'OEM - Signups (Invited)', 8, NULL),
('weekly', '2022-05-16', 'Product', 3, 'OEM - Signups (Invited)', 10, NULL),
('weekly', '2022-05-23', 'Product', 3, 'OEM - Signups (Invited)', 8, NULL),
('weekly', '2022-05-30', 'Product', 3, 'OEM - Signups (Invited)', 8, NULL),
('weekly', '2022-04-18', 'Product', 4, 'OEM - Signup to Customer 30 Day Conversion Rate', 0, NULL),
('weekly', '2022-04-25', 'Product', 4, 'OEM - Signup to Customer 30 Day Conversion Rate', 0.05, NULL),
('weekly', '2022-05-02', 'Product', 4, 'OEM - Signup to Customer 30 Day Conversion Rate', 0.02, NULL),
('weekly', '2022-05-09', 'Product', 4, 'OEM - Signup to Customer 30 Day Conversion Rate', 0.02, NULL),
('weekly', '2022-05-16', 'Product', 4, 'OEM - Signup to Customer 30 Day Conversion Rate', 0, NULL),
('weekly', '2022-05-23', 'Product', 4, 'OEM - Signup to Customer 30 Day Conversion Rate', 0.03, NULL),
('weekly', '2022-05-30', 'Product', 4, 'OEM - Signup to Customer 30 Day Conversion Rate', 0.02, NULL),
('weekly', '2022-04-18', 'Product', 5, 'OEM - Altimade # net new customers', 0, NULL),
('weekly', '2022-04-25', 'Product', 5, 'OEM - Altimade # net new customers', 1, NULL),
('weekly', '2022-05-02', 'Product', 5, 'OEM - Altimade # net new customers', 0, NULL),
('weekly', '2022-05-09', 'Product', 5, 'OEM - Altimade # net new customers', 1, NULL),
('weekly', '2022-05-16', 'Product', 5, 'OEM - Altimade # net new customers', 0, NULL),
('weekly', '2022-05-23', 'Product', 5, 'OEM - Altimade # net new customers', 0, NULL),
('weekly', '2022-05-30', 'Product', 5, 'OEM - Altimade # net new customers', 0, NULL),
('weekly', '2022-04-18', 'Product', 6, 'OEM - Altimade net new customers', 3, NULL),
('weekly', '2022-04-25', 'Product', 6, 'OEM - Altimade net new customers', 4, NULL),
('weekly', '2022-05-02', 'Product', 6, 'OEM - Altimade net new customers', 4, NULL),
('weekly', '2022-05-09', 'Product', 6, 'OEM - Altimade net new customers', 5, NULL),
('weekly', '2022-05-16', 'Product', 6, 'OEM - Altimade net new customers', 5, NULL),
('weekly', '2022-05-23', 'Product', 6, 'OEM - Altimade net new customers', 6, NULL),
('weekly', '2022-05-30', 'Product', 6, 'OEM - Altimade net new customers', 6, NULL),
('weekly', '2022-04-18', 'Product', 7, 'OEM - CES Composite Score', 6, NULL),
('weekly', '2022-04-25', 'Product', 7, 'OEM - CES Composite Score', 2.67, NULL),
('weekly', '2022-05-02', 'Product', 7, 'OEM - CES Composite Score', 5.71, NULL),
('weekly', '2022-05-09', 'Product', 7, 'OEM - CES Composite Score', 5.3, NULL),
('weekly', '2022-05-16', 'Product', 7, 'OEM - CES Composite Score', 4.5, NULL),
('weekly', '2022-05-23', 'Product', 7, 'OEM - CES Composite Score', 5.85, NULL),
('weekly', '2022-05-30', 'Product', 7, 'OEM - CES Composite Score', 5.6, NULL),
('monthly', '2022-03-01', 'Product', 1, 'Internal Tools - CES Composite Score [C]', 5.54, 6),
('monthly', '2022-04-01', 'Product', 1, 'Internal Tools - CES Composite Score [C]', 5.62, 6),
('monthly', '2022-05-01', 'Product', 1, 'Internal Tools - CES Composite Score [C]', 5.28, 6),
('monthly', '2022-03-01', 'Product', 2, 'OEM - Signups (Organic)', 269, 269),
('monthly', '2022-04-01', 'Product', 2, 'OEM - Signups (Organic)', 220, 269),
('monthly', '2022-05-01', 'Product', 2, 'OEM - Signups (Organic)', 212, 269),
('monthly', '2022-03-01', 'Product', 3, 'OEM - Signups (Invited)', 32, 41),
('monthly', '2022-04-01', 'Product', 3, 'OEM - Signups (Invited)', 42, 41),
('monthly', '2022-05-01', 'Product', 3, 'OEM - Signups (Invited)', 35, 41),
('monthly', '2022-03-01', 'Product', 4, 'OEM - Signup to Customer 30 Day Conversion Rate*', 0.03, 0.05),
('monthly', '2022-04-01', 'Product', 4, 'OEM - Signup to Customer 30 Day Conversion Rate*', 0.03, 0.05),
('monthly', '2022-05-01', 'Product', 4, 'OEM - Signup to Customer 30 Day Conversion Rate*', 0.02, 0.05),
('monthly', '2022-03-01', 'Product', 5, 'OEM - Altimade # net new customers', 1, 9),
('monthly', '2022-04-01', 'Product', 5, 'OEM - Altimade # net new customers', 2, 9),
('monthly', '2022-05-01', 'Product', 5, 'OEM - Altimade # net new customers', 2, 9),
('monthly', '2022-03-01', 'Product', 6, 'OEM - Altimade net new customers', 2, 100),
('monthly', '2022-04-01', 'Product', 6, 'OEM - Altimade net new customers', 4, 100),
('monthly', '2022-05-01', 'Product', 6, 'OEM - Altimade net new customers', 6, 100),
('monthly', '2022-03-01', 'Product', 7, 'OEM - CES Composite Score', 5.75, 6),
('monthly', '2022-04-01', 'Product', 7, 'OEM - CES Composite Score', 5, 6),
('monthly', '2022-05-01', 'Product', 7, 'OEM - CES Composite Score', 5.80, 6),

('weekly', '2022-04-18', 'Development', 1, '% Releases on target [C]', 0, NULL),
('weekly', '2022-04-25', 'Development', 1, '% Releases on target [C]', 0, NULL),
('weekly', '2022-05-02', 'Development', 1, '% Releases on target [C]', 0, NULL),
('weekly', '2022-05-09', 'Development', 1, '% Releases on target [C]', 0, NULL),
('weekly', '2022-05-16', 'Development', 1, '% Releases on target [C]', 0, NULL),
('weekly', '2022-05-23', 'Development', 1, '% Releases on target [C]', 0, NULL),
('weekly', '2022-05-30', 'Development', 1, '% Releases on target [C]', 0, NULL),
('weekly', '2022-04-18', 'Development', 2, '# New capabilities released', 2, NULL),
('weekly', '2022-04-25', 'Development', 2, '# New capabilities released', 3, NULL),
('weekly', '2022-05-02', 'Development', 2, '# New capabilities released', 0, NULL),
('weekly', '2022-05-09', 'Development', 2, '# New capabilities released', 2, NULL),
('weekly', '2022-05-16', 'Development', 2, '# New capabilities released', 1, NULL),
('weekly', '2022-05-23', 'Development', 2, '# New capabilities released', 4, NULL),
('weekly', '2022-05-30', 'Development', 2, '# New capabilities released', 0, NULL),
('weekly', '2022-04-18', 'Development', 3, 'Platform Uptime', 0.9927, NULL),
('weekly', '2022-04-25', 'Development', 3, 'Platform Uptime', 0.8376, NULL),
('weekly', '2022-05-02', 'Development', 3, 'Platform Uptime', 1, NULL),
('weekly', '2022-05-09', 'Development', 3, 'Platform Uptime', 1, NULL),
('weekly', '2022-05-16', 'Development', 3, 'Platform Uptime', 0.9938, NULL),
('weekly', '2022-05-23', 'Development', 3, 'Platform Uptime', 0.9052, NULL),
('weekly', '2022-05-30', 'Development', 3, 'Platform Uptime', 1, NULL),
('weekly', '2022-04-18', 'Development', 4, '# Critical Bugs In Production', 4, NULL),
('weekly', '2022-04-25', 'Development', 4, '# Critical Bugs In Production', 1, NULL),
('weekly', '2022-05-02', 'Development', 4, '# Critical Bugs In Production', 5, NULL),
('weekly', '2022-05-09', 'Development', 4, '# Critical Bugs In Production', 5, NULL),
('weekly', '2022-05-16', 'Development', 4, '# Critical Bugs In Production', 5, NULL),
('weekly', '2022-05-23', 'Development', 4, '# Critical Bugs In Production', 3, NULL),
('weekly', '2022-05-30', 'Development', 4, '# Critical Bugs In Production', 0, NULL),
('weekly', '2022-04-18', 'Development', 5, 'New Tickets Assigned]', 13, NULL),
('weekly', '2022-04-25', 'Development', 5, 'New Tickets Assigned]', 14, NULL),
('weekly', '2022-05-02', 'Development', 5, 'New Tickets Assigned]', 13, NULL),
('weekly', '2022-05-09', 'Development', 5, 'New Tickets Assigned]', 20, NULL),
('weekly', '2022-05-16', 'Development', 5, 'New Tickets Assigned]', 16, NULL),
('weekly', '2022-05-23', 'Development', 5, 'New Tickets Assigned]', 22, NULL),
('weekly', '2022-05-30', 'Development', 5, 'New Tickets Assigned]', 9, NULL),
('weekly', '2022-04-18', 'Development', 6, 'New Internal Support Tickets Open', 14, NULL),
('weekly', '2022-04-25', 'Development', 6, 'New Internal Support Tickets Open', 18, NULL),
('weekly', '2022-05-02', 'Development', 6, 'New Internal Support Tickets Open', 14, NULL),
('weekly', '2022-05-09', 'Development', 6, 'New Internal Support Tickets Open', 23, NULL),
('weekly', '2022-05-16', 'Development', 6, 'New Internal Support Tickets Open', 17, NULL),
('weekly', '2022-05-23', 'Development', 6, 'New Internal Support Tickets Open', 34, NULL),
('weekly', '2022-05-30', 'Development', 6, 'New Internal Support Tickets Open', 11, NULL),
('monthly', '2022-03-01', 'Development', 1, '% Releases on target [C]', 0, 0),
('monthly', '2022-04-01', 'Development', 1, '% Releases on target [C]', 0, 0),
('monthly', '2022-05-01', 'Development', 1, '% Releases on target [C]', 0, 0.63),
('monthly', '2022-03-01', 'Development', 2, '# New capabilities released', 16, 24),
('monthly', '2022-04-01', 'Development', 2, '# New capabilities released', 11, 24),
('monthly', '2022-05-01', 'Development', 2, '# New capabilities released', 7, 24),
('monthly', '2022-03-01', 'Development', 3, 'Platform Uptime', 0.9947, 0.9999),
('monthly', '2022-04-01', 'Development', 3, 'Platform Uptime', 0.9191, 0.9999),
('monthly', '2022-05-01', 'Development', 3, 'Platform Uptime', 0.9772, 0.9999),
('monthly', '2022-03-01', 'Development', 4, '# Critical Bugs In Production', 29, 15),
('monthly', '2022-04-01', 'Development', 4, '# Critical Bugs In Production', 14, 15),
('monthly', '2022-05-01', 'Development', 4, '# Critical Bugs In Production', 18, 15),
('monthly', '2022-03-01', 'Development', 5, 'New Tickets Assigned', 98, 66),
('monthly', '2022-04-01', 'Development', 5, 'New Tickets Assigned', 71, 66),
('monthly', '2022-05-01', 'Development', 5, 'New Tickets Assigned', 74, 66),
('monthly', '2022-03-01', 'Development', 6, 'New Internal Support Tickets Open', 112, 132),
('monthly', '2022-04-01', 'Development', 6, 'New Internal Support Tickets Open', 85, 132),
('monthly', '2022-05-01', 'Development', 6, 'New Internal Support Tickets Open', 91, 132),

('weekly', '2022-04-18', 'Customer Care', 1, 'NPS', 100, NULL),
('weekly', '2022-04-25', 'Customer Care', 1, 'NPS', 60, NULL),
('weekly', '2022-05-02', 'Customer Care', 1, 'NPS', 60, NULL),
('weekly', '2022-05-09', 'Customer Care', 1, 'NPS', 70, NULL),
('weekly', '2022-05-16', 'Customer Care', 1, 'NPS', 62, NULL),
('weekly', '2022-05-23', 'Customer Care', 1, 'NPS', 62, NULL),
('weekly', '2022-05-30', 'Customer Care', 1, 'NPS', 64, NULL),
('weekly', '2022-04-18', 'Customer Care', 2, 'CES - Support', 6.5, NULL),
('weekly', '2022-04-25', 'Customer Care', 2, 'CES - Support', 6.4, NULL),
('weekly', '2022-05-02', 'Customer Care', 2, 'CES - Support', 6.5, NULL),
('weekly', '2022-05-09', 'Customer Care', 2, 'CES - Support', 6.5, NULL),
('weekly', '2022-05-16', 'Customer Care', 2, 'CES - Support', 6.5, NULL),
('weekly', '2022-05-23', 'Customer Care', 2, 'CES - Support', 6.5, NULL),
('weekly', '2022-05-30', 'Customer Care', 2, 'CES - Support', 6.7, NULL),
('weekly', '2022-04-18', 'Customer Care', 3, 'File Upload Follow Up % On Time (within 24 of Receipt)', 0, NULL),
('weekly', '2022-04-25', 'Customer Care', 3, 'File Upload Follow Up % On Time (within 24 of Receipt)', 0, NULL),
('weekly', '2022-05-02', 'Customer Care', 3, 'File Upload Follow Up % On Time (within 24 of Receipt)', 0, NULL),
('weekly', '2022-05-09', 'Customer Care', 3, 'File Upload Follow Up % On Time (within 24 of Receipt)', 0, NULL),
('weekly', '2022-05-16', 'Customer Care', 3, 'File Upload Follow Up % On Time (within 24 of Receipt)', 75, NULL),
('weekly', '2022-05-23', 'Customer Care', 3, 'File Upload Follow Up % On Time (within 24 of Receipt)', 100, NULL),
('weekly', '2022-05-30', 'Customer Care', 3, 'File Upload Follow Up % On Time (within 24 of Receipt)', 100, NULL),
('weekly', '2022-04-18', 'Customer Care', 4, 'CSAT', 100, NULL),
('weekly', '2022-04-25', 'Customer Care', 4, 'CSAT', 100, NULL),
('weekly', '2022-05-02', 'Customer Care', 4, 'CSAT', 100, NULL),
('weekly', '2022-05-09', 'Customer Care', 4, 'CSAT', 100, NULL),
('weekly', '2022-05-16', 'Customer Care', 4, 'CSAT', 100, NULL),
('weekly', '2022-05-23', 'Customer Care', 4, 'CSAT', 100, NULL),
('weekly', '2022-05-30', 'Customer Care', 4, 'CSAT', 87.5, NULL),
('monthly', '2022-03-01', 'Customer Care', 1, 'NPS', 63, 72),
('monthly', '2022-04-01', 'Customer Care', 1, 'NPS', 50, 72),
('monthly', '2022-05-01', 'Customer Care', 1, 'NPS', 62, 72),
('monthly', '2022-03-01', 'Customer Care', 2, 'CES - Support', 6.5, 6),
('monthly', '2022-04-01', 'Customer Care', 2, 'CES - Support', 6.5, 6),
('monthly', '2022-05-01', 'Customer Care', 2, 'CES - Support', 6.55, 6),
('monthly', '2022-03-01', 'Customer Care', 3, 'File Upload Follow Up % On Time (within 24 of Receipt)', 0, 95),
('monthly', '2022-04-01', 'Customer Care', 3, 'File Upload Follow Up % On Time (within 24 of Receipt)', 55, 95),
('monthly', '2022-05-01', 'Customer Care', 3, 'File Upload Follow Up % On Time (within 24 of Receipt)', 100, 95),
('monthly', '2022-03-01', 'Customer Care', 4, 'CSAT', 100, 95),
('monthly', '2022-04-01', 'Customer Care', 4, 'CSAT', 100, 95),
('monthly', '2022-05-01', 'Customer Care', 4, 'CSAT', 100, 95),

('weekly', '2022-04-18', 'Business Intelligence', 1, '% Depts with Reporting Enabled', 0.47, NULL),
('weekly', '2022-04-25', 'Business Intelligence', 1, '% Depts with Reporting Enabled', 0.53, NULL),
('weekly', '2022-05-02', 'Business Intelligence', 1, '% Depts with Reporting Enabled', 0.59, NULL),
('weekly', '2022-05-09', 'Business Intelligence', 1, '% Depts with Reporting Enabled', 0.75, NULL),
('weekly', '2022-05-16', 'Business Intelligence', 1, '% Depts with Reporting Enabled', 0.75, NULL),
('weekly', '2022-05-23', 'Business Intelligence', 1, '% Depts with Reporting Enabled', 0.75, NULL),
('weekly', '2022-05-30', 'Business Intelligence', 1, '% Depts with Reporting Enabled', 0.75, NULL),
('weekly', '2022-04-18', 'Business Intelligence', 2, '% Crit metric Dash Coverage', 0.03, NULL),
('weekly', '2022-04-25', 'Business Intelligence', 2, '% Crit metric Dash Coverage', 0.04, NULL),
('weekly', '2022-05-02', 'Business Intelligence', 2, '% Crit metric Dash Coverage', 0.05, NULL),
('weekly', '2022-05-09', 'Business Intelligence', 2, '% Crit metric Dash Coverage', 0.05, NULL),
('weekly', '2022-05-16', 'Business Intelligence', 2, '% Crit metric Dash Coverage', 0.05, NULL),
('weekly', '2022-05-23', 'Business Intelligence', 2, '% Crit metric Dash Coverage', 0.07, NULL),
('weekly', '2022-05-30', 'Business Intelligence', 2, '% Crit metric Dash Coverage', 0.08, NULL),
('weekly', '2022-04-18', 'Business Intelligence', 3, '% Depts with Full Jira Enablement', 0, NULL),
('weekly', '2022-04-25', 'Business Intelligence', 3, '% Depts with Full Jira Enablement', 0, NULL),
('weekly', '2022-05-02', 'Business Intelligence', 3, '% Depts with Full Jira Enablement', 0, NULL),
('weekly', '2022-05-09', 'Business Intelligence', 3, '% Depts with Full Jira Enablement', 0, NULL),
('weekly', '2022-05-16', 'Business Intelligence', 3, '% Depts with Full Jira Enablement', 0, NULL),
('weekly', '2022-05-23', 'Business Intelligence', 3, '% Depts with Full Jira Enablement', 0, NULL),
('weekly', '2022-05-30', 'Business Intelligence', 3, '% Depts with Full Jira Enablement', 0, NULL),
('weekly', '2022-04-18', 'Business Intelligence', 4, '% Datasources in BI System', 0.21, NULL),
('weekly', '2022-04-25', 'Business Intelligence', 4, '% Datasources in BI System', 0.26, NULL),
('weekly', '2022-05-02', 'Business Intelligence', 4, '% Datasources in BI System', 0.26, NULL),
('weekly', '2022-05-09', 'Business Intelligence', 4, '% Datasources in BI System', 0.32, NULL),
('weekly', '2022-05-16', 'Business Intelligence', 4, '% Datasources in BI System', 0.36, NULL),
('weekly', '2022-05-23', 'Business Intelligence', 4, '% Datasources in BI System', 0.42, NULL),
('weekly', '2022-05-30', 'Business Intelligence', 4, '% Datasources in BI System', 0.47, NULL),
('monthly', '2022-03-01', 'Business Intelligence', 1, '% Depts with Reporting Enabled', 0.06, 1),
('monthly', '2022-04-01', 'Business Intelligence', 1, '% Depts with Reporting Enabled', 0.47, 1),
('monthly', '2022-05-01', 'Business Intelligence', 1, '% Depts with Reporting Enabled', 0.75, 1),
('monthly', '2022-03-01', 'Business Intelligence', 2, '% Crit metric Dash Coverage', 0.01, 1),
('monthly', '2022-04-01', 'Business Intelligence', 2, '% Crit metric Dash Coverage', 0.03, 1),
('monthly', '2022-05-01', 'Business Intelligence', 2, '% Crit metric Dash Coverage', 0.07, 1),
('monthly', '2022-03-01', 'Business Intelligence', 3, '% Depts with Full Jira Enablement', 0, 100),
('monthly', '2022-04-01', 'Business Intelligence', 3, '% Depts with Full Jira Enablement', 0, 100),
('monthly', '2022-05-01', 'Business Intelligence', 3, '% Depts with Full Jira Enablement', 0, 100),
('monthly', '2022-03-01', 'Business Intelligence', 4, '% Datasources in BI System', 0, 100),
('monthly', '2022-04-01', 'Business Intelligence', 4, '% Datasources in BI System', 0.21, 100),
('monthly', '2022-05-01', 'Business Intelligence', 4, '% Datasources in BI System', 0.42, 100)
;
