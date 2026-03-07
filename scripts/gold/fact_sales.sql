/*
---------------------------------------------------------------------------------
Camada Gold: Criação da View gold.fact_sales
    1. Consolida os detalhes de vendas da camada Silver.
    2. Conecta as dimensões de produtos e clientes utilizando chaves substitutas.
    3. Padroniza a nomenclatura das colunas para fácil consumo em BI.
---------------------------------------------------------------------------------
*/

CREATE OR ALTER VIEW gold.fact_sales AS
SELECT
    sd.sls_order_num    AS order_number,
    pr.product_key      AS product_key,
    cu.customer_key     AS customer_key,
    sd.sls_order_dt     AS order_date,
    sd.sls_ship_dt      AS shipping_date,
    sd.sls_due_dt       AS due_date,
    sd.sls_sales        AS sales_amount,
    sd.sls_quantity     AS quantity,
    sd.sls_price        AS unit_price,
    sd.dwh_create_date  AS created_date
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr 
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu 
    ON sd.sls_cust_id = cu.customer_id;
GO
