WITH clean_data
AS
(
	SELECT		currency_as_text,
				REPLACE(REPLACE(currency_as_text, '£', ''),',', '') AS no_symbol,
                LOWER(
					REPLACE(
						REPLACE(
							REPLACE(
								REPLACE(
									REPLACE(
										REPLACE(
											REPLACE(
										REPLACE(
									REPLACE(
								REPLACE(
							REPLACE(
						REPLACE(
					REPLACE(currency_as_text, 
						'£', ''),
							',', ''),
								'9', ''),
									'8', ''),
										'7', ''),
											'6', ''),
												'5', ''),
											'4', ''),
										'3', ''),
									'2', ''),
								'1', ''),
							'.', ''),
						'0', '')
					) AS data_suffix
    
    FROM		currency_text
)
SELECT			currency_as_text,
				no_symbol,
                data_suffix,
                CAST(REPLACE(no_symbol, data_suffix,'') AS DECIMAL(10,1)) AS num,
                IFNULL(powers.exponent, 0) AS exponent,
                CAST(REPLACE(no_symbol, data_suffix,'') AS DECIMAL(10,1)) * POWER(10, COALESCE(exponent, 0)) AS currency_as_number
                
FROM			clean_data
LEFT JOIN		powers ON powers.suffix = data_suffix;