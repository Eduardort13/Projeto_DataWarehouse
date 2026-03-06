/*
---------------------------------------------------------------------------------
Processamento: Limpeza e Transformação (CRM Sales Details)
    1. Converte datas no formato INT (YYYYMMDD) para o tipo DATE.
    2. Valida e recalcula o valor total de vendas (sls_sales) se inconsistente.
    3. Trata preços unitários (sls_price) nulos, negativos ou zerados.
    4. Garante a integridade dos cálculos financeiros na camada Silver.
---------------------------------------------------------------------------------
*/

TRUNCATE TABLE silver.crm_sales_details;

INSERT INTO silver.crm_sales_details (
    sls_order_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_quantity,
    sls_sales,
    sls_price
)
SELECT
    sls_order_num,
    sls_prd_key,
    sls_cust_id,
    CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
         ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
    END AS sls_order_dt,
    CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
         ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
    END AS sls_ship_dt,
    CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
         ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
    END AS sls_due_dt,
    sls_quantity,
    CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
         THEN sls_quantity * ABS(sls_price)
         ELSE sls_sales
    END AS sls_sales,
    CASE WHEN sls_price IS NULL OR sls_price <= 0
         THEN sls_sales / NULLIF(sls_quantity, 0)
         ELSE sls_price
    END AS sls_price
FROM bronze.crm_sales_details;
GO
