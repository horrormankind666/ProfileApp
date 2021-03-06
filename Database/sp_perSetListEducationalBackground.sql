USE [MUStudent]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetListEducationalBackground]    Script Date: 03/27/2014 11:48:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๐๖/๑๑/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perEducationalBackground ครั้งละหลายเรคคอร์ด>
--  1. order						เป็น VARCHAR	รับค่าลำดับของเรคคอร์ด
--  2. id							เป็น VARCHAR	รับค่าวฺุฒิการศึกษา
--  3. thEducationalBackgroundName	เป็น NVARCHAR	รับค่าชื่อวุฒิการศึกษาภาษาไทย
--  4. enEducationalBackgroundName	เป็น NVARCHAR	รับค่าชื่อวุฒิการศึกษาภาษาอังกฤษ
--  5. perEducationalLevelId		เป็น VARCHAR	รับค่ารหัสระดับการศึกษา
--	6. by							เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetListEducationalBackground]
(
	@order VARCHAR(MAX) = NULL,
	@id VARCHAR(MAX) = NULL,
	@thEducationalBackgroundName NVARCHAR(MAX) = NULL,
	@enEducationalBackgroundName NVARCHAR(MAX) = NULL,
	@perEducationalLevelId VARCHAR(MAX) = NULL,
	@by NVARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @order = LTRIM(RTRIM(@order))
	SET @id = LTRIM(RTRIM(@id))
	SET @thEducationalBackgroundName = LTRIM(RTRIM(@thEducationalBackgroundName))
	SET @enEducationalBackgroundName = LTRIM(RTRIM(@enEducationalBackgroundName))
	SET @perEducationalLevelId = LTRIM(RTRIM(@perEducationalLevelId))
	SET @by = LTRIM(RTRIM(@by))
			
	DECLARE @action VARCHAR(10) = 'INSERT'
	DECLARE @table VARCHAR(50) = 'perEducationalBackground'
	DECLARE @i INT = 1
	DECLARE @delimiter CHAR(1) = ';'
	DECLARE @orderSlice VARCHAR(MAX) = NULL
	DECLARE @idSlice VARCHAR(MAX) = NULL
	DECLARE @thEducationalBackgroundNameSlice NVARCHAR(MAX) = NULL
	DECLARE @enEducationalBackgroundNameSlice NVARCHAR(MAX) = NULL
	DECLARE @perEducationalLevelIdSlice VARCHAR(MAX) = NULL
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
		
		SET @thEducationalBackgroundNameSlice = (SELECT stringSlice FROM fnc_perParseString(@thEducationalBackgroundName, @delimiter))
		SET @thEducationalBackgroundName = (SELECT string FROM fnc_perParseString(@thEducationalBackgroundName, @delimiter))
						
		SET @enEducationalBackgroundNameSlice = (SELECT stringSlice FROM fnc_perParseString(@enEducationalBackgroundName, @delimiter))
		SET @enEducationalBackgroundName = (SELECT string FROM fnc_perParseString(@enEducationalBackgroundName, @delimiter))
		
		SET @perEducationalLevelIdSlice = (SELECT stringSlice FROM fnc_perParseString(@perEducationalLevelId, @delimiter))
		SET @perEducationalLevelId = (SELECT string FROM fnc_perParseString(@perEducationalLevelId, @delimiter))		

		IF (LEN(@orderSlice) > 0)
		BEGIN			
			SET @value = 'id=' + (CASE WHEN (@idSlice IS NOT NULL AND LEN(@idSlice) > 0 AND CHARINDEX(@idSlice, @strBlank) = 0) THEN ('"' + @idSlice + '"') ELSE 'NULL' END) + ', ' +
						 'thEducationalBackgroundName=' + (CASE WHEN (@thEducationalBackgroundNameSlice IS NOT NULL AND LEN(@thEducationalBackgroundNameSlice) > 0 AND CHARINDEX(@thEducationalBackgroundNameSlice, @strBlank) = 0) THEN ('"' + @thEducationalBackgroundNameSlice + '"') ELSE 'NULL' END) + ', ' +
						 'enEducationalBackgroundName=' + (CASE WHEN (@enEducationalBackgroundNameSlice IS NOT NULL AND LEN(@enEducationalBackgroundNameSlice) > 0 AND CHARINDEX(@enEducationalBackgroundNameSlice, @strBlank) = 0) THEN ('"' + @enEducationalBackgroundNameSlice + '"') ELSE 'NULL' END) + ', ' +
						 'perEducationalLevelId=' + (CASE WHEN (@perEducationalLevelIdSlice IS NOT NULL AND LEN(@perEducationalLevelIdSlice) > 0 AND CHARINDEX(@perEducationalLevelIdSlice, @strBlank) = 0) THEN ('"' + @perEducationalLevelIdSlice + '"') ELSE 'NULL' END)

			BEGIN TRY
				BEGIN TRAN	
					INSERT INTO perEducationalBackground
					(
						id,
						thEducationalBackgroundName,
						enEducationalBackgroundName,
						perEducationalLevelId,
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
						CASE WHEN (@thEducationalBackgroundNameSlice IS NOT NULL AND LEN(@thEducationalBackgroundNameSlice) > 0 AND CHARINDEX(@thEducationalBackgroundNameSlice, @strBlank) = 0) THEN @thEducationalBackgroundNameSlice ELSE NULL END,
						CASE WHEN (@enEducationalBackgroundNameSlice IS NOT NULL AND LEN(@enEducationalBackgroundNameSlice) > 0 AND CHARINDEX(@enEducationalBackgroundNameSlice, @strBlank) = 0) THEN @enEducationalBackgroundNameSlice ELSE NULL END,
						CASE WHEN (@perEducationalLevelIdSlice IS NOT NULL AND LEN(@perEducationalLevelIdSlice) > 0 AND CHARINDEX(@perEducationalLevelIdSlice, @strBlank) = 0) THEN @perEducationalLevelIdSlice ELSE NULL END,
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
