SELECT		e.email_address,
			e.email_address REGEXP '^[A-Za-z0-9._%\-+!#$£&/=?^|~]+@[A-Za-z0-9.-]+[.][A-Za-z]+$' AS valid_email,
            SUBSTRING_INDEX(e.email_address, '@', 1) AS user_name,
            SUBSTRING_INDEX(e.email_address, '@', -1) AS domain_name,
            IFNULL(b.business_name, 'Not Matched') AS matched_client,
            CASE
				WHEN b.business_name IS NOT NULL AND e.email_address REGEXP '^[A-Za-z0-9._%\-+!#$£&/=?^|~]+@[A-Za-z0-9.-]+[.][A-Za-z]+$' = 1 THEN "Existing"
                WHEN b.business_name IS NULL AND e.email_address REGEXP '^[A-Za-z0-9._%\-+!#$£&/=?^|~]+@[A-Za-z0-9.-]+[.][A-Za-z]+$' = 1 THEN "Potential New Client"
                WHEN e.email_address REGEXP '^[A-Za-z0-9._%\-+!#$£&/=?^|~]+@[A-Za-z0-9.-]+[.][A-Za-z]+$' = 0 THEN "Invalid Email"
            END AS business_status
            
FROM		emails AS e
LEFT JOIN	business AS b
			ON b.business_domain = SUBSTRING_INDEX(e.email_address, '@', -1);