USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpSetConditionFormulaCalculation]    Script Date: 12/1/2559 16:15:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๒/๐๑/๒๕๕๙>
-- Description	: <สำหรับบันทึกข้อมูลตาราง ecpConditionFormulaCalculation ครั้งละ ๑ เรคคอร์ด>
--  1. action			เป็น VARCHAR	รับค่าการกระทำกับฐานข้อมูล
--	2. id				เป็น VARCHAR	รับค่ารหัสเงื่อนไขการคิดระยะเวลาตามสัญญา
--	3. condition		เป็น NVARCHAR	รับค่าเงื่อนไขการคิดระยะเวลาตามสัญญา
--	4. formula			เป็น VARCHAR	รับค่ารหัสสูตรคำนวณเงินชดใช้ตามสัญญา
--  5. cancelledStatus	เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  6. by				เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
--  7. ip				เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpSetConditionFormulaCalculation]
(
	@action VARCHAR(10) = NULL,
	@id VARCHAR(2) = NULL,
	@condition NVARCHAR(255) = NULL,
	@formula VARCHAR(2) = NULL,
	@cancelledStatus VARCHAR(1) = NULLL,
	@by NVARCHAR(255) = NULL,
	@ip VARCHAR(255) = NULL
)	
AS
BEGIN
	SET NOCOUNT ON

	SET @action = LTRIM(RTRIM(@action))
	SET @id = LTRIM(RTRIM(@id))
	SET @condition = LTRIM(RTRIM(@condition))
	SET @formula = LTRIM(RTRIM(@formula))
	SET @cancelledStatus = LTRIM(RTRIM(@cancelledStatus))
	SET @by = LTRIM(RTRIM(@by))
	SET @ip = LTRIM(RTRIM(@ip))
	
	DECLARE @table VARCHAR(50) = 'ecpConditionFormulaCalculation'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	
	SET @action = UPPER(@action)
	
	IF (@action = 'INSERT' OR @action = 'UPDATE' OR @action = 'DELETE')
	BEGIN
		SET @value = 'id='						+ (CASE WHEN (@id IS NOT NULL AND LEN(@id) > 0 AND CHARINDEX(@id, @strBlank) = 0) THEN ('"' + @id + '"') ELSE 'NULL' END) + ', ' +
					 'conditionCalculation='	+ (CASE WHEN (@condition IS NOT NULL AND LEN(@condition) > 0 AND CHARINDEX(@condition, @strBlank) = 0) THEN ('"' + @condition + '"') ELSE 'NULL' END) + ', ' +
					 'ecpFormulaCalculationId='	+ (CASE WHEN (@formula IS NOT NULL AND LEN(@formula) > 0 AND CHARINDEX(@formula, @strBlank) = 0) THEN ('"' + @formula + '"') ELSE 'NULL' END) + ', ' +
					 'cancelledStatus='			+ (CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN ('"' + @cancelledStatus + '"') ELSE 'NULL' END)
					 
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
					SET @rowCountUpdate = (SELECT COUNT(id) FROM Infinity..ecpConditionFormulaCalculation WHERE id = @id)
						
					IF (@rowCountUpdate = 0)
					BEGIN		
 						INSERT INTO Infinity..ecpConditionFormulaCalculation
 						(
							conditionCalculation,
							ecpFormulaCalculationId,
							cancelledStatus,
							createDate,
							createBy,
							createIp,
							modifyDate,
							modifyBy,
							modifyIp
						)
						VALUES
						(
							CASE WHEN (@condition IS NOT NULL AND LEN(@condition) > 0 AND CHARINDEX(@condition, @strBlank) = 0) THEN @condition ELSE NULL END,
							CASE WHEN (@formula IS NOT NULL AND LEN(@formula) > 0 AND CHARINDEX(@formula, @strBlank) = 0) THEN @formula ELSE NULL END,
							CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN @cancelledStatus ELSE NULL END,
							GETDATE(),
							CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE NULL END,
							CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE NULL END,
							NULL,
							NULL,
							NULL
						)		
															
						SET @rowCount = @rowCount + 1
					END													
				END					 
				
				IF (@action = 'UPDATE' OR @action = 'DELETE')					
				BEGIN
					SET @rowCountUpdate = (SELECT COUNT(id) FROM Infinity..ecpConditionFormulaCalculation WHERE id = @id)
						
					IF (@rowCountUpdate > 0)
					BEGIN
						IF (@action = 'UPDATE')
						BEGIN								
							UPDATE Infinity..ecpConditionFormulaCalculation SET
								conditionCalculation	= CASE WHEN (@condition IS NOT NULL AND LEN(@condition) > 0 AND CHARINDEX(@condition, @strBlank) = 0) THEN @condition ELSE (CASE WHEN (@condition IS NOT NULL AND (LEN(@condition) = 0 OR CHARINDEX(@condition, @strBlank) > 0)) THEN NULL ELSE conditionCalculation END) END,
								ecpFormulaCalculationId	= CASE WHEN (@formula IS NOT NULL AND LEN(@formula) > 0 AND CHARINDEX(@formula, @strBlank) = 0) THEN @formula ELSE (CASE WHEN (@formula IS NOT NULL AND (LEN(@formula) = 0 OR CHARINDEX(@formula, @strBlank) > 0)) THEN NULL ELSE ecpFormulaCalculationId END) END,
								cancelledStatus			= CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN @cancelledStatus ELSE (CASE WHEN (@cancelledStatus IS NOT NULL AND (LEN(@cancelledStatus) = 0 OR CHARINDEX(@cancelledStatus, @strBlank) > 0)) THEN NULL ELSE cancelledStatus END) END,
								modifyDate				= GETDATE(),
								modifyBy				= CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE (CASE WHEN (@by IS NOT NULL AND (LEN(@by) = 0 OR CHARINDEX(@by, @strBlank) > 0)) THEN NULL ELSE modifyBy END) END,
								modifyIp				= CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE (CASE WHEN (@ip IS NOT NULL AND (LEN(@ip) = 0 OR CHARINDEX(@ip, @strBlank) > 0)) THEN NULL ELSE modifyIp END) END
							WHERE (id = @id)
						END
															
						IF (@action = 'DELETE')
						BEGIN
							DELETE FROM Infinity..ecpConditionFormulaCalculation WHERE id = @id
						END
								
						SET @rowCount = @rowCount + 1							
					END				
				END
			COMMIT TRAN									
		END TRY
		BEGIN CATCH		
			ROLLBACK TRAN
			INSERT INTO InfinityLog..ecpErrorLog
			(
				errorDatabase,
				errorTable,
				errorAction,
				errorValue,
				errorMessage,
				errorNumber,
				errorSeverity,
				errorState,
				errorLine,
				errorProcedure,
				errorActionDate,
				errorActionBy,
				errorIp
			)
			VALUES
			(
				DB_NAME(),
				@table,
				@action,
				@value,
				ERROR_MESSAGE(),
				ERROR_NUMBER(),
				ERROR_SEVERITY(),
				ERROR_STATE(),
				ERROR_LINE(),
				ERROR_PROCEDURE(),
				GETDATE(),
				CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE NULL END,
				CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE NULL END
			)		
		END CATCH					
	END		
	
	SELECT @rowCount
END