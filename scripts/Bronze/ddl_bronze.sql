/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;
GO

CREATE TABLE bronze.crm_cust_info (
    cst_id              INT,
    cst_key             NVARCHAR(50),
    cst_firstname       NVARCHAR(50),
    cst_lastname        NVARCHAR(50),
    cst_marital_status  NVARCHAR(50),
    cst_gndr            NVARCHAR(50),
    cst_create_date     DATE
);
GO

IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;
GO

CREATE TABLE bronze.crm_prd_info (
    prd_id       INT,
    prd_key      NVARCHAR(50),
    prd_nm       NVARCHAR(50),
    prd_cost     INT,
    prd_line     NVARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_dt   DATETIME
);
GO

IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;
GO

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num  NVARCHAR(50),
    sls_prd_key  NVARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt INT,
    sls_ship_dt  INT,
    sls_due_dt   INT,
    sls_sales    INT,
    sls_quantity INT,
    sls_price    INT
);
GO

IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;
GO

CREATE TABLE bronze.erp_loc_a101 (
    cid    NVARCHAR(50),
    cntry  NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;
GO

CREATE TABLE bronze.erp_cust_az12 (
    cid    NVARCHAR(50),
    bdate  DATE,
    gen    NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;
GO

CREATE TABLE bronze.erp_px_cat_g1v2 (
    id           NVARCHAR(50),
    cat          NVARCHAR(50),
    subcat       NVARCHAR(50),
    maintenance  NVARCHAR(50)
);
GO


CREATE OR ALTER PROCEDURE bronze.load_bronze as 
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    BEGIN TRY 
        set @batch_start_time = GETDATE();
        PRINT '========================';
        PRINT 'LOADING BRONZE LAYER';
        PRINT '========================';


        PRINT '--------------------------';
        PRINT 'LOADING CRM TABLES';
        PRINT '--------------------------';

        SET @start_time = GETDATE();    
        PRINT '>> TRUNCATING TABLE: bronze.crm_cust_info';
        PRINT '>> START TIME: ' + CAST(@start_time AS NVARCHAR);

        IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
            TRUNCATE TABLE bronze.crm_cust_info;

        PRINT '>> INSERTING DATA INTO TABLE: bronze.crm_cust_info';
        BULK INSERT bronze.crm_cust_info
        FROM 'G:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK 
        );
        SET @end_time = GETDATE();
        PRINT '>> END TIME: ' + CAST(@end_time AS NVARCHAR);
        PRINT'>> LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '-----------------';

        SET @start_time = GETDATE();
        PRINT '>> TRUNCATING TABLE: bronze.crm_prd_info';
        PRINT '>> START TIME: ' + CAST(@start_time AS NVARCHAR);

        IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
            TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '>> INSERTING DATA INTO TABLE: bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM 'G:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK 
        );
        SET @end_time = GETDATE();
        PRINT '>> END TIME: ' + CAST(@end_time AS NVARCHAR);
        PRINT'>> LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '-----------------';

        SET @start_time = GETDATE();
        PRINT '>> TRUNCATING TABLE: bronze.crm_sales_details';
        PRINT '>> START TIME: ' + CAST(@start_time AS NVARCHAR);
        IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
            TRUNCATE TABLE bronze.crm_sales_details;

        PRINT '>> INSERTING DATA INTO TABLE: bronze.crm_sales_details';
    
        BULK INSERT bronze.crm_sales_details
        FROM 'G:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK 
        );
        SET @end_time = GETDATE();
        PRINT '>> END TIME: ' + CAST(@end_time AS NVARCHAR);
        PRINT'>> LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + ' seconds'; 
        PRINT'-----------------';

            PRINT '--------------------------';
            PRINT 'LOADING ERP TABLES';
            PRINT '--------------------------';
        
        SET @start_time = GETDATE();
        PRINT '>> TRUNCATING TABLE: bronze.erp_loc_a101';
        PRINT '>> START TIME: ' + CAST(@start_time AS NVARCHAR);

        IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
            TRUNCATE TABLE bronze.erp_loc_a101;

        PRINT '>> INSERTING DATA INTO TABLE: bronze.erp_loc_a101';

        BULK INSERT bronze.erp_loc_a101
        FROM 'G:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK 
        );  
        SET @end_time = GETDATE();
        PRINT '>> END TIME: ' + CAST(@end_time AS NVARCHAR);
        PRINT'>> LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + ' seconds'; 
        PRINT '-----------------';

        SET @start_time = GETDATE();
        PRINT '>> TRUNCATING TABLE: bronze.erp_cust_az12';
        PRINT '>> START TIME: ' + CAST(@start_time AS NVARCHAR);

        IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
            TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT '>> INSERTING DATA INTO TABLE: bronze.erp_cust_az12';

        BULK INSERT bronze.erp_cust_az12
        FROM 'G:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK 
        );      
        SET @end_time = GETDATE();
        PRINT '>> END TIME: ' + CAST(@end_time AS NVARCHAR);
        PRINT'>> LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + ' seconds'; 
        PRINT '-----------------';

        SET @start_time = GETDATE();
        PRINT '>> TRUNCATING TABLE: bronze.erp_px_cat_g1v2';
        PRINT '>> START TIME: ' + CAST(@start_time AS NVARCHAR);

        IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
            TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT '>> INSERTING DATA INTO TABLE: bronze.erp_px_cat_g1v2';

        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'G:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,           
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> END TIME: ' + CAST(@end_time AS NVARCHAR);
        PRINT'>> LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + ' seconds'; 
        PRINT '-----------------';  


        SET @batch_end_time = GETDATE();
        PRINT '========================';
        PRINT 'BATCH START TIME: ' + CAST(@batch_start_time AS NVARCHAR);
        PRINT 'BATCH END TIME: ' + CAST(@batch_end_time AS NVARCHAR);
        PRINT 'BRONZE LAYER LOADED SUCCESSFULLY';
        PRINT 'TOTAL LOAD DURATION: ' + CAST(DATEDIFF(second,@batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '========================';
        END TRY 
        BEGIN CATCH 
            PRINT '==============================================';
            PRINT 'Error occurred while loading bronze tables: ' + ERROR_MESSAGE();
            PRINT '==============================================';
        END CATCH
END

 exec bronze.load_bronze;
