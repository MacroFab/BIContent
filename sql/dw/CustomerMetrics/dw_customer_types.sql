-- ***** Lookup activities lookback periods
DROP TABLE IF EXISTS dw.lkp_lookback;

CREATE TABLE dw.lkp_lookback
(
    lookback      DECIMAL(3,2) ENCODE az64
)
DISTSTYLE AUTO
SORTKEY AUTO
;

INSERT INTO dw.lkp_lookback VALUES
(0),
(0.25),
(0.5),
(0.75),
(1),
(1.25),
(1.5),
(1.75),
(2),
(2.25),
(2.5),
(2.75),
(3)
;

DROP TABLE IF EXISTS dw.lkp_lookback_max;

CREATE TABLE dw.lkp_lookback_max
(
    lookback_max  SMALLINT     ENCODE az64
)
DISTSTYLE AUTO
SORTKEY AUTO
;

INSERT INTO dw.lkp_lookback_max VALUES
(0),
(7),
(15),
(30),
(60),
(90),
(180),
(365)
;

-- ***** Temp table to sanitize deal property_order_url__value
DROP TABLE IF EXISTS stg.tmp_sanitize_deals;

CREATE TABLE stg.tmp_sanitize_deals
INTERLEAVED SORTKEY (hs_deal_id, order_hash)
AS
WITH ns AS (
  select 1 as n union all
  select 2 union all
  select 3 union all
  select 4 union all
  select 5 union all
  select 6 union all
  select 7 union all
  select 8 union all
  select 9 union all
  select 10
)
SELECT
    sa.hs_deal_id,
    sa.hs_closed_date,
    sa.hs_deal_amount,
    sa.parsed_order_url,
    CASE
       WHEN LEN(sa.parsed_order_url) < 9 THEN parsed_order_url
       ELSE SPLIT_PART(SPLIT_PART(parsed_order_url, '/order/', 2), '/', 1)
    END AS order_hash,
    sa.hs_platform_hash
FROM (
    SELECT
        de.hs_deal_id,
        de.hs_closed_date,
        de.hs_deal_amount,
        de.property_order_url__value,
        TRIM(SPLIT_PART(de.property_order_url__value, ',', ns.n)) AS parsed_order_url,
        de.property_platform_hash__value AS hs_platform_hash
    FROM ns
    INNER JOIN (
        SELECT
            d.dealid AS hs_deal_id,
            TRUNC(d.property_closedate__value) AS hs_closed_date,
            d.property_amount__value__double AS hs_deal_amount,
            d.property_order_url__value,
            d.property_platform_hash__value
        FROM hs.deals d
        INNER JOIN hs.deals__associations__associatedcompanyids hdac ON hdac._sdc_source_key_dealid = d.dealid
        INNER JOIN hs.companies hc ON hc.companyid = hdac."value"
        WHERE d.property_closedate__value IS NOT NULL
    ) de
    ON ns.n <= REGEXP_COUNT(de.property_order_url__value, ',') + 1
) sa
;

-- ***** Dim table to mapping HS company_id vs. organization_id
DROP TABLE IF EXISTS dw.dim_customer_mapping;

CREATE TABLE dw.dim_customer_mapping
(
    hs_company_id      BIGINT       ENCODE az64,
    hs_company_name    VARCHAR(256) ENCODE zstd,
    organization_id    BIGINT       ENCODE az64,
    organization_name  VARCHAR(256) ENCODE zstd
)
DISTSTYLE AUTO
SORTKEY AUTO
;

INSERT INTO dw.dim_customer_mapping
SELECT
    f.hs_company_id,
    f.hs_company_name,
    f.organization_id,
    f.organization_name
