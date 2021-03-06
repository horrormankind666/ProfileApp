USE [MUStudent]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetListEducationalMajor]    Script Date: 03/27/2014 11:48:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๓/๑๒/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perEducationalMajor ครั้งละหลายเรคคอร์ด>
--  1. order					เป็น VARCHAR	รับค่าลำดับของเรคคอร์ด
--  2. id						เป็น VARCHAR	รับค่ารหัสสายการเรียน
--  3. thEducationalMajorName	เป็น NVARCHAR	รับค่าชื่อสายการเรียนภาษาไทย
--  4. enEducationalMajorName	เป็น NVARCHAR	รับค่าชื่อสายการเรียนภาษาอังกฤษ
--	5. by						เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetListEducationalMajor]
(
	@order VARCHAR(MAX) = NULL,
	@id VARCHAR(MAX) = NULL,
	@thEducationalMajorName NVARCHAR(MAX) = NULL,
	@enEducationalMajorName NVARCHAR(MAX) = NULL,
	@by NVARCHAR(255) = NULL
)	
AS
BEGIN
	SET NOCOUNT ON
	
	SET @order = LTRIM(RTRIM(@order))
	SET @id = LTRIM(RTRIM(@id))
	SET @thEducationalMajorName = LTRIM(RTRIM(@thEducationalMajorName))
	SET @enEducationalMajorName = LTRIM(RTRIM(@enEducationalMajorName))
	SET @by = LTRIM(RTRIM(@by))
			
	DECLARE @action VARCHAR(10) = 'INSERT'
	DECLARE @table VARCHAR(50) = 'perEducationalMajor'
	DECLARE @i INT = 1
	DECLARE @delimiter CHAR(1) = ';'
	DECLARE @orderSlice VARCHAR(MAX) = NULL
	DECLARE @idSlice VARCHAR(MAX) = NULL
	DECLARE @thEducationalMajorNameSlice NVARCHAR(MAX) = NULL
	DECLARE @enEducationalMajorNameSlice NVARCHAR(MAX) = NULL	
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
		
		SET @thEducationalMajorNameSlice = (SELECT stringSlice FROM fnc_perParseString(@thEducationalMajorName, @delimiter))
		SET @thEducationalMajorName = (SELECT string FROM fnc_perParseString(@thEducationalMajorName, @delimiter))
						
		SET @enEducationalMajorNameSlice = (SELECT stringSlice FROM fnc_perParseString(@enEducationalMajorName, @delimiter))
		SET @enEducationalMajorName = (SELECT string FROM fnc_perParseString(@enEducationalMajorName, @delimiter))

		IF (LEN(@orderSlice) > 0)
		BEGIN			
			SET @value = 'id=' + (CASE WHEN (@idSlice IS NOT NULL AND LEN(@idSlice) > 0 AND CHARINDEX(@idSlice, @strBlank) = 0) THEN ('"' + @idSlice + '"') ELSE 'NULL' END) + ', ' +
						 'thEducationalMajorName=' + (CASE WHEN (@thEducationalMajorNameSlice IS NOT NULL AND LEN(@thEducationalMajorNameSlice) > 0 AND CHARINDEX(@thEducationalMajorNameSlice, @strBlank) = 0) THEN ('"' + @thEducationalMajorNameSlice + '"') ELSE 'NULL' END) + ', ' +
						 'enEducationalMajorName=' + (CASE WHEN (@enEducationalMajorNameSlice IS NOT NULL AND LEN(@enEducationalMajorNameSlice) > 0 AND CHARINDEX(@enEducationalMajorNameSlice, @strBlank) = 0) THEN ('"' + @enEducationalMajorNameSlice + '"') ELSE 'NULL' END)

			BEGIN TRY
				BEGIN TRAN	
					INSERT INTO perEducationalMajor
					(
						id,
						thEducationalMajorName,
						enEducationalMajorName,
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
						CASE WHEN (@thEducationalMajorNameSlice IS NOT NULL AND LEN(@thEducationalMajorNameSlice) > 0 AND CHARINDEX(@thEducationalMajorNameSlice, @strBlank) = 0) THEN @thEducationalMajorNameSlice ELSE NULL END,
						CASE WHEN (@enEducationalMajorNameSlice IS NOT NULL AND LEN(@enEducationalMajorNameSlice) > 0 AND CHARINDEX(@enEducationalMajorNameSlice, @strBlank) = 0) THEN @enEducationalMajorNameSlice ELSE NULL END,
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
