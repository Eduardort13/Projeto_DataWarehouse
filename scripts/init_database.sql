/*
---------------------------------------------------------------------------------
Inicialização do Ambiente de Data Warehouse
    1. Remove o banco 'DataWarehouse' existente forçando o fechamento de conexões.
    2. Recria o banco de dados do zero.
    3. Define a estrutura de camadas (Bronze, Silver, Gold) via Schemas.
Este script apaga TODOS os dados existentes no DataWarehouse.
---------------------------------------------------------------------------------
*/

use master;
go

if exists(select 1 from sys.databases where name = 'DataWarehouse')
begin 
    alter database DataWarehouse set single_user with rollback immediate;
    drop database DataWarehouse;
end
go

create database DataWarehouse;
go

use DataWarehouse;
go

create schema bronze;
go
create schema silver;
go
create schema gold;
go
