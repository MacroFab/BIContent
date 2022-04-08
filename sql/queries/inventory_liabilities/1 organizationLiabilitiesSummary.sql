SELECT
 o.organization_id,
 r.name,
 sum(unit_count * unit_value) as total_obligation
FROM
 inventory_obligations o,
 inventory_item_location i,
 rt_organizations_list r
WHERE
 i.id = o.inventory_item_location_id and
 r.organization_id = o.organization_id
GROUP BY 
 o.organization_id
 