/*
---------------------------------------------------------------------------------
Processamento: Limpeza e Transformação (ERP Product Categories)
    1. Trunca a tabela para garantir carga limpa.
    2. Realiza a migração dos dados da camada Bronze para a Silver.
---------------------------------------------------------------------------------
*/

TRUNCATE TABLE silver.erp_px_cat_g1v2;

INSERT INTO silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
SELECT
    id,
    cat,
    subcat,
    maintenance
FROM bronze.erp_px_cat_g1v2;
GO

