select
 i.user_id,
 r.email,
 source_container_id,
 dest_container_id,
 concat(c.row,'-',c.rack,'-',c.index) as source_container,
 concat(d.row,'-',d.rack,'-',d.index) as dest_container,
 @unit_count := unit_count,
 unit_value,
 @total_value := unit_count * unit_value,
 IF(@total_value < 0, @total_value,0) debit_value,
 IF(@total_value >= 0, @total_value,0) credit_value,
 IF(@unit_count < 0, @unit_count,0) debit_count,
 IF(@unit_count >= 0, @unit_count,0) credit_count,
 i.created
FROM
 inventory_moves i,
 inventory_containers c,
 inventory_containers d,
 rt_users_list r
WHERE
 item_id = {{ obgDetails.selectedRow.data.item_id}} and
 c.container_id = source_container_id and
 d.container_id = dest_container_id and
 r.user_id = i.user_id