FROM (
    SELECT
        ts.hs_company_id,
        ts.hs_company_name,
        ts.organization_id,
        ts.organization_name,
        RANK() OVER (PARTITION BY ts.hs_company_id ORDER BY ts.organization_id) AS rnk
    FROM (
        SELECT DISTINCT
            hc.companyid AS hs_company_id,
            hc.property_name__value AS hs_company_name,
            o.organization_id AS organization_id,
            o.organization_name
        FROM stg.tmp_sanitize_deals d
        INNER JOIN hs.deals__associations__associatedcompanyids hdac ON hdac._sdc_source_key_dealid = d.hs_deal_id
        INNER JOIN hs.companies hc ON hc.companyid = hdac."value"
        LEFT JOIN (
            SELECT
                moh.hash AS order_hash,
                mo.organization_id,
                mco.name AS organization_name
            FROM mysql.order_hashes moh
            INNER JOIN mysql.orders mo ON mo.order_id = moh.order_id AND mo.status IN ('paid', 'processing', 'shipped', 'reviewed')
            INNER JOIN mysql.customer_organizations mco ON mco.organization_id = mo.organization_id
        ) o
          ON o.order_hash = d.order_hash
        WHERE (
                STRPOS(LOWER(hc.property_name__value), LOWER(o.organization_name)) > 0
                OR
                STRPOS(LOWER(o.organization_name), LOWER(hc.property_name__value)) > 0
              )
           OR
              (
                hc.property_name__value IS NULL
                OR
                o.organization_name IS NULL
              )
    ) ts
) f
WHERE f.rnk = 1

UNION

SELECT
    f.hs_company_id,
    f.hs_company_name,
    f.organization_id,
    f.organization_name
FROM (
    SELECT
        ts.hs_company_id,
        ts.hs_company_name,
        ts.organization_id,
        ts.organization_name,
        RANK() OVER (PARTITION BY ts.organization_id ORDER BY ts.hs_company_id) AS rnk
    FROM (
        SELECT DISTINCT
            d.hs_company_id,
            d.hs_company_name,
            mo.organization_id AS organization_id,
            mco.name AS organization_name
        FROM mysql.orders mo
        INNER JOIN mysql.order_hashes moh ON moh.order_id = mo.order_id
        INNER JOIN mysql.customer_organizations mco ON mco.organization_id = mo.organization_id
        LEFT JOIN (
            SELECT DISTINCT
                hc.companyid AS hs_company_id,
                hc.property_name__value AS hs_company_name,
                d.order_hash
            FROM stg.tmp_sanitize_deals d
            INNER JOIN hs.deals__associations__associatedcompanyids hdac ON hdac._sdc_source_key_dealid = d.hs_deal_id
            INNER JOIN hs.companies hc ON hc.companyid = hdac."value"
            WHERE LEN(d.order_hash) > 1
        ) d ON d.order_hash = moh.hash
        WHERE mo.status IN ('paid', 'processing', 'shipped', 'reviewed')
          AND (
                 (
                    STRPOS(LOWER(d.hs_company_name), LOWER(mco.name)) > 0
                    OR
                    STRPOS(LOWER(mco.name), LOWER(d.hs_company_name)) > 0
                 )
              OR
                 (
                    d.hs_company_name IS NULL
                    OR
                    mco.name IS NULL
                 )
        )
    ) ts
) f
WHERE f.rnk = 1
;



-- ***** Dim table to lookup company, organization, deals and orders
DROP TABLE IF EXISTS dw.dim_customer_objects;

CREATE TABLE dw.dim_customer_objects
(
    hs_company_id    BIGINT      ENCODE az64,
    hs_deal_id       BIGINT      ENCODE az64,
    hs_order_hash    VARCHAR(8)  ENCODE zstd,
    organization_id  BIGINT      ENCODE az64,
    order_id         BIGINT      ENCODE az64,
    order_hash       VARCHAR(8)  ENCODE zstd
)
DISTSTYLE AUTO
SORTKEY AUTO
;

CREATE TEMP TABLE tmp_sanitize_objects
AS
SELECT
    hc.companyid AS hs_company_id,
    d.hs_deal_id,
    d.order_hash AS hs_order_hash,
    o.organization_id AS organization_id,
    o.order_id,
    o.order_hash
FROM stg.tmp_sanitize_deals d
INNER JOIN hs.deals__associations__associatedcompanyids hdac ON hdac._sdc_source_key_dealid = d.hs_deal_id
INNER JOIN hs.companies hc ON hc.companyid = hdac."value"
LEFT JOIN (
    SELECT
        moh.hash AS order_hash,
        mo.order_id,
        mo.organization_id
    FROM mysql.order_hashes moh
    INNER JOIN mysql.orders mo
       ON  mo.order_id = moh.order_id
       AND mo.status IN ('paid', 'processing', 'shipped', 'reviewed')
) o
  ON o.order_hash = d.order_hash
