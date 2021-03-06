USE [MUStudent]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetListDiseases]    Script Date: 03/27/2014 11:47:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๙/๑๑/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perDiseases ครั้งละหลายเรคคอร์ด>
--  1. order			เป็น VARCHAR	รับค่าลำดับของเรคคอร์ด
--  2. id				เป็น VARCHAR	รับค่ารหัสโรค
--  3. thDiseasesName	เป็น NVARCHAR	รับค่าชื่อโรคภาษาไทย
--  4. enDiseasesName	เป็น NVARCHAR	รับค่าชื่อโรคภาษาอังกฤษ
--	5. by				เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetListDiseases]
(
	@order VARCHAR(MAX) = NULL,
	@id VARCHAR(MAX) = NULL,
	@thDiseasesName NVARCHAR(MAX) = NULL,
	@enDiseasesName NVARCHAR(MAX) = NULL,
	@by NVARCHAR(255) = NULL
)	
AS
BEGIN
	SET NOCOUNT ON
	
	SET @order = LTRIM(RTRIM(@order))
	SET @id = LTRIM(RTRIM(@id))
	SET @thDiseasesName = LTRIM(RTRIM(@thDiseasesName))
	SET @enDiseasesName = LTRIM(RTRIM(@enDiseasesName))
	SET @by = LTRIM(RTRIM(@by))
			
	DECLARE @action VARCHAR(10) = 'INSERT'
	DECLARE @table VARCHAR(50) = 'perDiseases'
	DECLARE @i INT = 1
	DECLARE @delimiter CHAR(1) = ';'
	DECLARE @orderSlice VARCHAR(MAX) = NULL
	DECLARE @idSlice VARCHAR(MAX) = NULL
	DECLARE @thDiseasesNameSlice NVARCHAR(MAX) = NULL
	DECLARE @enDiseasesNameSlice NVARCHAR(MAX) = NULL	
	DECLARE @rowCount INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	DECLARE @ip VARCHAR(255) = dbo.fnc_perGetIP()	
	
	WHILE (LEN(@order) > 0)
	BEGIN
		SET @orderSlice = (SELECT stringSlice FROM fnc_perParseString(@order, @delimiter))
		SET @order = (SELECT string FROM fnc_perParseString(@order, @delimiter))
		
		SET @idSlice = (SELECT stringSlice FROM fnc_perParseString(@id, @delimiter))
		SET @id = (SELECT string FROM fnc_perParseString(@id, @delimiter))
		
		SET @thDiseasesNameSlice = (SELECT stringSlice FROM fnc_perParseString(@thDiseasesName, @delimiter))
		SET @thDiseasesName = (SELECT string FROM fnc_perParseString(@thDiseasesName, @delimiter))
						
		SET @enDiseasesNameSlice = (SELECT stringSlice FROM fnc_perParseString(@enDiseasesName, @delimiter))
		SET @enDiseasesName = (SELECT string FROM fnc_perParseString(@enDiseasesName, @delimiter))

		IF (LEN(@orderSlice) > 0)
		BEGIN			
			SET @value = 'id=' + (CASE WHEN (@idSlice IS NOT NULL AND LEN(@idSlice) > 0 AND CHARINDEX(@idSlice, @strBlank) = 0) THEN ('"' + @idSlice + '"') ELSE 'NULL' END) + ', ' +
						 'thDiseasesName=' + (CASE WHEN (@thDiseasesNameSlice IS NOT NULL AND LEN(@thDiseasesNameSlice) > 0 AND CHARINDEX(@thDiseasesNameSlice, @strBlank) = 0) THEN ('"' + @thDiseasesNameSlice + '"') ELSE 'NULL' END) + ', ' +
						 'enDiseasesName=' + (CASE WHEN (@enDiseasesNameSlice IS NOT NULL AND LEN(@enDiseasesNameSlice) > 0 AND CHARINDEX(@enDiseasesNameSlice, @strBlank) = 0) THEN ('"' + @enDiseasesNameSlice + '"') ELSE 'NULL' END)

			BEGIN TRY
				BEGIN TRAN	
					INSERT INTO perDiseases
					(
						id,
						thDiseasesName,
						enDiseasesName,
						createDate,
						createBy,
						createIp,
						modifyDate,
						modifyBy,
						modifyIp
					)
					VALUES
					(
						CASE WHEN (@idSlice IS NOT NULL AND LEN(@idSlice) > 0 AND CHARINDEX(@idSlice, @strBlank) = 0) THEN @idSlice ELSE NULL END,
						CASE WHEN (@thDiseasesNameSlice IS NOT NULL AND LEN(@thDiseasesNameSlice) > 0 AND CHARINDEX(@thDiseasesNameSlice, @strBlank) = 0) THEN @thDiseasesNameSlice ELSE NULL END,
						CASE WHEN (@enDiseasesNameSlice IS NOT NULL AND LEN(@enDiseasesNameSlice) > 0 AND CHARINDEX(@enDiseasesNameSlice, @strBlank) = 0) THEN @enDiseasesNameSlice ELSE NULL END,
						GETDATE(),
						CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE NULL END,
						@ip,
						NULL,
						NULL,
						NULL
					)
				COMMIT TRAN
				SET @rowCount = @rowCount + 1
			END TRY
			BEGIN CATCH
				ROLLBACK TRAN
				INSERT INTO perErrorLog
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
					@ip				
				)				
			END CATCH
		END
	END
	
	SELECT @rowCount	
END
