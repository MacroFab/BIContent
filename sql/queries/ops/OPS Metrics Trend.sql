SELECT
    g.shipped_month_str,
    round(avg(pcb_plan_duration_actual)) AS avg_pcb_plan_duration_actual,
    round(avg(component_plan_duration_actual)) AS avg_component_plan_duration_actual,
    round(avg(plan_duration_actual)) AS avg_plan_duration_actual,
    round(avg(pcb_purchase_duration_actual)) AS avg_pcb_purchase_duration_actual,
    round(avg(component_purchase_duration_actual)) AS avg_component_purchase_duration_actual,
    round(avg(purchase_duration_actual)) AS avg_purchase_duration_actual,
    round(avg(vendor_duration_actual)) AS avg_vendor_duration_actual,
    round(avg(receive_duration_actual)) AS avg_receive_duration_actual,
    round(avg(kit_wait_to_start_duration_actual)) AS kit_wait_to_start_duration_actual,
    round(avg(kit_duration_actual)) AS avg_kit_duration_actual,
    round(avg(transfer_out_duration_actual)) AS avg_transfer_out_duration_actual,
    round(avg(network_receive_duration_actual)) AS avg_network_receive_duration_actual,
    round(avg(manufacture_wait_to_start_duration_actual)) AS avg_manufacture_wait_to_start_duration_actual,
    round(avg(manufacture_duration_actual)) AS avg_manufacture_duration_actual,
    round(avg(transfer_back_duration_actual)) AS avg_transfer_back_duration_actual,
    round(avg(qa_wait_to_start_duration_actual)) AS avg_qa_wait_to_start_duration_actual,
    round(avg(qa_duration_actual)) AS avg_qa_duration_actual,
    round(avg(pack_wait_to_start_duration_actual)) AS avg_pack_wait_to_start_duration_actual,
    round(avg(pack_duration_actual)) AS avg_pack_duration_actual,
    round(avg(ship_duration_actual)) AS avg_ship_duration_actual,

    round(avg(pcb_plan_duration_variance)) AS avg_pcb_plan_duration_var,
    round(avg(component_plan_duration_variance)) AS avg_component_plan_duration_var,
	round(avg(plan_duration_variance)) AS avg_plan_duration_var,
    round(avg(pcb_purchase_duration_variance)) AS avg_pcb_purchase_duration_var,
    round(avg(component_purchase_duration_variance)) AS avg_component_purchase_duration_var,
    round(avg(purchase_duration_variance)) AS avg_purchase_duration_var,
    round(avg(vendor_duration_variance)) AS avg_vendor_duration_var,
    round(avg(receive_duration_variance)) AS avg_receive_duration_var,
    round(avg(kit_wait_to_start_duration_variance)) AS avg_kit_wait_to_start_duration_var,
    round(avg(kit_duration_duration_variance)) AS avg_kit_duration_duration_var,
    round(avg(transfer_out_duration_variance)) AS avg_transfer_out_duration_var,
    round(avg(network_receive_duration_variance)) AS avg_network_receive_duration_var,
    round(avg(manufacture_wait_to_start_duration_variance)) AS avg_manufacture_wait_to_start_duration_var,
    round(avg(manufacture_duration_variance)) AS avg_manufacture_duration_var,
    round(avg(transfer_back_duration_variance)) AS avg_transfer_back_duration_var,
    round(avg(qa_wait_to_start_duration_variance)) AS avg_qa_wait_to_start_duration_var,
    round(avg(qa_duration_variance)) AS avg_qa_duration_var,
    round(avg(pack_wait_to_start_duration_variance)) AS avg_pack_wait_to_start_duration_var,
    round(avg(pack_duration_variance)) AS avg_pack_duration_var,
    round(avg(ship_duration_variance)) AS avg_ship_duration_var
