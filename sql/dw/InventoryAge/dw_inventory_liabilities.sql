-- ***** Fact table to compute monthly inventory details *****
DROP TABLE IF EXISTS dw.fct_inventory_liabilities;

CREATE TABLE dw.fct_inventory_liabilities
AS
WITH tbl_months AS
(
    SELECT (ADD_MONTHS('2020-10-01'::DATE, num.i) - 1)::DATE AS snapshot_month
    FROM (SELECT row_number() OVER () AS i
            FROM (SELECT 0 AS "n" UNION ALL SELECT 1 UNION ALL SELECT 2),
                 (SELECT 0 AS "n" UNION ALL SELECT 1 UNION ALL SELECT 2),
                 (SELECT 0 AS "n" UNION ALL SELECT 1 UNION ALL SELECT 2)
            ORDER BY 1
            LIMIT 18
    ) num
    GROUP BY 1
)
SELECT
    tm.snapshot_month,
    l.id AS inventory_item_location_id,
    l.item_id, 
    l.unit_count,
    l.unit_value,
    l.unit_count * l.unit_value AS line_item_value,
    TRUNC(l.created) AS created,
    i.part_num,
    o.organization_id AS liability_org_id,
    r.name AS liability_org_name,
    CASE i.inventory_item_subtype_key
 	   WHEN 'component' THEN 'Component'
       WHEN 'other_material' THEN 'Other'
       WHEN 'other_tooling' THEN 'Tooling'
       WHEN 'panel' THEN 'PCB'
       WHEN 'stencil' THEN 'Stencil'
    END as item_type,
    w.name AS warehouse,
    datediff(day, TRUNC(l.created), tm.snapshot_month) AS inventory_days
FROM mysql.inventory_obligations o,
     mysql.inventory_item_location l,
     mysql.rt_organizations_list r,
     mysql.inventory_items i,
     mysql.inventory_warehouses w,
     mysql.inventory_location lo,
     tbl_months tm
WHERE
     l.id = o.inventory_item_location_id
 AND i.item_id = l.item_id
 AND r.organization_id = o.organization_id
 AND lo.location_id = l.location_id
 AND w.warehouse_id = lo.warehouse_id
 AND tm.snapshot_month >= DATE_TRUNC('month', l.created)
;

ALTER TABLE dw.fct_inventory_liabilities ALTER SORTKEY AUTO;
