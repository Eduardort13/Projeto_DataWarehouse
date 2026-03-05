/*
---------------------------------------------------------------------------------
Processamento: Limpeza e Transformação (CRM Products)
    1. Extrai 'cat_id' e limpa 'prd_key' a partir da string original.
    2. Trata valores nulos no custo do produto (ISNULL).
    3. Padroniza as linhas de produtos (Mountain, Road, etc.) via CASE.
    4. Calcula dinamicamente a data de término (prd_end_dt) usando LEAD.
Este script realiza a carga final dos produtos na camada Silver.
---------------------------------------------------------------------------------
*/

IF OBJECT_ID ('silver.crm_prd_info','U') IS NOT NULL 
    DROP TABLE silver.crm_prd_info;

CREATE TABLE silver.crm_prd_info (
	prd_id          INT,
	cat_id          NVARCHAR (50),
	prd_key         NVARCHAR (50),
	prd_nm          NVARCHAR (50),
	prd_cost        INT,
	prd_line        NVARCHAR (50),
	prd_start_dt    DATE,
	prd_end_dt      DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

INSERT INTO silver.crm_prd_info (
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
)
SELECT 
	prd_id,
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
	SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
	prd_nm,
	ISNULL(prd_cost, 0) AS prd_cost,
	CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
		 WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
		 WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
		 WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
		 ELSE 'n/a'
	END AS prd_line,
	CAST(prd_start_dt AS DATE) AS prd_start_dt,
	LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt ASC) - 1 AS prd_end_dt
FROM bronze.crm_prd_info;
GO
