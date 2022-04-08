WITH RECURSIVE 
recent_months (date) AS
(                                                  
    #SELECT MAKEDATE(YEAR(CURDATE()) - 1, 1)  #1 full prior year + YTD i.e., 13 - 24 months depending on query execution date
    (SELECT MAKEDATE({{ start_year_selected.value }}, {{ start_day_selected.value }})) 
	UNION	                                       
	SELECT date + INTERVAL 1 MONTH
	FROM recent_months
	WHERE date + INTERVAL 1 MONTH <= (SELECT MAKEDATE({{ end_year_selected.value }}, {{ end_day_selected.value }})) 
),
time_series AS
(
	SELECT
		YEAR(date) AS yyyy,
        CONCAT(YEAR(date), '_Q', QUARTER(date)) AS yyyy_qq,
        UPPER(DATE_FORMAT(date, '%Y_%b')) AS yyyy_mmm
	FROM recent_months
),
ops_dates as
(
	SELECT
	    ops.*
	FROM time_series ts
	INNER JOIN (
	SELECT
		d.order_hash,
		d.ship_yyyy_mmm,
        d.ship_yyyy_qq,
		d.customer_name,
		d.sales_assisted,
		d.tier,
		d.invoice_total,
		d.facility,
		d.automation_status,
		d.order_batch_date,
        -- Plan
		d.plan_target,
		d.component_plan_actual,
		d.pcb_plan_actual,
		d.plan_actual,
		-- Purchase
		d.purchase_target,
		d.component_purchase_actual,
		d.pcb_purchase_actual,
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
		d. pack_end_target,
		d.pack_end_actual,
		-- Shipping
		d.ship_target,
		d.ship_actual,
        d.due_yyyy_mmm,
		d.due_yyyy_qq,
        approved_late_fees
	FROM (
		SELECT
			c.order_hash,
			c.ship_yyyy_mmm,
            c.ship_yyyy_qq,
			c.customer_name,
			c.sales_assisted,
			c.tier,
			c.invoice_total,
			c.facility,
			c.automation_status,
			c.order_batch_date,
			c.plan_target,
			c.component_plan_actual,
			c.pcb_plan_actual,
			IF(c.plan_actual > IF(c.purchase_actual > IF(c.vendor_actual > IF(c.receive_actual > IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), c.receive_actual), IF(c.receive_actual > IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), c.receive_actual), c.vendor_actual), IF(c.vendor_actual > IF(c.receive_actual > IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), c.receive_actual), IF(c.receive_actual > IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), c.receive_actual), c.vendor_actual), c.purchase_actual), IF(c.purchase_actual > IF(c.vendor_actual > IF(c.receive_actual > IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), c.receive_actual), IF(c.receive_actual > IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), c.receive_actual), c.vendor_actual), IF(c.vendor_actual > IF(c.receive_actual > IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), c.receive_actual), IF(c.receive_actual > IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), c.receive_actual), c.vendor_actual), c.purchase_actual), c.plan_actual) AS plan_actual,
			-- Purchase
			c.purchase_target,
			c.component_purchase_actual,
			c.pcb_purchase_actual,
			IF(c.purchase_actual > IF(c.vendor_actual > IF(c.receive_actual > IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), c.receive_actual), IF(c.receive_actual > IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), c.receive_actual), c.vendor_actual), IF(c.vendor_actual > IF(c.receive_actual > IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), c.receive_actual), IF(c.receive_actual > IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), c.receive_actual), c.vendor_actual), c.purchase_actual) AS purchase_actual,
			-- Vendor OTD
			c.vendor_target,
			IF(c.vendor_actual > IF(c.receive_actual > IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), c.receive_actual), IF(c.receive_actual > IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), c.receive_actual), c.vendor_actual) AS vendor_actual,
			-- Receive
			c.receive_target,
			IF(c.receive_actual > IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual), c.receive_actual) AS receive_actual,
			-- Kit
			c.kit_start_target,
			IF(c.kit_start_actual > IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), IF(c.kit_end_actual > c.transfer_out_actual, c.transfer_out_actual, c.kit_end_actual), c.kit_start_actual) AS kit_start_actual,
			c.kit_end_target,
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
			IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target) AS transfer_back_target,
			c.transfer_back_actual,
			-- Quality
			IF(c.qa_start_target < IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), c.qa_start_target) AS qa_start_target,
			c.qa_start_actual,
			IF(c.qa_end_target < IF(c.qa_start_target < IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), c.qa_start_target), IF(c.qa_start_target < IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), c.qa_start_target), c.qa_end_target) AS qa_end_target,
			c.qa_end_actual,
			-- Pack
			IF(c.pack_start_target < IF(c.qa_end_target < IF(c.qa_start_target < IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), c.qa_start_target), IF(c.qa_start_target < IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), c.qa_start_target), c.qa_end_target), IF(c.qa_end_target < IF(c.qa_start_target < IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), c.qa_start_target), IF(c.qa_start_target < IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), c.qa_start_target), c.qa_end_target), c.pack_start_target) AS pack_start_target,
			c.pack_start_actual,
			IF(c.pack_end_target < IF(c.pack_start_target < IF(c.qa_end_target < IF(c.qa_start_target < IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), c.qa_start_target), IF(c.qa_start_target < IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), c.qa_start_target), c.qa_end_target), IF(c.qa_end_target < IF(c.qa_start_target < IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), c.qa_start_target), IF(c.qa_start_target < IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), c.qa_start_target), c.qa_end_target), c.pack_start_target), IF(c.pack_start_target < IF(c.qa_end_target < IF(c.qa_start_target < IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), c.qa_start_target), IF(c.qa_start_target < IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), c.qa_start_target), c.qa_end_target), IF(c.qa_end_target < IF(c.qa_start_target < IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), c.qa_start_target), IF(c.qa_start_target < IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), c.qa_start_target), c.qa_end_target), c.pack_start_target), c.pack_end_target) AS pack_end_target,
			c.pack_end_actual,
			-- Shipping
			#IF(c.ship_target < IF(c.pack_end_target < IF(c.pack_start_target < IF(c.qa_end_target < IF(c.qa_start_target < IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), c.qa_start_target), IF(c.qa_start_target < IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), c.qa_start_target), c.qa_end_target), IF(c.qa_end_target < IF(c.qa_start_target < IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), c.qa_start_target), IF(c.qa_start_target < IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), c.qa_start_target), c.qa_end_target), c.pack_start_target), IF(c.pack_start_target < IF(c.qa_end_target < IF(c.qa_start_target < IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), c.qa_start_target), IF(c.qa_start_target < IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), c.qa_start_target), c.qa_end_target), IF(c.qa_end_target < IF(c.qa_start_target < IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), c.qa_start_target), IF(c.qa_start_target < IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), c.qa_start_target), c.qa_end_target), c.pack_start_target), c.pack_end_target), IF(c.pack_end_target < IF(c.pack_start_target < IF(c.qa_end_target < IF(c.qa_start_target < IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), c.qa_start_target), IF(c.qa_start_target < IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), c.qa_start_target), c.qa_end_target), IF(c.qa_end_target < IF(c.qa_start_target < IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), c.qa_start_target), IF(c.qa_start_target < IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), c.qa_start_target), c.qa_end_target), c.pack_start_target), IF(c.pack_start_target < IF(c.qa_end_target < IF(c.qa_start_target < IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), c.qa_start_target), IF(c.qa_start_target < IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), c.qa_start_target), c.qa_end_target), IF(c.qa_end_target < IF(c.qa_start_target < IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), c.qa_start_target), IF(c.qa_start_target < IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), IF(c.transfer_back_target < c.manufacture_end_target, c.manufacture_end_target, c.transfer_back_target), c.qa_start_target), c.qa_end_target), c.pack_start_target), c.pack_end_target), c.ship_target) AS ship_target,
			c.ship_target,
            c.ship_actual,
			c.committed_due_date,
            c.due_yyyy_mmm,
			c.due_yyyy_qq,
            approved_late_fees
		FROM (
			SELECT
				b.order_hash,
				b.ship_yyyy_mmm,
                b.ship_yyyy_qq,
				b.customer_name,
				b.sales_assisted,
				b.tier,
				b.invoice_total,
				b.facility,
				b.automation_status,
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
				IF(b.transfer_out_target < b.kit_end_target, b.kit_end_target, b.transfer_out_target) AS transfer_out_target,
				IF(b.transfer_out_actual > IF(b.network_receive_actual > IF(b.manufacture_start_actual > IF(b.manufacture_end_actual > b.transfer_back_actual, b.transfer_back_actual, b.manufacture_end_actual), IF(b.manufacture_end_actual > b.transfer_back_actual, b.transfer_back_actual, b.manufacture_end_actual), b.manufacture_start_actual), IF(b.manufacture_start_actual > IF(b.manufacture_end_actual > b.transfer_back_actual, b.transfer_back_actual, b.manufacture_end_actual), IF(b.manufacture_end_actual > b.transfer_back_actual, b.transfer_back_actual, b.manufacture_end_actual), b.manufacture_start_actual), b.network_receive_actual), IF(b.network_receive_actual > IF(b.manufacture_start_actual > IF(b.manufacture_end_actual > b.transfer_back_actual, b.transfer_back_actual, b.manufacture_end_actual), IF(b.manufacture_end_actual > b.transfer_back_actual, b.transfer_back_actual, b.manufacture_end_actual), b.manufacture_start_actual), IF(b.manufacture_start_actual > IF(b.manufacture_end_actual > b.transfer_back_actual, b.transfer_back_actual, b.manufacture_end_actual), IF(b.manufacture_end_actual > b.transfer_back_actual, b.transfer_back_actual, b.manufacture_end_actual), b.manufacture_start_actual), b.network_receive_actual), b.transfer_out_actual) AS transfer_out_actual,
				-- Network Receive
				IF(b.network_receive_target < IF(b.transfer_out_target < b.kit_end_target, b.kit_end_target, b.transfer_out_target), IF(b.transfer_out_target < b.kit_end_target, b.kit_end_target, b.transfer_out_target), b.network_receive_target) AS network_receive_target,
				IF(b.network_receive_actual > IF(b.manufacture_start_actual > IF(b.manufacture_end_actual > b.transfer_back_actual, b.transfer_back_actual, b.manufacture_end_actual), IF(b.manufacture_end_actual > b.transfer_back_actual, b.transfer_back_actual, b.manufacture_end_actual), b.manufacture_start_actual), IF(b.manufacture_start_actual > IF(b.manufacture_end_actual > b.transfer_back_actual, b.transfer_back_actual, b.manufacture_end_actual), IF(b.manufacture_end_actual > b.transfer_back_actual, b.transfer_back_actual, b.manufacture_end_actual), b.manufacture_start_actual), b.network_receive_actual) AS network_receive_actual,
				-- Manufacture
				IF(b.manufacture_start_target < IF(b.network_receive_target < IF(b.transfer_out_target < b.kit_end_target, b.kit_end_target, b.transfer_out_target), IF(b.transfer_out_target < b.kit_end_target, b.kit_end_target, b.transfer_out_target), b.network_receive_target), IF(b.network_receive_target < IF(b.transfer_out_target < b.kit_end_target, b.kit_end_target, b.transfer_out_target), IF(b.transfer_out_target < b.kit_end_target, b.kit_end_target, b.transfer_out_target), b.network_receive_target), b.manufacture_start_target) AS manufacture_start_target,
				IF(b.manufacture_start_actual > IF(b.manufacture_end_actual > b.transfer_back_actual, b.transfer_back_actual, b.manufacture_end_actual), IF(b.manufacture_end_actual > b.transfer_back_actual, b.transfer_back_actual, b.manufacture_end_actual), b.manufacture_start_actual) AS manufacture_start_actual,
				IF(b.manufacture_end_target < IF(b.manufacture_start_target < IF(b.network_receive_target < IF(b.transfer_out_target < b.kit_end_target, b.kit_end_target, b.transfer_out_target), IF(b.transfer_out_target < b.kit_end_target, b.kit_end_target, b.transfer_out_target), b.network_receive_target), IF(b.network_receive_target < IF(b.transfer_out_target < b.kit_end_target, b.kit_end_target, b.transfer_out_target), IF(b.transfer_out_target < b.kit_end_target, b.kit_end_target, b.transfer_out_target), b.network_receive_target), b.manufacture_start_target), IF(b.manufacture_start_target < IF(b.network_receive_target < IF(b.transfer_out_target < b.kit_end_target, b.kit_end_target, b.transfer_out_target), IF(b.transfer_out_target < b.kit_end_target, b.kit_end_target, b.transfer_out_target), b.network_receive_target), IF(b.network_receive_target < IF(b.transfer_out_target < b.kit_end_target, b.kit_end_target, b.transfer_out_target), IF(b.transfer_out_target < b.kit_end_target, b.kit_end_target, b.transfer_out_target), b.network_receive_target), b.manufacture_start_target), b.manufacture_end_target) AS manufacture_end_target,
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
				b.ship_actual,
				b.committed_due_date,
                b.due_yyyy_mmm,
				b.due_yyyy_qq,
                approved_late_fees
			FROM (
				SELECT
					a.order_hash,
					a.ship_yyyy_mmm,
                    a.ship_yyyy_qq,
					a.customer_name,
					a.sales_assisted,
					a.tier,
					a.invoice_total,
					a.facility,
					a.automation_status,
					a.order_batch_date,
					-- Plan
					a.plan_target,
					a.component_plan_actual,
					a.pcb_plan_actual,
					a.plan_actual,
					-- Purchase
					IF(a.purchase_target < a.plan_target, a.plan_target, a.purchase_target) AS purchase_target,
					a.component_purchase_actual,
					a.pcb_purchase_actual,
					GREATEST(a.component_purchase_actual, a.pcb_purchase_actual) AS purchase_actual,
					-- Vendor OTD
					IF(a.vendor_target < IF(a.purchase_target < a.plan_target, a.plan_target, a.purchase_target), IF(a.purchase_target < a.plan_target, a.plan_target, a.purchase_target), a.vendor_target) AS vendor_target,
					a.vendor_actual,
					-- Receive
					IF(a.receive_target < IF(a.vendor_target < IF(a.purchase_target < a.plan_target, a.plan_target, a.purchase_target), IF(a.purchase_target < a.plan_target, a.plan_target, a.purchase_target), a.vendor_target), IF(a.vendor_target < IF(a.purchase_target < a.plan_target, a.plan_target, a.purchase_target), IF(a.purchase_target < a.plan_target, a.plan_target, a.purchase_target), a.vendor_target), a.receive_target) AS receive_target,
					a.receive_actual,
					-- Kit
					IF(a.kit_start_target < IF(a.receive_target < IF(a.vendor_target < IF(a.purchase_target < a.plan_target, a.plan_target, a.purchase_target), IF(a.purchase_target < a.plan_target, a.plan_target, a.purchase_target), a.vendor_target), IF(a.vendor_target < IF(a.purchase_target < a.plan_target, a.plan_target, a.purchase_target), IF(a.purchase_target < a.plan_target, a.plan_target, a.purchase_target), a.vendor_target), a.receive_target), IF(a.receive_target < IF(a.vendor_target < IF(a.purchase_target < a.plan_target, a.plan_target, a.purchase_target), IF(a.purchase_target < a.plan_target, a.plan_target, a.purchase_target), a.vendor_target), IF(a.vendor_target < IF(a.purchase_target < a.plan_target, a.plan_target, a.purchase_target), IF(a.purchase_target < a.plan_target, a.plan_target, a.purchase_target), a.vendor_target), a.receive_target), a.kit_start_target) AS kit_start_target,
					a.kit_start_actual,
					IF(a.kit_end_target < IF(a.kit_start_target < IF(a.receive_target < IF(a.vendor_target < IF(a.purchase_target < a.plan_target, a.plan_target, a.purchase_target), IF(a.purchase_target < a.plan_target, a.plan_target, a.purchase_target), a.vendor_target), IF(a.vendor_target < IF(a.purchase_target < a.plan_target, a.plan_target, a.purchase_target), IF(a.purchase_target < a.plan_target, a.plan_target, a.purchase_target), a.vendor_target), a.receive_target), IF(a.receive_target < IF(a.vendor_target < IF(a.purchase_target < a.plan_target, a.plan_target, a.purchase_target), IF(a.purchase_target < a.plan_target, a.plan_target, a.purchase_target), a.vendor_target), IF(a.vendor_target < IF(a.purchase_target < a.plan_target, a.plan_target, a.purchase_target), IF(a.purchase_target < a.plan_target, a.plan_target, a.purchase_target), a.vendor_target), a.receive_target), a.kit_start_target), IF(a.kit_start_target < IF(a.receive_target < IF(a.vendor_target < IF(a.purchase_target < a.plan_target, a.plan_target, a.purchase_target), IF(a.purchase_target < a.plan_target, a.plan_target, a.purchase_target), a.vendor_target), IF(a.vendor_target < IF(a.purchase_target < a.plan_target, a.plan_target, a.purchase_target), IF(a.purchase_target < a.plan_target, a.plan_target, a.purchase_target), a.vendor_target), a.receive_target), IF(a.receive_target < IF(a.vendor_target < IF(a.purchase_target < a.plan_target, a.plan_target, a.purchase_target), IF(a.purchase_target < a.plan_target, a.plan_target, a.purchase_target), a.vendor_target), IF(a.vendor_target < IF(a.purchase_target < a.plan_target, a.plan_target, a.purchase_target), IF(a.purchase_target < a.plan_target, a.plan_target, a.purchase_target), a.vendor_target), a.receive_target), a.kit_start_target), a.kit_end_target) AS kit_end_target,
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
					a.transfer_back_target,
					IF(a.transfer_back_actual > IF(a.qa_start_actual > IF(a.qa_end_actual > IF(a.pack_start_actual > IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), a.pack_start_actual), IF(a.pack_start_actual > IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), a.pack_start_actual), a.qa_end_actual), IF(a.qa_end_actual > IF(a.pack_start_actual > IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), a.pack_start_actual), IF(a.pack_start_actual > IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), a.pack_start_actual), a.qa_end_actual), a.qa_start_actual), IF(a.qa_start_actual > IF(a.qa_end_actual > IF(a.pack_start_actual > IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), a.pack_start_actual), IF(a.pack_start_actual > IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), a.pack_start_actual), a.qa_end_actual), IF(a.qa_end_actual > IF(a.pack_start_actual > IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), a.pack_start_actual), IF(a.pack_start_actual > IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), a.pack_start_actual), a.qa_end_actual), a.qa_start_actual), a.transfer_back_actual) AS transfer_back_actual,
					-- Quality
					a.qa_start_target,
					IF(a.qa_start_actual > IF(a.qa_end_actual > IF(a.pack_start_actual > IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), a.pack_start_actual), IF(a.pack_start_actual > IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), a.pack_start_actual), a.qa_end_actual), IF(a.qa_end_actual > IF(a.pack_start_actual > IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), a.pack_start_actual), IF(a.pack_start_actual > IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), a.pack_start_actual), a.qa_end_actual), a.qa_start_actual) AS qa_start_actual,
					a.qa_end_target,
					IF(a.qa_end_actual > IF(a.pack_start_actual > IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), a.pack_start_actual), IF(a.pack_start_actual > IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), a.pack_start_actual), a.qa_end_actual) AS qa_end_actual,
					-- Pack
					a.pack_start_target,
					IF(a.pack_start_actual > IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual), a.pack_start_actual) AS pack_start_actual,
					a.pack_end_target,
					IF(a.pack_end_actual > a.ship_actual, a.ship_actual, a.pack_end_actual) AS pack_end_actual,
					-- Shipping
					a.ship_target,
					a.ship_actual,
					a.committed_due_date,
                    a.due_yyyy_mmm,
                    a.due_yyyy_qq,
                    approved_late_fees
				FROM (
					SELECT
						order_hash,
						UPPER(DATE_FORMAT(ship_actual, '%Y_%b')) AS ship_yyyy_mmm,
                        CONCAT(YEAR(ship_actual), '_Q', QUARTER(ship_actual)) AS ship_yyyy_qq,
						customer_name,
						sales_assisted,
						tier,
						invoice_total,
						facility,
						automation_status,
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
						ship_actual,
						committed_due_date,
                        UPPER(DATE_FORMAT(committed_due_date, '%Y_%b')) AS due_yyyy_mmm,
                        CONCAT(YEAR(committed_due_date), '_Q', QUARTER(committed_due_date)) AS due_yyyy_qq,
                        IFNULL(approved_late_fees,0) AS approved_late_fees
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
							GREATEST(MAX(DATE(IFNULL(cvoi.created,pvoi.created))), MAX(DATE(IFNULL(pvoi.created,cvoi.created)))) AS plan_actual,
							-- Purchase
							MIN(DATE(j.created + INTERVAL 2 DAY)) AS purchase_target,
							MAX(DATE(cvo.submitted)) AS component_purchase_actual,
							MAX(DATE(pvo.submitted)) AS pcb_purchase_actual,
							GREATEST(MAX(DATE(IFNULL(cvo.submitted,pvo.submitted))), MAX(DATE(IFNULL(pvo.submitted,cvo.submitted)))) AS purchase_actual,
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
							DATE(oo.committed_due_date) AS committed_due_date,
							cr.amount AS approved_late_fees
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
						LEFT JOIN (
							SELECT
							    r.order_id,
								SUM(r.amount) AS amount
							FROM retool.cs_credits_refunds r
							WHERE r.reason = 'LATE ORDER'
							AND r.approved = 1
							GROUP BY r.order_id
						) cr ON cr.order_id = oo.order_id
						WHERE
							{{segDateDueVsShipped.value == 'ship' }} AND (
								j.created IS NOT NULL
								AND oo.shipped IS NOT NULL
								AND oo.shipped != '0000-00-00'
								AND oo.status = 'shipped'
								#AND DATE(oo.shipped) >= (SELECT MAKEDATE(2021, 1))
								#AND DATE(oo.shipped) < (SELECT MAKEDATE(2022, 1))
                                AND DATE(oo.shipped) >= (SELECT MAKEDATE({{ start_year_selected.value }}, {{ start_day_selected.value }}))
								AND DATE(oo.shipped) <= (SELECT MAKEDATE({{ end_year_selected.value }}, {{ end_day_selected.value }}))
							)
							OR {{segDateDueVsShipped.value == 'due' }} AND (
								oo.committed_due_date IS NOT NULL
								AND oo.committed_due_date != '0000-00-00'
								#AND DATE(oo.committed_due_date) >= (SELECT MAKEDATE(2021, 1))
								#AND DATE(oo.committed_due_date) < (SELECT MAKEDATE(2022, 1))
								AND DATE(oo.committed_due_date) >= (SELECT MAKEDATE({{ start_year_selected.value }}, {{ start_day_selected.value }}))
								AND DATE(oo.committed_due_date) <= (SELECT MAKEDATE({{ end_year_selected.value }}, {{ end_day_selected.value }}))
							)
						GROUP BY
							ooh.hash
					) od
				) a
			) b
		) c
	) d
) ops
    ON 		#ops.ship_yyyy_qq = ts.yyyy_qq AND ops.ship_yyyy_mmm = ts.yyyy_mmm
			({{segDateDueVsShipped.value == 'ship' }} AND (ops.ship_yyyy_qq = ts.yyyy_qq AND ops.ship_yyyy_mmm = ts.yyyy_mmm)) OR
		 	({{segDateDueVsShipped.value == 'due' }} AND (ops.due_yyyy_qq = ts.yyyy_qq AND ops.due_yyyy_mmm = ts.yyyy_mmm))
