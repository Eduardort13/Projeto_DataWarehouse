/*
---------------------------------------------------------------------------------
Processamento: Limpeza e Transformação (ERP Customers)
    1. Remove o prefixo 'NAS' do CID.
    2. Valida a data de nascimento (bdate) para evitar datas futuras.
    3. Padroniza o gênero ('Female', 'Male' ou 'n/a').
Este script realiza a carga final dos dados do ERP na camada Silver.
---------------------------------------------------------------------------------
*/

INSERT INTO silver.erp_cust_az12 (cid, bdate, gen)
SELECT
    CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
         ELSE cid 
    END AS cid,
        CASE WHEN bdate > GETDATE() THEN NULL
         ELSE bdate
    END AS bdate,
        CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
         WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
         ELSE 'n/a'
    END AS gen
FROM bronze.erp_cust_az12;



