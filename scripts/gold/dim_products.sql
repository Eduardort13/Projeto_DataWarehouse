/*
---------------------------------------------------------------------------------
Camada Gold: Criação da View gold.dim_products
    1. Define a chave substituta (product_key) baseada no histórico de datas.
    2. Consolida dados de produtos (CRM) e categorias (ERP).
    3. Filtra apenas registros ativos (prd_end_dt IS NULL).
---------------------------------------------------------------------------------
*/

CREATE OR ALTER VIEW gold.dim_products AS
SELECT 
    ROW_NUMBER() OVER(ORDER BY pn.prd_start_dt, pn.prd_id) AS product_key,
    pn.prd_id          AS product_id,
    pn.cat_id          AS category_id,
    pn.prd_key         AS product_number,
    pn.prd_nm          AS product_name,
    pn.prd_cost        AS cost,
    pn.prd_start_dt    AS start_date,
    pc.cat             AS category,
    pc.subcat          AS subcategory,
    pc.maintenance     AS maintenance
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc 
    ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL;
GO