WHERE d.hs_closed_date IS NOT NULL

UNION

SELECT
    d.hs_company_id,
    d.hs_deal_id,
    d.order_hash AS hs_order_hash,
    mo.organization_id AS organization_id,
    mo.order_id,
    moh.hash AS order_hash
FROM mysql.orders mo
INNER JOIN mysql.order_hashes moh ON moh.order_id = mo.order_id
LEFT JOIN (
    SELECT DISTINCT
        hc.companyid AS hs_company_id,
        d.hs_deal_id,
        d.order_hash
    FROM stg.tmp_sanitize_deals d
    INNER JOIN hs.deals__associations__associatedcompanyids hdac ON hdac._sdc_source_key_dealid = d.hs_deal_id
    INNER JOIN hs.companies hc ON hc.companyid = hdac."value"
    WHERE d.hs_closed_date IS NOT NULL
    AND LEN(d.order_hash) > 1
) d ON d.order_hash = moh.hash
WHERE mo.status IN ('paid', 'processing', 'shipped', 'reviewed')
;

INSERT INTO dw.dim_customer_objects
SELECT t.*
FROM tmp_sanitize_objects t
WHERE t.hs_deal_id IS NULL
   OR t.order_id IS NULL

UNION

SELECT t.*
FROM tmp_sanitize_objects t
INNER JOIN dw.dim_customer_mapping m
   ON  m.hs_company_id = t.hs_company_id
   AND m.organization_id = t.organization_id
WHERE t.hs_deal_id IS NOT NULL
  AND t.order_id IS NOT NULL
;

-- ***** Dim table to mark the customer activity type *****
DROP TABLE IF EXISTS dw.dim_customer_activity_type;

CREATE TABLE dw.dim_customer_activity_type
(
    hs_company_id   BIGINT     ENCODE az64,
    organization_id BIGINT     ENCODE az64,
    object_type     VARCHAR(8) ENCODE zstd,
    object_id       BIGINT     ENCODE az64
)
DISTSTYLE AUTO
SORTKEY AUTO
;

INSERT INTO dw.dim_customer_activity_type
SELECT
    lk.hs_company_id,
    lk.organization_id,
    'deal' AS object_type,
    tde.hs_deal_id AS object_id
FROM dw.dim_customer_objects lk
INNER JOIN (
   SELECT
       hc.companyid AS hs_company_id,
       d.hs_deal_id
   FROM stg.tmp_sanitize_deals d
   INNER JOIN hs.deals__associations__associatedcompanyids hdac ON hdac._sdc_source_key_dealid = d.hs_deal_id
   INNER JOIN hs.companies hc ON hc.companyid = hdac."value"
   WHERE d.hs_closed_date IS NOT NULL
   GROUP BY 1,2
) tde
  ON  tde.hs_company_id = lk.hs_company_id
  AND tde.hs_deal_id = lk.hs_deal_id

UNION

SELECT
    lk.hs_company_id,
    lk.organization_id,
    'order' AS object_type,
    tor.order_id AS object_id
FROM dw.dim_customer_objects lk
INNER JOIN (
   SELECT
       mo.organization_id,
       mo.order_id
   FROM mysql.orders mo 
   INNER JOIN mysql.order_hashes moh ON mo.order_id = moh.order_id
   WHERE mo.status IN ('paid', 'processing', 'shipped', 'reviewed')
   GROUP BY 1,2
) tor
  ON  tor.organization_id = lk.organization_id
  AND tor.order_id = lk.order_id

UNION

SELECT
    lk.hs_company_id,
    lk.organization_id,
    'shipment' AS object_type,
    tsh.order_shipmentid AS object_id