FROM (
	SELECT
		f.*,
		f.pcb_plan_duration_actual - f.pcb_plan_duration_target AS pcb_plan_duration_variance,
		f.component_plan_duration_actual - f.component_plan_duration_target AS component_plan_duration_variance,
		f.plan_duration_actual - f.plan_duration_target AS plan_duration_variance,
		f.pcb_purchase_duration_actual - f.pcb_purchase_duration_target AS pcb_purchase_duration_variance,
		f.component_purchase_duration_actual - f.component_purchase_duration_target AS component_purchase_duration_variance,
		f.purchase_duration_actual - f.purchase_duration_target AS purchase_duration_variance,
		f.vendor_duration_actual - f.vendor_duration_target AS vendor_duration_variance,
		f.receive_duration_actual - f.receive_duration_target AS receive_duration_variance,
		f.kit_wait_to_start_duration_actual - f.kit_wait_to_start_duration_target AS kit_wait_to_start_duration_variance,
		f.kit_duration_actual - f.kit_duration_target AS kit_duration_duration_variance,
		f.transfer_out_duration_actual - f.transfer_out_duration_target AS transfer_out_duration_variance,
		f.network_receive_duration_actual - f.network_receive_duration_target AS network_receive_duration_variance,
		f.manufacture_wait_to_start_duration_actual - f.manufacture_wait_to_start_duration_target AS manufacture_wait_to_start_duration_variance,
		f.manufacture_duration_actual - f.manufacture_duration_target AS manufacture_duration_variance,
		f.transfer_back_duration_actual - f.transfer_back_duration_target AS transfer_back_duration_variance,
		f.qa_wait_to_start_duration_actual - f.qa_wait_to_start_duration_target AS qa_wait_to_start_duration_variance,
		f.qa_duration_actual - f.qa_duration_target AS qa_duration_variance,
		f.pack_wait_to_start_duration_actual - f.pack_wait_to_start_duration_target AS pack_wait_to_start_duration_variance,
		f.pack_duration_actual - f.pack_duration_target AS pack_duration_variance,
		f.ship_duration_actual - f.ship_duration_target AS ship_duration_variance
	FROM (
		SELECT
			e.order,
			EXTRACT(YEAR_MONTH FROM e.ship_actual) AS shipped_date,
			DATE_FORMAT(e.ship_actual, '%Y-%m') AS shipped_month_str,

			DATEDIFF(e.plan_target, e.order_batch_date) AS pcb_plan_duration_target,
			DATEDIFF(e.plan_target, e.order_batch_date) AS component_plan_duration_target,
			DATEDIFF(e.plan_target, e.order_batch_date) AS plan_duration_target,
			DATEDIFF(e.purchase_target, e.plan_target) AS pcb_purchase_duration_target,
			DATEDIFF(e.purchase_target, e.plan_target) AS component_purchase_duration_target,
			DATEDIFF(e.purchase_target, e.plan_target) AS purchase_duration_target,
			DATEDIFF(e.vendor_target, e.purchase_target) AS vendor_duration_target,
			DATEDIFF(e.receive_target, e.purchase_target) AS receive_duration_target,
			DATEDIFF(e.kit_start_target, e.receive_target) AS kit_wait_to_start_duration_target,
			DATEDIFF(e.kit_end_target, e.kit_start_target) AS kit_duration_target,
			DATEDIFF(e.transfer_out_target, e.kit_end_target) AS transfer_out_duration_target,
			DATEDIFF(e.network_receive_target, e.transfer_out_target) AS network_receive_duration_target,
			DATEDIFF(e.manufacture_start_target, e.network_receive_target) AS manufacture_wait_to_start_duration_target,
			DATEDIFF(e.manufacture_end_target, e.manufacture_start_target) AS manufacture_duration_target,
			DATEDIFF(e.transfer_back_target, e.manufacture_end_target) AS transfer_back_duration_target,
			DATEDIFF(e.qa_start_target, e.transfer_back_target) AS qa_wait_to_start_duration_target,
			DATEDIFF(e.qa_end_target, e.qa_start_target) AS qa_duration_target,
			DATEDIFF(e.pack_start_target, e.qa_end_target) AS pack_wait_to_start_duration_target,
			DATEDIFF(e.pack_end_target, e.pack_start_target) AS pack_duration_target,
			DATEDIFF(e.ship_target, e.pack_end_target) AS ship_duration_target,

			DATEDIFF(e.pcb_plan_actual, e.order_batch_date) AS pcb_plan_duration_actual,
			DATEDIFF(e.component_plan_actual, e.order_batch_date) AS component_plan_duration_actual,
			DATEDIFF(e.plan_actual, e.order_batch_date) AS plan_duration_actual,
			DATEDIFF(e.pcb_purchase_actual, e.plan_actual) AS pcb_purchase_duration_actual,
			DATEDIFF(e.component_plan_actual, e.plan_actual) AS component_purchase_duration_actual,
			DATEDIFF(e.purchase_actual, e.plan_actual) AS purchase_duration_actual,
			DATEDIFF(e.vendor_actual, e.purchase_actual) AS vendor_duration_actual,
			DATEDIFF(e.receive_actual, e.purchase_actual) AS receive_duration_actual,
			DATEDIFF(e.kit_start_actual, e.receive_actual) AS kit_wait_to_start_duration_actual,
			DATEDIFF(e.kit_end_actual, e.kit_start_actual) AS kit_duration_actual,
			DATEDIFF(e.transfer_out_actual, e.kit_end_actual) AS transfer_out_duration_actual,
			DATEDIFF(e.network_receive_actual, e.transfer_out_actual) AS network_receive_duration_actual,
			DATEDIFF(e.manufacture_start_actual, e.network_receive_actual) AS manufacture_wait_to_start_duration_actual,
			DATEDIFF(e.manufacture_end_actual, e.manufacture_start_actual) AS manufacture_duration_actual,
			DATEDIFF(e.transfer_back_actual, e.manufacture_end_actual) AS transfer_back_duration_actual,
			DATEDIFF(e.qa_start_actual, e.transfer_back_actual) AS qa_wait_to_start_duration_actual,
			DATEDIFF(e.qa_end_actual, e.qa_start_actual) AS qa_duration_actual,
			DATEDIFF(e.pack_start_actual, e.qa_end_actual) AS pack_wait_to_start_duration_actual,
			DATEDIFF(e.pack_end_actual, e.pack_start_actual) AS pack_duration_actual,
			DATEDIFF(e.ship_actual, e.pack_end_actual) AS ship_duration_actual
		FROM (
			SELECT
				d.order_hash AS "order",
				d.order_batch_date,
				-- Plan
				d.plan_target,
				IF(d.component_plan_actual > d.plan_actual, d.plan_actual, d.component_plan_actual) AS component_plan_actual,
				IF(d.pcb_plan_actual > d.plan_actual, d.plan_actual, d.pcb_plan_actual) AS pcb_plan_actual,
				d.plan_actual,
				-- Purchase
				d.purchase_target,
				IF(d.component_purchase_actual > d.purchase_actual, d.purchase_actual, d.component_purchase_actual) AS component_purchase_actual,
				IF(d.pcb_purchase_actual > d.purchase_actual, d.purchase_actual, d.pcb_purchase_actual) AS pcb_purchase_actual,
				d.purchase_actual,
				-- Vendor OTD
				d.vendor_target,
				d.vendor_actual,
				-- Receive
				d.receive_target,
				d.receive_actual,
				-- Kit
				d.kit_start_target,
				d.kit_start_actual,
				d.kit_end_target,
				d.kit_end_actual,
				-- Transfer out
				d.transfer_out_target,
				d.transfer_out_actual,
				-- Network Receive
				d.network_receive_target,
				d.network_receive_actual,
				-- Manufacture
				d.manufacture_start_target,
				d.manufacture_start_actual,
				d.manufacture_end_target,
				d.manufacture_end_actual,
				-- Transfer back
				d.transfer_back_target,
				d.transfer_back_actual,
				-- Quality
				d.qa_start_target,
				d.qa_start_actual,
				d.qa_end_target,
				d.qa_end_actual,
				-- Pack
				d.pack_start_target,
				d.pack_start_actual,
				d.pack_end_target,
				d.pack_end_actual,
				-- Shipping
				d.ship_target,
				d.ship_actual
			FROM (
				SELECT
					c.order_hash,
					c.order_batch_date,
					c.plan_target,
					c.component_plan_actual,
					c.pcb_plan_actual,
					IF(c.plan_actual > IF(c.purchase_actual > IF(c.vendor_actual > IF(c.receive_actual > IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), c.receive_actual), IF(c.receive_actual > IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), c.receive_actual), c.vendor_actual), IF(c.vendor_actual > IF(c.receive_actual > IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), c.receive_actual), IF(c.receive_actual > IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), c.receive_actual), c.vendor_actual), c.purchase_actual), IF(c.purchase_actual > IF(c.vendor_actual > IF(c.receive_actual > IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), c.receive_actual), IF(c.receive_actual > IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), c.receive_actual), c.vendor_actual), IF(c.vendor_actual > IF(c.receive_actual > IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), c.receive_actual), IF(c.receive_actual > IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), c.receive_actual), c.vendor_actual), c.purchase_actual), c.plan_actual) AS plan_actual,
					-- Purchase
					IF(c.purchase_target > IF(c.vendor_target > IF(c.receive_target > IF(c.kit_start_target > IF(c.kit_end_target > c.transfer_out_target, c.transfer_out_target, c.kit_end_target), IF(c.kit_end_target > c.transfer_out_target, c.transfer_out_target, c.kit_end_target), c.kit_start_target), IF(c.kit_start_target > IF(c.kit_end_target > c.transfer_out_target, c.transfer_out_target, c.kit_end_target), IF(c.kit_end_target > c.transfer_out_target, c.transfer_out_target, c.kit_end_target), c.kit_start_target), c.receive_target), IF(c.receive_target > IF(c.kit_start_target > IF(c.kit_end_target > c.transfer_out_target, c.transfer_out_target, c.kit_end_target), IF(c.kit_end_target > c.transfer_out_target, c.transfer_out_target, c.kit_end_target), c.kit_start_target), IF(c.kit_start_target > IF(c.kit_end_target > c.transfer_out_target, c.transfer_out_target, c.kit_end_target), IF(c.kit_end_target > c.transfer_out_target, c.transfer_out_target, c.kit_end_target), c.kit_start_target), c.receive_target), c.vendor_target), IF(c.vendor_target > IF(c.receive_target > IF(c.kit_start_target > IF(c.kit_end_target > c.transfer_out_target, c.transfer_out_target, c.kit_end_target), IF(c.kit_end_target > c.transfer_out_target, c.transfer_out_target, c.kit_end_target), c.kit_start_target), IF(c.kit_start_target > IF(c.kit_end_target > c.transfer_out_target, c.transfer_out_target, c.kit_end_target), IF(c.kit_end_target > c.transfer_out_target, c.transfer_out_target, c.kit_end_target), c.kit_start_target), c.receive_target), IF(c.receive_target > IF(c.kit_start_target > IF(c.kit_end_target > c.transfer_out_target, c.transfer_out_target, c.kit_end_target), IF(c.kit_end_target > c.transfer_out_target, c.transfer_out_target, c.kit_end_target), c.kit_start_target), IF(c.kit_start_target > IF(c.kit_end_target > c.transfer_out_target, c.transfer_out_target, c.kit_end_target), IF(c.kit_end_target > c.transfer_out_target, c.transfer_out_target, c.kit_end_target), c.kit_start_target), c.receive_target), c.vendor_target), c.purchase_target) AS purchase_target,
					c.component_purchase_actual,
					c.pcb_purchase_actual,
					IF(c.purchase_actual > IF(c.vendor_actual > IF(c.receive_actual > IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), c.receive_actual), IF(c.receive_actual > IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), c.receive_actual), c.vendor_actual), IF(c.vendor_actual > IF(c.receive_actual > IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), c.receive_actual), IF(c.receive_actual > IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), c.receive_actual), c.vendor_actual), c.purchase_actual) AS purchase_actual,
					-- Vendor OTD
					IF(c.vendor_target > IF(c.receive_target > IF(c.kit_start_target > IF(c.kit_end_target > c.transfer_out_target, c.transfer_out_target, c.kit_end_target), IF(c.kit_end_target > c.transfer_out_target, c.transfer_out_target, c.kit_end_target), c.kit_start_target), IF(c.kit_start_target > IF(c.kit_end_target > c.transfer_out_target, c.transfer_out_target, c.kit_end_target), IF(c.kit_end_target > c.transfer_out_target, c.transfer_out_target, c.kit_end_target), c.kit_start_target), c.receive_target), IF(c.receive_target > IF(c.kit_start_target > IF(c.kit_end_target > c.transfer_out_target, c.transfer_out_target, c.kit_end_target), IF(c.kit_end_target > c.transfer_out_target, c.transfer_out_target, c.kit_end_target), c.kit_start_target), IF(c.kit_start_target > IF(c.kit_end_target > c.transfer_out_target, c.transfer_out_target, c.kit_end_target), IF(c.kit_end_target > c.transfer_out_target, c.transfer_out_target, c.kit_end_target), c.kit_start_target), c.receive_target), c.vendor_target) AS vendor_target,
					IF(c.vendor_actual > IF(c.receive_actual > IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), c.receive_actual), IF(c.receive_actual > IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), c.receive_actual), c.vendor_actual) AS vendor_actual,
					-- Receive
					IF(c.receive_target > IF(c.kit_start_target > IF(c.kit_end_target > c.transfer_out_target, c.transfer_out_target, c.kit_end_target), IF(c.kit_end_target > c.transfer_out_target, c.transfer_out_target, c.kit_end_target), c.kit_start_target), IF(c.kit_start_target > IF(c.kit_end_target > c.transfer_out_target, c.transfer_out_target, c.kit_end_target), IF(c.kit_end_target > c.transfer_out_target, c.transfer_out_target, c.kit_end_target), c.kit_start_target), c.receive_target) AS receive_target,
					IF(c.receive_actual > IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), c.receive_actual) AS receive_actual,
					-- Kit
					IF(c.kit_start_target > IF(c.kit_end_target > c.transfer_out_target, c.transfer_out_target, c.kit_end_target), IF(c.kit_end_target > c.transfer_out_target, c.transfer_out_target, c.kit_end_target), c.kit_start_target) AS kit_start_target,
					IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual) AS kit_start_actual,
					IF(c.kit_end_target > c.transfer_out_target, c.transfer_out_target, c.kit_end_target) AS kit_end_target,
					IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual) AS kit_end_actual,
					-- Transfer out
					c.transfer_out_target,
					c.transfer_out_actual,
					-- Network Receive
					c.network_receive_target,
					c.network_receive_actual,
					-- Manufacture
					c.manufacture_start_target,
					c.manufacture_start_actual,
					c.manufacture_end_target,
					c.manufacture_end_actual,
					-- Transfer back
					c.transfer_back_target,
					c.transfer_back_actual,
					-- Quality
					c.qa_start_target,
					c.qa_start_actual,
					c.qa_end_target,
					c.qa_end_actual,
					-- Pack
					c.pack_start_target,
					c.pack_start_actual,
					c.pack_end_target,
					c.pack_end_actual,
					-- Shipping
					c.ship_target,
					c.ship_actual
				FROM (
					SELECT
						b.order_hash,
						b.order_batch_date,
						-- Plan
						b.plan_target,
						b.component_plan_actual,
						b.pcb_plan_actual,
						b.plan_actual,
						-- Purchase
						b.purchase_target,
						b.component_purchase_actual,
						b.pcb_purchase_actual,
						b.purchase_actual,
						-- Vendor OTD
						b.vendor_target,
						b.vendor_actual,
						-- Receive
						b.receive_target,
						b.receive_actual,
						-- Kit
						b.kit_start_target,
						b.kit_start_actual,
						b.kit_end_target,
						b.kit_end_actual,
						-- Transfer out
						IF(b.transfer_out_target > IF(b.network_receive_target > IF(b.manufacture_start_target > IF(b.manufacture_end_target > b.transfer_back_target, b.transfer_back_target, b.manufacture_end_target), IF(b.manufacture_end_target > b.transfer_back_target, b.transfer_back_target, b.manufacture_end_target), b.manufacture_start_target), IF(b.manufacture_start_target > IF(b.manufacture_end_target > b.transfer_back_target, b.transfer_back_target, b.manufacture_end_target), IF(b.manufacture_end_target > b.transfer_back_target, b.transfer_back_target, b.manufacture_end_target), b.manufacture_start_target), b.network_receive_target), IF(b.network_receive_target > IF(b.manufacture_start_target > IF(b.manufacture_end_target > b.transfer_back_target, b.transfer_back_target, b.manufacture_end_target), IF(b.manufacture_end_target > b.transfer_back_target, b.transfer_back_target, b.manufacture_end_target), b.manufacture_start_target), IF(b.manufacture_start_target > IF(b.manufacture_end_target > b.transfer_back_target, b.transfer_back_target, b.manufacture_end_target), IF(b.manufacture_end_target > b.transfer_back_target, b.transfer_back_target, b.manufacture_end_target), b.manufacture_start_target), b.network_receive_target), b.transfer_out_target) AS transfer_out_target,
						IF(b.transfer_out_actual > IF(b.network_receive_actual > IF(b.manufacture_start_actual > IF(b.manufacture_end_actual > b.transfer_back_actual, b.transfer_back_actual, b.manufacture_end_actual), IF(b.manufacture_end_actual > b.transfer_back_actual, b.transfer_back_actual, b.manufacture_end_actual), b.manufacture_start_actual), IF(b.manufacture_start_actual > IF(b.manufacture_end_actual > b.transfer_back_actual, b.transfer_back_actual, b.manufacture_end_actual), IF(b.manufacture_end_actual > b.transfer_back_actual, b.transfer_back_actual, b.manufacture_end_actual), b.manufacture_start_actual), b.network_receive_actual), IF(b.network_receive_actual > IF(b.manufacture_start_actual > IF(b.manufacture_end_actual > b.transfer_back_actual, b.transfer_back_actual, b.manufacture_end_actual), IF(b.manufacture_end_actual > b.transfer_back_actual, b.transfer_back_actual, b.manufacture_end_actual), b.manufacture_start_actual), IF(b.manufacture_start_actual > IF(b.manufacture_end_actual > b.transfer_back_actual, b.transfer_back_actual, b.manufacture_end_actual), IF(b.manufacture_end_actual > b.transfer_back_actual, b.transfer_back_actual, b.manufacture_end_actual), b.manufacture_start_actual), b.network_receive_actual), b.transfer_out_actual) AS transfer_out_actual,
						-- Network Receive
						IF(b.network_receive_target > IF(b.manufacture_start_target > IF(b.manufacture_end_target > b.transfer_back_target, b.transfer_back_target, b.manufacture_end_target), IF(b.manufacture_end_target > b.transfer_back_target, b.transfer_back_target, b.manufacture_end_target), b.manufacture_start_target), IF(b.manufacture_start_target > IF(b.manufacture_end_target > b.transfer_back_target, b.transfer_back_target, b.manufacture_end_target), IF(b.manufacture_end_target > b.transfer_back_target, b.transfer_back_target, b.manufacture_end_target), b.manufacture_start_target), b.network_receive_target) AS network_receive_target,
						IF(b.network_receive_actual > IF(b.manufacture_start_actual > IF(b.manufacture_end_actual > b.transfer_back_actual, b.transfer_back_actual, b.manufacture_end_actual), IF(b.manufacture_end_actual > b.transfer_back_actual, b.transfer_back_actual, b.manufacture_end_actual), b.manufacture_start_actual), IF(b.manufacture_start_actual > IF(b.manufacture_end_actual > b.transfer_back_actual, b.transfer_back_actual, b.manufacture_end_actual), IF(b.manufacture_end_actual > b.transfer_back_actual, b.transfer_back_actual, b.manufacture_end_actual), b.manufacture_start_actual), b.network_receive_actual) AS network_receive_actual,
						-- Manufacture
						IF(b.manufacture_start_target > IF(b.manufacture_end_target > b.transfer_back_target, b.transfer_back_target, b.manufacture_end_target), IF(b.manufacture_end_target > b.transfer_back_target, b.transfer_back_target, b.manufacture_end_target), b.manufacture_start_target) AS manufacture_start_target,
						IF(b.manufacture_start_actual > IF(b.manufacture_end_actual > b.transfer_back_actual, b.transfer_back_actual, b.manufacture_end_actual), IF(b.manufacture_end_actual > b.transfer_back_actual, b.transfer_back_actual, b.manufacture_end_actual), b.manufacture_start_actual) AS manufacture_start_actual,
						IF(b.manufacture_end_target > b.transfer_back_target, b.transfer_back_target, b.manufacture_end_target) AS manufacture_end_target,
						IF(b.manufacture_end_actual > b.transfer_back_actual, b.transfer_back_actual, b.manufacture_end_actual) AS manufacture_end_actual,
						-- Transfer back
						b.transfer_back_target,
						b.transfer_back_actual,
						-- Quality
						b.qa_start_target,
						b.qa_start_actual,
						b.qa_end_target,
						b.qa_end_actual,
						-- Pack
						b.pack_start_target,
						b.pack_start_actual,
						b.pack_end_target,
						b.pack_end_actual,
						-- Shipping
						b.ship_target,
						b.ship_actual
					FROM (
						SELECT
							a.order_hash,
							a.order_batch_date,
							-- Plan
							a.plan_target,
							a.component_plan_actual,
							a.pcb_plan_actual,
							GREATEST(a.component_plan_actual, a.pcb_plan_actual) AS plan_actual,
							-- Purchase
							a.purchase_target,
							a.component_purchase_actual,
							a.pcb_purchase_actual,
							GREATEST(a.component_purchase_actual, a.pcb_purchase_actual) AS purchase_actual,
							-- Vendor OTD
							a.vendor_target,
							a.vendor_actual,
							-- Receive
							a.receive_target,
							a.receive_actual,
							-- Kit
							a.kit_start_target,
							a.kit_start_actual,
							a.kit_end_target,
							a.kit_end_actual,
							-- Transfer out
							a.transfer_out_target,
							a.transfer_out_actual,
							-- Network Receive
							a.network_receive_target,
							a.network_receive_actual,
							-- Manufacture
							a.manufacture_start_target,
							a.manufacture_start_actual,
							a.manufacture_end_target,
							a.manufacture_end_actual,
							-- Transfer back
							IF(a.transfer_back_target > IF(a.qa_start_target > IF(a.qa_end_target > IF(a.pack_start_target > IF(a.pack_end_target > a.ship_target, a.ship_target, a.pack_end_target), IF(a.pack_end_target > a.ship_target, a.ship_target, a.pack_end_target), a.pack_start_target), IF(a.pack_start_target > IF(a.pack_end_target > a.ship_target, a.ship_target, a.pack_end_target), IF(a.pack_end_target > a.ship_target, a.ship_target, a.pack_end_target), a.pack_start_target), a.qa_end_target), IF(a.qa_end_target > IF(a.pack_start_target > IF(a.pack_end_target > a.ship_target, a.ship_target, a.pack_end_target), IF(a.pack_end_target > a.ship_target, a.ship_target, a.pack_end_target), a.pack_start_target), IF(a.pack_start_target > IF(a.pack_end_target > a.ship_target, a.ship_target, a.pack_end_target), IF(a.pack_end_target > a.ship_target, a.ship_target, a.pack_end_target), a.pack_start_target), a.qa_end_target), a.qa_start_target), IF(a.qa_start_target > IF(a.qa_end_target > IF(a.pack_start_target > IF(a.pack_end_target > a.ship_target, a.ship_target, a.pack_end_target), IF(a.pack_end_target > a.ship_target, a.ship_target, a.pack_end_target), a.pack_start_target), IF(a.pack_start_target > IF(a.pack_end_target > a.ship_target, a.ship_target, a.pack_end_target), IF(a.pack_end_target > a.ship_target, a.ship_target, a.pack_end_target), a.pack_start_target), a.qa_end_target), IF(a.qa_end_target > IF(a.pack_start_target > IF(a.pack_end_target > a.ship_target, a.ship_target, a.pack_end_target), IF(a.pack_end_target > a.ship_target, a.ship_target, a.pack_end_target), a.pack_start_target), IF(a.pack_start_target > IF(a.pack_end_target > a.ship_target, a.ship_target, a.pack_end_target), IF(a.pack_end_target > a.ship_target, a.ship_target, a.pack_end_target), a.pack_start_target), a.qa_end_target), a.qa_start_target), a.transfer_back_target) AS transfer_back_target,
							IF(a.transfer_back_actual > IF(a.qa_start_actual > IF(a.qa_end_actual > IF(a.pack_start_actual > IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), a.pack_start_actual), IF(a.pack_start_actual > IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), a.pack_start_actual), a.qa_end_actual), IF(a.qa_end_actual > IF(a.pack_start_actual > IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), a.pack_start_actual), IF(a.pack_start_actual > IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), a.pack_start_actual), a.qa_end_actual), a.qa_start_actual), IF(a.qa_start_actual > IF(a.qa_end_actual > IF(a.pack_start_actual > IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), a.pack_start_actual), IF(a.pack_start_actual > IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), a.pack_start_actual), a.qa_end_actual), IF(a.qa_end_actual > IF(a.pack_start_actual > IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), a.pack_start_actual), IF(a.pack_start_actual > IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), a.pack_start_actual), a.qa_end_actual), a.qa_start_actual), a.transfer_back_actual) AS transfer_back_actual,
							-- Quality
							IF(a.qa_start_target > IF(a.qa_end_target > IF(a.pack_start_target > IF(a.pack_end_target > a.ship_target, a.ship_target, a.pack_end_target), IF(a.pack_end_target > a.ship_target, a.ship_target, a.pack_end_target), a.pack_start_target), IF(a.pack_start_target > IF(a.pack_end_target > a.ship_target, a.ship_target, a.pack_end_target), IF(a.pack_end_target > a.ship_target, a.ship_target, a.pack_end_target), a.pack_start_target), a.qa_end_target), IF(a.qa_end_target > IF(a.pack_start_target > IF(a.pack_end_target > a.ship_target, a.ship_target, a.pack_end_target), IF(a.pack_end_target > a.ship_target, a.ship_target, a.pack_end_target), a.pack_start_target), IF(a.pack_start_target > IF(a.pack_end_target > a.ship_target, a.ship_target, a.pack_end_target), IF(a.pack_end_target > a.ship_target, a.ship_target, a.pack_end_target), a.pack_start_target), a.qa_end_target), a.qa_start_target) AS qa_start_target,
							IF(a.qa_start_actual > IF(a.qa_end_actual > IF(a.pack_start_actual > IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), a.pack_start_actual), IF(a.pack_start_actual > IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), a.pack_start_actual), a.qa_end_actual), IF(a.qa_end_actual > IF(a.pack_start_actual > IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), a.pack_start_actual), IF(a.pack_start_actual > IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), a.pack_start_actual), a.qa_end_actual), a.qa_start_actual) AS qa_start_actual,
							IF(a.qa_end_target > IF(a.pack_start_target > IF(a.pack_end_target > a.ship_target, a.ship_target, a.pack_end_target), IF(a.pack_end_target > a.ship_target, a.ship_target, a.pack_end_target), a.pack_start_target), IF(a.pack_start_target > IF(a.pack_end_target > a.ship_target, a.ship_target, a.pack_end_target), IF(a.pack_end_target > a.ship_target, a.ship_target, a.pack_end_target), a.pack_start_target), a.qa_end_target) AS qa_end_target,
							IF(a.qa_end_actual > IF(a.pack_start_actual > IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), a.pack_start_actual), IF(a.pack_start_actual > IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), a.pack_start_actual), a.qa_end_actual) AS qa_end_actual,
							-- Pack
							IF(a.pack_start_target > IF(a.pack_end_target > a.ship_target, a.ship_target, a.pack_end_target), IF(a.pack_end_target > a.ship_target, a.ship_target, a.pack_end_target), a.pack_start_target) AS pack_start_target,
							IF(a.pack_start_actual > IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), a.pack_start_actual) AS pack_start_actual,
							IF(a.pack_end_target > a.ship_target, a.ship_target, a.pack_end_target) AS pack_end_target,
							IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual) AS pack_end_actual,
							-- Shipping
							a.ship_target,
							a.ship_actual
						FROM (
							SELECT
								order_hash,
								order_batch_date,
								-- Plan
								plan_target,
								IFNULL(component_plan_actual, IFNULL(plan_actual, IFNULL(purchase_actual, IFNULL(vendor_actual, IFNULL(receive_actual, IFNULL(kit_start_actual, IFNULL(kit_end_actual, IFNULL(transfer_out_actual, IFNULL(network_receive_actual, IFNULL(manufacture_start_actual, IFNULL(manufacture_end_actual, IFNULL(transfer_back_actual, IFNULL(qa_start_actual, IFNULL(qa_end_actual, IFNULL(pack_start_actual, IFNULL(pack_end_actual, ship_actual)))))))))))))))) AS component_plan_actual,
								IFNULL(pcb_plan_actual, IFNULL(plan_actual, IFNULL(purchase_actual, IFNULL(vendor_actual, IFNULL(receive_actual, IFNULL(kit_start_actual, IFNULL(kit_end_actual, IFNULL(transfer_out_actual, IFNULL(network_receive_actual, IFNULL(manufacture_start_actual, IFNULL(manufacture_end_actual, IFNULL(transfer_back_actual, IFNULL(qa_start_actual, IFNULL(qa_end_actual, IFNULL(pack_start_actual, IFNULL(pack_end_actual, ship_actual)))))))))))))))) AS pcb_plan_actual,
								IFNULL(plan_actual, IFNULL(purchase_actual, IFNULL(vendor_actual, IFNULL(receive_actual, IFNULL(kit_start_actual, IFNULL(kit_end_actual, IFNULL(transfer_out_actual, IFNULL(network_receive_actual, IFNULL(manufacture_start_actual, IFNULL(manufacture_end_actual, IFNULL(transfer_back_actual, IFNULL(qa_start_actual, IFNULL(qa_end_actual, IFNULL(pack_start_actual, IFNULL(pack_end_actual, ship_actual))))))))))))))) AS plan_actual,
								-- Purchase
								purchase_target,
								IFNULL(component_purchase_actual, IFNULL(purchase_actual, IFNULL(vendor_actual, IFNULL(receive_actual, IFNULL(kit_start_actual, IFNULL(kit_end_actual, IFNULL(transfer_out_actual, IFNULL(network_receive_actual, IFNULL(manufacture_start_actual, IFNULL(manufacture_end_actual, IFNULL(transfer_back_actual, IFNULL(qa_start_actual, IFNULL(qa_end_actual, IFNULL(pack_start_actual, IFNULL(pack_end_actual, ship_actual))))))))))))))) AS component_purchase_actual,
								IFNULL(pcb_purchase_actual, IFNULL(purchase_actual, IFNULL(vendor_actual, IFNULL(receive_actual, IFNULL(kit_start_actual, IFNULL(kit_end_actual, IFNULL(transfer_out_actual, IFNULL(network_receive_actual, IFNULL(manufacture_start_actual, IFNULL(manufacture_end_actual, IFNULL(transfer_back_actual, IFNULL(qa_start_actual, IFNULL(qa_end_actual, IFNULL(pack_start_actual, IFNULL(pack_end_actual, ship_actual))))))))))))))) AS pcb_purchase_actual,
								IFNULL(purchase_actual, IFNULL(vendor_actual, IFNULL(receive_actual, IFNULL(kit_start_actual, IFNULL(kit_end_actual, IFNULL(transfer_out_actual, IFNULL(network_receive_actual, IFNULL(manufacture_start_actual, IFNULL(manufacture_end_actual, IFNULL(transfer_back_actual, IFNULL(qa_start_actual, IFNULL(qa_end_actual, IFNULL(pack_start_actual, IFNULL(pack_end_actual, ship_actual)))))))))))))) AS purchase_actual,
								-- Vendor
								IFNULL(vendor_target, purchase_target) AS vendor_target,
								IFNULL(vendor_actual, IFNULL(receive_actual, IFNULL(kit_start_actual, IFNULL(kit_end_actual, IFNULL(transfer_out_actual, IFNULL(network_receive_actual, IFNULL(manufacture_start_actual, IFNULL(manufacture_end_actual, IFNULL(transfer_back_actual, IFNULL(qa_start_actual, IFNULL(qa_end_actual, IFNULL(pack_start_actual, IFNULL(pack_end_actual, ship_actual))))))))))))) AS vendor_actual,
								-- Receive
								IFNULL(receive_target, IFNULL(vendor_target, purchase_target)) AS receive_target,
								IFNULL(receive_actual, IFNULL(kit_start_actual, IFNULL(kit_end_actual, IFNULL(transfer_out_actual, IFNULL(network_receive_actual, IFNULL(manufacture_start_actual, IFNULL(manufacture_end_actual, IFNULL(transfer_back_actual, IFNULL(qa_start_actual, IFNULL(qa_end_actual, IFNULL(pack_start_actual, IFNULL(pack_end_actual, ship_actual)))))))))))) AS receive_actual,
								-- Kit
								IFNULL(kit_start_target, IFNULL(receive_target, IFNULL(vendor_target, purchase_target))) AS kit_start_target, 
								IFNULL(kit_start_actual, IFNULL(kit_end_actual, IFNULL(transfer_out_actual, IFNULL(network_receive_actual, IFNULL(manufacture_start_actual, IFNULL(manufacture_end_actual, IFNULL(transfer_back_actual, IFNULL(qa_start_actual, IFNULL(qa_end_actual, IFNULL(pack_start_actual, IFNULL(pack_end_actual, ship_actual))))))))))) AS kit_start_actual,
								IFNULL(kit_end_target, IFNULL(kit_start_target, IFNULL(receive_target, IFNULL(vendor_target, purchase_target)))) AS kit_end_target, 
								IFNULL(kit_end_actual, IFNULL(transfer_out_actual, IFNULL(network_receive_actual, IFNULL(manufacture_start_actual, IFNULL(manufacture_end_actual, IFNULL(transfer_back_actual, IFNULL(qa_start_actual, IFNULL(qa_end_actual, IFNULL(pack_start_actual, IFNULL(pack_end_actual, ship_actual)))))))))) AS kit_end_actual,
								-- Transfer Out
								IFNULL(transfer_out_target, IFNULL(kit_end_target, IFNULL(kit_start_target, IFNULL(receive_target, IFNULL(vendor_target, purchase_target))))) AS transfer_out_target,
								IFNULL(transfer_out_actual, IFNULL(network_receive_actual, IFNULL(manufacture_start_actual, IFNULL(manufacture_end_actual, IFNULL(transfer_back_actual, IFNULL(qa_start_actual, IFNULL(qa_end_actual, IFNULL(pack_start_actual, IFNULL(pack_end_actual, ship_actual))))))))) AS transfer_out_actual,
								-- Network
								IFNULL(network_receive_target, IFNULL(transfer_out_target, IFNULL(kit_end_target, IFNULL(kit_start_target, IFNULL(receive_target, IFNULL(vendor_target, purchase_target)))))) AS network_receive_target,
								IFNULL(network_receive_actual, IFNULL(manufacture_start_actual, IFNULL(manufacture_end_actual, IFNULL(transfer_back_actual, IFNULL(qa_start_actual, IFNULL(qa_end_actual, IFNULL(pack_start_actual, IFNULL(pack_end_actual, ship_actual)))))))) AS network_receive_actual,
								-- Manufacture
								IFNULL(manufacture_start_target, IFNULL(network_receive_target, IFNULL(transfer_out_target, IFNULL(kit_end_target, IFNULL(kit_start_target, IFNULL(receive_target, IFNULL(vendor_target, purchase_target))))))) AS manufacture_start_target,
								IFNULL(manufacture_start_actual, IFNULL(manufacture_end_actual, IFNULL(transfer_back_actual, IFNULL(qa_start_actual, IFNULL(qa_end_actual, IFNULL(pack_start_actual, IFNULL(pack_end_actual, ship_actual))))))) AS manufacture_start_actual,
								IFNULL(manufacture_end_target, IFNULL(manufacture_start_target, IFNULL(network_receive_target, IFNULL(transfer_out_target, IFNULL(kit_end_target, IFNULL(kit_start_target, IFNULL(receive_target, IFNULL(vendor_target, purchase_target)))))))) AS manufacture_end_target,
								IFNULL(manufacture_end_actual, IFNULL(transfer_back_actual, IFNULL(qa_start_actual, IFNULL(qa_end_actual, IFNULL(pack_start_actual, IFNULL(pack_end_actual, ship_actual)))))) AS manufacture_end_actual,
								-- Transfer Back
								IFNULL(transfer_back_target, IFNULL(manufacture_end_target, IFNULL(manufacture_start_target, IFNULL(network_receive_target, IFNULL(transfer_out_target, IFNULL(kit_end_target, IFNULL(kit_start_target, IFNULL(receive_target, IFNULL(vendor_target, purchase_target))))))))) AS transfer_back_target,
								IFNULL(transfer_back_actual, IFNULL(qa_start_actual, IFNULL(qa_end_actual, IFNULL(pack_start_actual, IFNULL(pack_end_actual, ship_actual))))) AS transfer_back_actual,
								-- QA
								qa_start_target,
								IFNULL(qa_start_actual, IFNULL(qa_end_actual, IFNULL(pack_start_actual, IFNULL(pack_end_actual, ship_actual)))) AS qa_start_actual,
								qa_end_target,
								IFNULL(qa_end_actual, IFNULL(pack_start_actual, IFNULL(pack_end_actual, ship_actual))) AS qa_end_actual,
								-- Pack
								pack_start_target,
								IFNULL(pack_start_actual, IFNULL(pack_end_actual, ship_actual)) AS pack_start_actual,
								pack_end_target,
								IFNULL(pack_end_actual, ship_actual) AS pack_end_actual,
								-- Ship
								ship_target,
								ship_actual
							FROM (
								SELECT
									ooh.hash AS order_hash,
									rto.name AS customer_name,
									oo.sales_assisted,
									oo.tier,
									oo.invoice_total,
									oo.facility,
									IFNULL(cvo.automation_status, 'manual') AS automation_status,
									MIN(DATE(j.created)) AS order_batch_date,
									-- Plan
									MIN(DATE(j.created + INTERVAL 1 DAY)) AS plan_target,
									MAX(DATE(cvoi.created)) AS component_plan_actual,
									MAX(DATE(pvoi.created)) AS pcb_plan_actual,
									GREATEST(MAX(DATE(IFNULL(cvoi.created, pvoi.created))), MAX(DATE(IFNULL(pvoi.created, cvoi.created)))) AS plan_actual,
									-- Purchase
									MIN(DATE(j.created + INTERVAL 2 DAY)) AS purchase_target,
									MAX(DATE(cvo.submitted)) AS component_purchase_actual,
									MAX(DATE(pvo.submitted)) AS pcb_purchase_actual,
									GREATEST(MAX(DATE(IFNULL(cvo.submitted, pvo.submitted))), MAX(DATE(IFNULL(pvo.submitted, cvo.submitted)))) AS purchase_actual,
									-- Vendor OTD
									MIN(DATE(cvoi.dock_date)) AS vendor_target,
									MAX(DATE(cvo.received)) AS vendor_actual,
									-- Receive
									MIN(DATE(jks.kit_date - INTERVAL 1 DAY)) AS receive_target,
									GREATEST(MAX(DATE(cvo.received)), GREATEST(MAX(DATE(pvo.received)), MAX(DATE(js.start_date)))) AS receive_actual,
									-- Kit
									MIN(DATE(jks.kit_date - INTERVAL 1 DAY)) AS kit_start_target,
									MAX(DATE(rev.started_revision)) AS kit_start_actual,
									MIN(DATE(jks.kit_date)) AS kit_end_target,
									MAX(DATE(rev.ready_revision)) AS kit_end_actual,
									-- Transfer out
									GREATEST(MIN(DATE(js.start_date - INTERVAL 5 DAY)), MIN(DATE(jks.kit_date - INTERVAL 1 DAY))) AS transfer_out_target,
									MAX(DATE(jks.transferred)) AS transfer_out_actual,
									-- Network Receive
									GREATEST(MIN(DATE(js.start_date - INTERVAL 1 DAY)), GREATEST(MIN(DATE(js.start_date - INTERVAL 5 DAY)), MIN(DATE(jks.kit_date - INTERVAL 1 DAY)))) AS network_receive_target,
									MAX(DATE(jks.received)) AS network_receive_actual,
									-- Manufacture
									MIN(DATE(js.start_date)) AS manufacture_start_target,
									DATE(oe1.created) AS manufacture_start_actual,
									MIN(DATE(js.end_date)) AS manufacture_end_target,
									MAX(DATE(oqb.created_at)) AS manufacture_end_actual,
									-- Transfer back
									MIN(DATE(js.end_date + INTERVAL 1 DAY)) AS transfer_back_target,
									MAX(DATE(jsh.received)) AS transfer_back_actual,
									-- Quality
									(MIN(DATE(oo.committed_due_date - INTERVAL 1 DAY)) - INTERVAL 1 DAY ) - INTERVAL 1 DAY AS qa_start_target,
									MAX(DATE(oqb.created_at)) AS qa_start_actual,
									MIN(DATE(oo.committed_due_date - INTERVAL 1 DAY)) - INTERVAL 1 DAY AS qa_end_target,
									MAX(DATE(oqb.certified_at)) AS qa_end_actual,
									-- Pack
									MIN(DATE(oo.committed_due_date - INTERVAL 1 DAY)) AS pack_start_target,
									MAX(DATE(oe2.created)) AS pack_start_actual,
									LEAST(MIN(DATE(oo.committed_due_date - INTERVAL 1 DAY)) + INTERVAL 1 DAY, DATE(oo.committed_due_date)) AS pack_end_target,
									MAX(DATE(opl.date)) AS pack_end_actual,
									-- Shipping
									DATE(oo.committed_due_date) AS ship_target,
									DATE(oo.shipped) AS ship_actual,
									DATE(oo.committed_due_date) AS committed_due_date
								FROM orders.orders oo
								INNER JOIN orders.order_hashes ooh ON ooh.order_id = oo.order_id
								LEFT JOIN jobs.job_orders jo ON jo.order_id = oo.order_id
								LEFT JOIN jobs.jobs j ON j.jobid = jo.jobid
								LEFT JOIN orders.component_vendor_order_items cvoi ON cvoi.jobid = j.jobid
								LEFT JOIN orders.order_components ooc ON ooc.part_num = cvoi.manufacturer_partnum AND ooc.order_id = oo.order_id
								LEFT JOIN orders.component_vendor_order cvo ON cvo.vendor_orderid = cvoi.vendor_orderid
								LEFT JOIN orders.pcb_vendor_order_items pvoi ON pvoi.jobid = j.jobid
								LEFT JOIN orders.pcb_vendor_order pvo ON pvo.vendor_orderid = pvoi.vendor_orderid
								LEFT JOIN jobs.job_kit_status jks ON jks.job_id = j.jobid
								LEFT JOIN jobs.job_schedule js ON js.job_id = j.jobid
								LEFT JOIN orders.order_events oe1 ON oe1.order_id = oo.order_id AND oe1.event = 'orderProcessStart'
								LEFT JOIN orders.order_events oe2 ON oe2.order_id = oo.order_id AND oe2.event = 'orderPackaging'
								LEFT JOIN quality.order_quality_batch oqb ON oqb.order_id = oo.order_id
								LEFT JOIN retool.ops_pack_log opl ON opl.job_id = j.jobid
								LEFT JOIN orders.rt_organizations_list rto on rto.organization_id = oo.organization_id
								LEFT JOIN (
									SELECT
										a.job_id,
										MAX(CASE WHEN a.status = 'started' THEN a.at END) AS started_revision,
										MAX(CASE WHEN a.status = 'ready' THEN a.at END) AS ready_revision
									FROM jobs.job_kit_status_audit a
									WHERE a.status IN ('started', 'ready')
									GROUP BY a.job_id
								) rev
								ON rev.job_id = j.jobid
								LEFT JOIN (
									SELECT
										a.job_id,
										MIN(a.end_date) AS min_complete_revision
									FROM jobs.job_schedule_audit a
									WHERE a.status = 'complete'
									GROUP BY a.job_id
								) jsa
								ON jsa.job_id = j.jobid
								LEFT JOIN (
									SELECT
										jsh.job_id,
										MAX(jsh.received) AS received
									FROM jobs.job_shipments jsh
									GROUP BY jsh.job_id
								) jsh
								ON jsh.job_id = j.jobid
								WHERE
									j.created IS NOT NULL
								AND oo.shipped IS NOT NULL
								AND oo.shipped != '0000-00-00'
								AND oo.status = 'shipped'
								AND EXTRACT(YEAR FROM DATE(oo.shipped)) = {{ yearSelect.value }}
								AND ({{ !pmSelect.value }} OR {{ pmSelect.value }} = -1 OR oo.sales_assisted = {{ pmSelect.value }})
								GROUP BY
									ooh.hash
							) od
						) a
					) b
				) c
			) d
		) e
	) f
) g
GROUP BY g.shipped_month_str
ORDER BY g.shipped_date ASC
