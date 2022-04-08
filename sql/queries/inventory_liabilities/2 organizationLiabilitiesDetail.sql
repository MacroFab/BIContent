SELECT
 l.id,
 l.item_id, 
 l.unit_count,
 l.unit_value,
 l.unit_count * l.unit_value as line_item_value,
 l.created,
 i.part_num,
 i.internal_part_num,
 o.organization_id,
 r.name
FROM
 inventory_obligations o,
 inventory_item_location l,
 rt_organizations_list r,
 inventory_items i
WHERE
 o.organization_id = {{ obgSummary.selectedRow.data.organization_id  }} and
 l.id = o.inventory_item_location_id and
 i.item_id = l.item_id and
 r.organization_id = o.organization_id