FROM dw.dim_customer_objects lk
INNER JOIN (
   SELECT
       mo.organization_id,
       mo.order_id,
       mos.order_shipmentid
   FROM mysql.orders mo 
   INNER JOIN mysql.order_hashes moh ON mo.order_id = moh.order_id
   INNER JOIN mysql.order_shipments mos ON mos.order_id = mo.order_id
   WHERE mo.status IN ('paid', 'processing', 'shipped', 'reviewed')
   GROUP BY 1,2,3
) tsh 
  ON  tsh.organization_id = lk.organization_id
  AND tsh.order_id = lk.order_id
;


-- ***** Fact table to compute the customer activity detail records *****
DROP TABLE IF EXISTS dw.fct_customer_activity;

CREATE TABLE dw.fct_customer_activity
(
    hs_company_id    BIGINT        ENCODE az64,
    organization_id  BIGINT        ENCODE az64,
    activity         VARCHAR(8)    ENCODE zstd,
    activity_date    DATE          ENCODE az64,
    hs_deal_id       BIGINT        ENCODE az64,
    hs_closed_date   DATE          ENCODE az64,
    hs_deal_amount   NUMERIC(38,6) ENCODE az64,
    order_id         BIGINT        ENCODE az64,
    order_submitted  DATE          ENCODE az64,
    invoice_total    NUMERIC(38,6) ENCODE az64,
    order_shipmentid BIGINT        ENCODE az64,
    shipped          DATE          ENCODE az64,
    org_id_lookup    BIGINT        ENCODE az64
)
DISTSTYLE AUTO
SORTKEY AUTO
;

INSERT INTO dw.fct_customer_activity
SELECT
    dcat.hs_company_id,
    dcat.organization_id,
    'booking' AS activity,
    hsd.hs_closed_date AS activity_date,
    hsd.hs_deal_id,
    hsd.hs_closed_date,
    hsd.hs_deal_amount,
    mo.order_id,
    TRUNC(mo.submitted) AS order_submitted,
    mo.invoice_total,
    NULL::INTEGER AS order_shipmentid,
    NULL::DATE AS shipped,
    NVL(dcat.organization_id, dcat.hs_company_id) AS org_id_lookup
FROM dw.dim_customer_activity_type dcat
INNER JOIN (
   SELECT
       hc.companyid AS hs_company_id,
       d.hs_deal_id,
       d.hs_closed_date,
       d.hs_deal_amount,
       d.order_hash
   FROM stg.tmp_sanitize_deals d
   INNER JOIN hs.deals__associations__associatedcompanyids hdac ON hdac._sdc_source_key_dealid = d.hs_deal_id
   INNER JOIN hs.companies hc ON hc.companyid = hdac."value"
   WHERE d.hs_closed_date IS NOT NULL
) hsd
  ON  hsd.hs_company_id = dcat.hs_company_id
  AND hsd.hs_deal_id = dcat.object_id
LEFT JOIN mysql.order_hashes moh ON moh.hash = hsd.order_hash
LEFT JOIN mysql.orders mo ON mo.order_id = moh.order_id AND mo.status IN ('paid', 'processing', 'shipped', 'reviewed')
WHERE object_type = 'deal'

UNION

SELECT
    dcat.hs_company_id,
    dcat.organization_id,
    'order' AS activity,
    TRUNC(mo.submitted) AS activity_date,
    hsd.hs_deal_id,
    hsd.hs_closed_date,
    hsd.hs_deal_amount,
    mo.order_id,
    TRUNC(mo.submitted) AS order_submitted,
    mo.invoice_total,
    NULL AS order_shipmentid,
    NULL AS shipped,
    NVL(dcat.organization_id, dcat.hs_company_id) AS org_id_lookup
FROM dw.dim_customer_activity_type dcat
INNER JOIN mysql.orders mo
   ON  mo.order_id = dcat.object_id
   AND mo.organization_id = dcat.organization_id
   AND mo.status IN ('paid', 'processing', 'shipped', 'reviewed') AND mo.submitted IS NOT NULL
INNER JOIN mysql.order_hashes moh
   ON moh.order_id = mo.order_id