ORDER BY
  	CASE {{segDateDueVsShipped.value}} WHEN 'due' THEN ops.ship_target
  	ELSE ops.ship_actual END
  ASC
),
ops_metrics AS
(
 SELECT
		ops_dates.*,
		DATEDIFF(kit_start_actual, kit_start_target) AS kit_start_variance,
		DATEDIFF(manufacture_start_actual, manufacture_start_target) AS manufacture_start_variance,
		DATEDIFF(qa_start_actual, qa_start_target) AS qa_start_variance,
		DATEDIFF(pack_start_actual, pack_start_target) AS pack_start_variance,
		DATEDIFF(pcb_plan_actual, plan_target) AS pcb_plan_variance,
		DATEDIFF(component_plan_actual, plan_target) AS component_plan_variance,
		DATEDIFF(plan_actual, plan_target) AS plan_variance,
		DATEDIFF(pcb_purchase_actual, purchase_target) AS pcb_purchase_variance,
		DATEDIFF(component_purchase_actual, purchase_target) AS component_purchase_variance,
		DATEDIFF(purchase_actual, purchase_target) AS purchase_variance,
		DATEDIFF(vendor_actual, vendor_target) AS vendor_variance,
		DATEDIFF(receive_actual, receive_target) AS receive_variance,
		DATEDIFF(kit_end_actual, kit_end_target) AS kit_end_variance,
		DATEDIFF(transfer_out_actual, transfer_out_target) AS transfer_out_variance,
		DATEDIFF(network_receive_actual, network_receive_target) AS network_receive_variance,
		DATEDIFF(manufacture_end_actual, manufacture_end_target) AS manufacture_end_variance,
		DATEDIFF(transfer_back_actual, transfer_back_target) AS transfer_back_variance,
		DATEDIFF(qa_end_actual, qa_end_target) AS qa_end_variance,
		DATEDIFF(pack_end_actual, pack_end_target) AS pack_end_variance,
		DATEDIFF(ship_actual, ship_target) AS ship_variance,
		DATEDIFF(plan_target, order_batch_date) AS pcb_plan_duration_target,
		DATEDIFF(plan_target, order_batch_date) AS component_plan_duration_target,
		DATEDIFF(plan_target, order_batch_date) AS plan_duration_target,
		DATEDIFF(purchase_target, plan_target) AS pcb_purchase_duration_target,
		DATEDIFF(purchase_target, plan_target) AS component_purchase_duration_target,
		DATEDIFF(purchase_target, plan_target) AS purchase_duration_target,
		DATEDIFF(vendor_target, purchase_target) AS vendor_duration_target,
		DATEDIFF(receive_target, purchase_target) AS receive_duration_target,
		DATEDIFF(kit_start_target, receive_target) AS kit_wait_to_start_duration_target,
		DATEDIFF(kit_end_target, kit_start_target) AS kit_duration_target,
		DATEDIFF(transfer_out_target, kit_end_target) AS transfer_out_duration_target,
		DATEDIFF(network_receive_target, transfer_out_target) AS network_receive_duration_target,
		DATEDIFF(manufacture_start_target, network_receive_target) AS manufacture_wait_to_start_duration_target,
		DATEDIFF(manufacture_end_target, manufacture_start_target) AS manufacture_duration_target,
		DATEDIFF(transfer_back_target, manufacture_end_target) AS transfer_back_duration_target,
		DATEDIFF(qa_start_target, transfer_back_target) AS qa_wait_to_start_duration_target,
		DATEDIFF(qa_end_target, qa_start_target) AS qa_duration_target,
		DATEDIFF(pack_start_target, qa_end_target) AS pack_wait_to_start_duration_target,
		DATEDIFF(pack_end_target, pack_start_target) AS pack_duration_target,
		DATEDIFF(ship_target, pack_end_target) AS ship_duration_target,
		DATEDIFF(ship_target, order_batch_date) AS ship_tts_target,
		DATEDIFF(pcb_plan_actual, order_batch_date) AS pcb_plan_duration_actual,
		DATEDIFF(component_plan_actual, order_batch_date) AS component_plan_duration_actual,
		DATEDIFF(plan_actual, order_batch_date) AS plan_duration_actual,
		DATEDIFF(pcb_purchase_actual, plan_actual) AS pcb_purchase_duration_actual,
		DATEDIFF(component_plan_actual, plan_actual) AS component_purchase_duration_actual,
		DATEDIFF(purchase_actual, plan_actual) AS purchase_duration_actual,
		DATEDIFF(vendor_actual, purchase_actual) AS vendor_duration_actual,
		DATEDIFF(receive_actual, purchase_actual) AS receive_duration_actual,
		DATEDIFF(kit_start_actual, receive_actual) AS kit_wait_to_start_duration_actual,
		DATEDIFF(kit_end_actual, kit_start_actual) AS kit_duration_actual,
		DATEDIFF(transfer_out_actual, kit_end_actual) AS transfer_out_duration_actual,
		DATEDIFF(network_receive_actual, transfer_out_actual) AS network_receive_duration_actual,
		DATEDIFF(manufacture_start_actual, network_receive_actual) AS manufacture_wait_to_start_duration_actual,
		DATEDIFF(manufacture_end_actual, manufacture_start_actual) AS manufacture_duration_actual,
		DATEDIFF(transfer_back_actual, manufacture_end_actual) AS transfer_back_duration_actual,
		DATEDIFF(qa_start_actual, transfer_back_actual) AS qa_wait_to_start_duration_actual,
		DATEDIFF(qa_end_actual, qa_start_actual) AS qa_duration_actual,
		DATEDIFF(pack_start_actual, qa_end_actual) AS pack_wait_to_start_duration_actual,
		DATEDIFF(pack_end_actual, pack_start_actual) AS pack_duration_actual,
		DATEDIFF(ship_actual, pack_end_actual) AS ship_duration_actual,
		DATEDIFF(ship_actual, order_batch_date) AS ship_tts_actual
FROM
		ops_dates
),
ops_variance AS
(
 SELECT
		ops_metrics.*,
		kit_start_variance <= 0 AS kit_start_ontime,
		manufacture_start_variance <= 0 AS manufacture_start_ontime,
		qa_start_variance <= 0 AS qa_start_ontime,
		pack_start_variance <= 0 AS pack_start_ontime,
		kit_start_variance > 0 AS kit_start_late,
		manufacture_start_variance > 0 AS manufacture_start_late,
		qa_start_variance > 0 AS qa_start_late,
		pack_start_variance > 0 AS pack_start_late,
		pcb_plan_variance <=0 AS pcb_plan_ontime,
		component_plan_variance <=0 AS component_plan_ontime,
		plan_variance <=0 AS plan_ontime,
		pcb_purchase_variance <=0 AS pcb_purchase_ontime,
		component_purchase_variance <=0 AS component_purchase_ontime,
		purchase_variance <=0 AS purchase_ontime,
		vendor_variance <=0 AS vendor_ontime,
		receive_variance <=0 AS receive_ontime,
		kit_end_variance <=0 AS kit_end_ontime,
		transfer_out_variance <=0 AS transfer_out_ontime,
		network_receive_variance <=0 AS network_receive_ontime,
		manufacture_end_variance <=0 AS manufacture_end_ontime,
		transfer_back_variance <=0 AS transfer_back_ontime,
		qa_end_variance <=0 AS qa_end_ontime,
		pack_end_variance <=0 AS pack_end_ontime,
		ship_variance <=0 AS ship_ontime,
		pcb_plan_variance >0 AS pcb_plan_late,
		component_plan_variance >0 AS component_plan_late,
		plan_variance >0 AS plan_late,
		pcb_purchase_variance >0 AS pcb_purchase_late,
		component_purchase_variance >0 AS component_purchase_late,
		purchase_variance >0 AS purchase_late,
		vendor_variance >0 AS vendor_late,
		receive_variance >0 AS receive_late,
		kit_end_variance >0 AS kit_end_late,
		transfer_out_variance >0 AS transfer_out_late,
		network_receive_variance >0 AS network_receive_late,
		manufacture_end_variance >0 AS manufacture_end_late,
		transfer_back_variance >0 AS transfer_back_late,
		qa_end_variance >0 AS qa_end_late,
		pack_end_variance >0 AS pack_end_late,
		ship_variance >0 AS ship_late,
		pcb_plan_duration_actual - pcb_plan_duration_target AS pcb_plan_duration_variance,
		component_plan_duration_actual - component_plan_duration_target AS component_plan_duration_variance,
		plan_duration_actual - plan_duration_target AS plan_duration_variance,
		pcb_purchase_duration_actual - pcb_purchase_duration_target AS pcb_purchase_duration_variance,
		component_purchase_duration_actual - component_purchase_duration_target AS component_purchase_duration_variance,
		purchase_duration_actual - purchase_duration_target AS purchase_duration_variance,
		vendor_duration_actual - vendor_duration_target AS vendor_duration_variance,
		receive_duration_actual - receive_duration_target AS receive_duration_variance,
		kit_wait_to_start_duration_actual - kit_wait_to_start_duration_target AS kit_wait_to_start_duration_variance,
		kit_duration_actual - kit_duration_target AS kit_duration_duration_variance,
		transfer_out_duration_actual - transfer_out_duration_target AS transfer_out_duration_variance,
		network_receive_duration_actual - network_receive_duration_target AS network_receive_duration_variance,
		manufacture_wait_to_start_duration_actual - manufacture_wait_to_start_duration_target AS manufacture_wait_to_start_duration_variance,
		manufacture_duration_actual - manufacture_duration_target AS manufacture_duration_variance,
		transfer_back_duration_actual - transfer_back_duration_target AS transfer_back_duration_variance,
		qa_wait_to_start_duration_actual - qa_wait_to_start_duration_target AS qa_wait_to_start_duration_variance,
		qa_duration_actual - qa_duration_target AS qa_duration_variance,
		pack_wait_to_start_duration_actual - pack_wait_to_start_duration_target AS pack_wait_to_start_duration_variance,
		pack_duration_actual - pack_duration_target AS pack_duration_variance,
		ship_duration_actual - ship_duration_target AS ship_duration_variance,
		ship_tts_actual - ship_tts_target AS ship_tts_variance
FROM 
		ops_metrics
)
SELECT * FROM ops_variance;