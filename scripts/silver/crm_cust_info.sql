/*
---------------------------------------------------------------------------------
Processamento: Limpeza e Deduplicação (CRM Customers)
    1. Remove espaços em branco (TRIM).
    2. Utiliza ROW_NUMBER para selecionar o registro mais recente por ID.
    3. Padroniza Gênero e Estado Civil.
    4. FILTRO DE INTEGRIDADE: Remove registros onde o cst_id é nulo.
Este script limpa a Silver e reprocessa os dados corretamente.
---------------------------------------------------------------------------------
*/


TRUNCATE TABLE silver.crm_cust_info;


INSERT INTO silver.crm_cust_info (
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)
SELECT 
    cst_id,
    cst_key,
    TRIM(cst_firstname) AS cst_firstname,
    TRIM(cst_lastname)  AS cst_lastname,
    CASE 
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
        ELSE 'n/a' 
    END AS cst_marital_status,
    CASE 
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male' 
        ELSE 'n/a' 
    END AS cst_gndr,
    cst_create_date
FROM (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag  
    FROM bronze.crm_cust_info
) AS t 
WHERE flag = 1 
  AND cst_id IS NOT NULL; 