LEFT JOIN (
   SELECT
       hc.companyid AS hs_company_id,
       d.hs_deal_id,
       d.hs_closed_date,
       d.hs_deal_amount,
       d.order_hash
   FROM stg.tmp_sanitize_deals d
   INNER JOIN hs.deals__associations__associatedcompanyids hdac ON hdac._sdc_source_key_dealid = d.hs_deal_id
   INNER JOIN hs.companies hc ON hc.companyid = hdac."value"
   WHERE d.hs_closed_date IS NOT NULL
     AND LEN(d.order_hash) > 1
) hsd
  ON  hsd.order_hash = moh.hash
  AND hsd.hs_company_id = dcat.hs_company_id
WHERE dcat.object_type = 'order'

UNION

SELECT
    dcat.hs_company_id,
    dcat.organization_id,
    'shipment' AS activity,
    TRUNC(mos.shipped) AS activity_date,
    hsd.hs_deal_id,
    hsd.hs_closed_date,
    hsd.hs_deal_amount,
    mo.order_id,
    TRUNC(mo.submitted) AS order_submitted,
    mo.invoice_total,
    mos.order_shipmentid,
    TRUNC(mos.shipped) AS shipped,
    NVL(dcat.organization_id, dcat.hs_company_id) AS org_id_lookup
FROM dw.dim_customer_activity_type dcat
INNER JOIN mysql.orders mo
   ON  mo.organization_id = dcat.organization_id
   AND mo.status IN ('paid', 'processing', 'shipped', 'reviewed') AND mo.submitted IS NOT NULL
INNER JOIN mysql.order_hashes moh
   ON moh.order_id = mo.order_id
INNER JOIN mysql.order_shipments mos
   ON  mos.order_shipmentid = dcat.object_id
   AND mos.order_id = mo.order_id
LEFT JOIN (
   SELECT
       hc.companyid AS hs_company_id,
       d.hs_deal_id,
       d.hs_closed_date,
       d.hs_deal_amount,
       d.order_hash
   FROM stg.tmp_sanitize_deals d
   INNER JOIN hs.deals__associations__associatedcompanyids hdac ON hdac._sdc_source_key_dealid = d.hs_deal_id
   INNER JOIN hs.companies hc ON hc.companyid = hdac."value"
   WHERE d.hs_closed_date IS NOT NULL
     AND LEN(d.order_hash) > 1
) hsd
  ON  hsd.order_hash = moh.hash
WHERE object_type = 'shipment'
;


-- ***** Fact table to compute New/Retained/Lost/Reactivated customers *****
DROP TABLE IF EXISTS dw.fct_customer_type_monthly;

CREATE TABLE dw.fct_customer_type_monthly
(
    activity_period   DATE          ENCODE az64,
    lookback          DECIMAL(3,2)  ENCODE az64,
    lookback_max      SMALLINT      ENCODE az64,
    customer_type     VARCHAR(11)   ENCODE zstd,
    hs_company_id     BIGINT        ENCODE az64,
    organization_id   BIGINT        ENCODE az64,
    activity          VARCHAR(8)    ENCODE zstd,
    activity_date     DATE          ENCODE az64,
    hs_deal_id        BIGINT        ENCODE az64,
    hs_closed_date    DATE          ENCODE az64,
    hs_deal_amount    NUMERIC(38,6) ENCODE az64,
    order_id          BIGINT        ENCODE az64,
    order_submitted   DATE          ENCODE az64,
    invoice_total     NUMERIC(38,6) ENCODE az64,
    order_shipmentid  BIGINT        ENCODE az64,
    shipped           DATE          ENCODE az64,
    org_id_lookup     BIGINT        ENCODE az64

)
DISTSTYLE AUTO
SORTKEY AUTO
;

