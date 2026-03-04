/*
---------------------------------------------------------------------------------
Stored Procedure: Carga da Camada Bronze
    1. Realiza o TRUNCATE das tabelas para limpeza de dados antigos.
    2. Executa o BULK INSERT para importar dados dos arquivos CSV.
    3. Registra o progresso da carga através de mensagens no console.
IMPORTANTE: Substitua '<CAMINHO_DO_PROJETO>' pelo caminho local da pasta onde
os arquivos CSV foram salvos em sua máquina.
---------------------------------------------------------------------------------
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN

	PRINT '===========================================================';
	PRINT 'Populando camada bronze';
	PRINT '===========================================================';

	PRINT '===========================================================';
	PRINT 'Populando tabelas CRM';
	PRINT '===========================================================';

	TRUNCATE TABLE bronze.crm_cust_info;

	BULK INSERT bronze.crm_cust_info
	FROM '<CAMINHO_DO_PROJETO>\datasets\source_crm\cust_info.csv'
	WITH (
		FIRSTROW = 2, 
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	TRUNCATE TABLE bronze.crm_prd_info;

	BULK INSERT bronze.crm_prd_info
	FROM '<CAMINHO_DO_PROJETO>\datasets\source_crm\prd_info.csv'
	WITH (
		FIRSTROW = 2, 
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	TRUNCATE TABLE bronze.crm_sales_details;

	BULK INSERT bronze.crm_sales_details
	FROM '<CAMINHO_DO_PROJETO>\datasets\source_crm\sales_details.csv'
	WITH (
		FIRSTROW = 2, 
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	PRINT ' ';
	PRINT '===========================================================';
	PRINT 'Populando tabelas ERP';
	PRINT '===========================================================';


	TRUNCATE TABLE bronze.erp_cust_az12;

	BULK INSERT bronze.erp_cust_az12
	FROM '<CAMINHO_DO_PROJETO>\datasets\source_erp\cust_az12.csv'
	WITH (
		FIRSTROW = 2, 
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	TRUNCATE TABLE bronze.erp_loc_a101;

	BULK INSERT bronze.erp_loc_a101
	FROM '<CAMINHO_DO_PROJETO>\datasets\source_erp\loc_a101.csv'
	WITH (
		FIRSTROW = 2, 
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	TRUNCATE TABLE bronze.erp_px_cat_g1v2;

	BULK INSERT bronze.erp_px_cat_g1v2
	FROM '<CAMINHO_DO_PROJETO>\datasets\source_erp\px_cat_g1v2.csv'
	WITH (
		FIRSTROW = 2, 
		FIELDTERMINATOR = ',',
		TABLOCK
	);
END
GO
