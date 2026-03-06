/*
---------------------------------------------------------------------------------
Processamento: Limpeza e Transformação (ERP Locations)
    1. Limpa a tabela de destino (TRUNCATE) para evitar duplicidade.
    2. Remove hifens do 'cid' para padronização.
    3. Traduz siglas de países ('DE', 'US', 'USA') para nomes completos.
    4. Trata valores nulos ou vazios em 'cntry' como 'n/a'.
Este script realiza a carga final dos dados de localização na camada Silver.
---------------------------------------------------------------------------------
*/

TRUNCATE TABLE silver.erp_loc_a101;

INSERT INTO silver.erp_loc_a101 (cid, cntry)
SELECT
    REPLACE(cid, '-', '') AS cid, 
    CASE 
        WHEN TRIM(cntry) = 'DE' THEN 'Germany'
        WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
        WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
        ELSE TRIM(cntry) 
    END AS cntry
FROM bronze.erp_loc_a101;

SELECT * FROM silver.erp_loc_a101;
GO