INSERT INTO dw.fct_customer_type_monthly
WITH tbl_periods AS
(
	SELECT
		ap.activity_period_start,
		ADD_MONTHS(ap.activity_period_start, 1)::DATE AS activity_period_end,
        ll.lookback,
        lm.lookback_max,
        DATEADD(day, -(30 * ll.lookback)::INT, ap.activity_period_start)::DATE AS lookback_day,
        DATEADD(day, -lm.lookback_max, ap.activity_period_start)::DATE AS lookback_day_max
    FROM (
        SELECT ADD_MONTHS('2021-09-01'::DATE, num.i)::DATE AS activity_period_start
        FROM (
            SELECT row_number() OVER () AS i
            FROM (SELECT 0 AS "n" UNION ALL SELECT 1 UNION ALL SELECT 2),
                 (SELECT 0 AS "n" UNION ALL SELECT 1 UNION ALL SELECT 2),
                 (SELECT 0 AS "n" UNION ALL SELECT 1 UNION ALL SELECT 2),
                 (SELECT 0 AS "n" UNION ALL SELECT 1 UNION ALL SELECT 2)
            ORDER BY 1
            LIMIT 60
        ) num
        WHERE activity_period_start <= DATE_TRUNC('month', GETDATE())
        GROUP BY 1
    ) ap,
    dw.lkp_lookback ll,
    dw.lkp_lookback_max lm
)
SELECT
    tp.activity_period_start AS activity_period,
    tp.lookback,
    tp.lookback_max,
    'new' AS customer_type,
    ca.*
FROM tbl_periods tp
INNER JOIN dw.fct_customer_activity ca
	ON  ca.activity_date >= tp.activity_period_start
	AND ca.activity_date < tp.activity_period_end
LEFT JOIN (
	SELECT org_id_lookup, activity_date, count(1)
	FROM dw.fct_customer_activity nc
	GROUP BY 1,2
) new_cus
	ON  new_cus.org_id_lookup = ca.org_id_lookup
	AND new_cus.activity_date < tp.activity_period_start
WHERE new_cus.org_id_lookup IS NULL

UNION

SELECT
    tp.activity_period_start AS activity_period,
    tp.lookback,
    tp.lookback_max,
    'retained' AS customer_type,
    ca.*
FROM tbl_periods tp
INNER JOIN dw.fct_customer_activity ca
   ON  ca.activity_date >= tp.activity_period_start
   AND ca.activity_date < tp.activity_period_end
INNER JOIN (
   SELECT org_id_lookup, activity_date, count(1)
   FROM dw.fct_customer_activity rc
   GROUP BY 1,2
) ret_cus
ON ret_cus.activity_date >= tp.lookback_day
   AND ret_cus.activity_date < tp.activity_period_start
   AND ret_cus.org_id_lookup = ca.org_id_lookup
      
UNION

SELECT
    tp.activity_period_start AS activity_period,
    tp.lookback,
    tp.lookback_max,
    'lost' AS customer_type,
    ca.*
FROM tbl_periods tp
INNER JOIN dw.fct_customer_activity ca
    ON  ca.activity_date >= tp.lookback_day
    AND ca.activity_date < tp.activity_period_start
LEFT JOIN (
    SELECT org_id_lookup, activity_date, count(1)
    FROM dw.fct_customer_activity lc
    GROUP BY 1,2
) lost_cus
    ON lost_cus.activity_date >= tp.activity_period_start
    AND lost_cus.activity_date < tp.activity_period_end
	AND lost_cus.org_id_lookup = ca.org_id_lookup
WHERE lost_cus.org_id_lookup IS NULL

UNION

SELECT
    tp.activity_period_start AS activity_period,
    tp.lookback,
    tp.lookback_max,
    'reactivated' AS customer_type,
    ca.*
FROM tbl_periods tp
INNER JOIN dw.fct_customer_activity ca
    ON  ca.activity_date >= tp.activity_period_start
    AND ca.activity_date < tp.activity_period_end
LEFT JOIN (
    SELECT org_id_lookup, activity_date, count(1)
    FROM dw.fct_customer_activity rc
    GROUP BY 1,2
) rea_cus1 
    ON  rea_cus1.activity_date >= tp.lookback_day
    AND rea_cus1.activity_date < tp.activity_period_start
    AND rea_cus1.org_id_lookup = ca.org_id_lookup
INNER JOIN (
   SELECT org_id_lookup, activity_date, count(1)
   FROM dw.fct_customer_activity rc
   GROUP BY 1,2
) rea_cus2
	ON  rea_cus2.activity_date < tp.lookback_day
    AND rea_cus2.org_id_lookup = ca.org_id_lookup
WHERE rea_cus1.org_id_lookup IS NULL
;
