CREATE TABLE dw.fct_components_purchasing (
    order_hash                     VARCHAR(8) ENCODE zstd,
    jobid                          INTEGER ENCODE az64,
    customer                       VARCHAR(256) ENCODE zstd,
    order_type                     VARCHAR(256) ENCODE zstd,
    status                         VARCHAR(256) ENCODE zstd,
    committed_due_date             timestamp ENCODE az64,
    tier                           VARCHAR(256) ENCODE zstd,
    program_managed                SMALLINT ENCODE az64,
    component_purchase_order       VARCHAR(256) ENCODE zstd,
    auto_purchased                 SMALLINT ENCODE az64,
    component_vendor_orderid       bigint ENCODE az64,
    component_vendor_order_item_id bigint ENCODE az64,
    vendor_id                      INTEGER ENCODE az64,
    vendor_name                    VARCHAR(80) ENCODE zstd,
    manufacturer_partnum           VARCHAR(80) ENCODE zstd,
    total_cost                     DECIMAL(10,3) ENCODE az64,
    job_created                    timestamp ENCODE az64,
    purchased                      timestamp ENCODE az64,
    dock_date                      timestamp ENCODE az64,
    received                       timestamp ENCODE az64,
    hours_to_purchase              SMALLINT ENCODE az64,
    purchased_1d                   SMALLINT ENCODE az64,
    purchased_1d_plus              SMALLINT ENCODE az64,
    days_to_receive                SMALLINT ENCODE az64,
    received_by_dock_date          SMALLINT ENCODE az64,
    purchased_to_dock_days         SMALLINT ENCODE az64
)
DISTSTYLE AUTO
SORTKEY AUTO
;

TRUNCATE TABLE dw.fct_components_purchasing;

INSERT INTO dw.fct_components_purchasing
SELECT
	ooh.hash AS order_hash,
	ocvoi.jobid,
    rco.name AS customer,
    oo.type AS order_type,
    oo.status,
    oo.committed_due_date,
    oo.tier,
    oo.sales_assisted AS program_managed,
    ocvo.remote_vendor_orderid AS component_purchase_order,
    CASE WHEN ocvo.automation_status = 'manual' THEN False ELSE True END AS auto_purchased,
    ocvo.vendor_orderid AS component_vendor_orderid,
	ocvoi.component_vendor_order_item_id,
    ov.id AS vendor_id,
	ov.name AS vendor_name,
	ocvoi.manufacturer_partnum,
	ocvoi.total_cost,
    jj.created AS job_created,
    NVL(ocvo.submitted, ocvo.created) AS purchased,
	ocvo.dock_date,
	ocvo.received AS received,
	DATEDIFF(hour, jj.created, NVL(ocvo.submitted, ocvo.created)) AS hours_to_purchase,
    CASE WHEN DATEDIFF(day, jj.created, NVL(ocvo.submitted, ocvo.created)) <= 1 THEN 1 ELSE 0 END AS purchased_1d,
	CASE WHEN DATEDIFF(day, jj.created, NVL(ocvo.submitted, ocvo.created)) > 1 THEN 1 ELSE 0 END AS purchased_1d_plus,
    DATEDIFF(day, NVL(ocvo.submitted, ocvo.created), ocvo.received) AS days_to_receive,
    CASE WHEN DATEDIFF(day, ocvo.dock_date, ocvo.received) < 0 THEN 1 ELSE 0 END AS received_by_dock_date,
	DATEDIFF(day, NVL(ocvo.submitted, ocvo.created), ocvo.dock_date) AS purchased_to_dock_days
FROM mysql.component_vendor_order ocvo
LEFT JOIN mysql.component_vendor_order_items ocvoi ON ocvoi.vendor_orderid = ocvo.vendor_orderid
LEFT JOIN mysql.orders oo ON oo.order_id = ocvoi.orderid
LEFT JOIN mysql.order_hashes ooh ON oo.order_id = ooh.order_id
LEFT JOIN mysql.customer_organizations rco ON rco.organization_id = oo.organization_id
LEFT JOIN mysql.jobs jj ON jj.jobid = ocvoi.jobid
INNER JOIN mysql.vendors ov ON ov.id = ocvo.vendorid
WHERE jj.created > '2021-09-30'
;
