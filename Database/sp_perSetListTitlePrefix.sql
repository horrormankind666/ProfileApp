USE [MUStudent]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetListTitlePrefix]    Script Date: 03/27/2014 11:51:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๓/๑๑/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perTitlePrefix ครั้งละหลายเรคคอร์ด>
--  1. order			เป็น VARCHAR	รับค่าลำดับของเรคคอร์ด
--  2. id 				เป็น VARCHAR	รับค่ารหัสคำนำหน้าชื่อ
--  3. thTitleFullName	เป็น NVARCHAR	รับค่าชื่อเต็มคำหน้าชื่อภาษาไทย
--  4. thTitleInitials	เป็น NVARCHAR	รับค่าชื่อย่อคำหน้าชื่อภาษาไทย
--  5. thDescription	เป็น NVARCHAR	รับค่ารายละเอียดคำหน้าชื่อภาษาไทย
--  6. enTitleFullName	เป็น NVARCHAR	รับค่าชื่อเต็มคำหน้าชื่อภาษาอังกฤษ
--  7. enTitleInitials	เป็น NVARCHAR	รับค่าชื่อย่อคำหน้าชื่อภาษาอังกฤษ
--  8. enDescription	เป็น NVARCHAR	รับค่ารายละเอียดคำหน้าชื่อภาษาอังกฤษ
--  9. perGenderId		เป็น VARCHAR	รับค่ารหัสเพศ
-- 10. by				เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetListTitlePrefix]
(
	@order VARCHAR(MAX) = NULL,
	@id VARCHAR(MAX) = NULL,
	@thTitleFullName NVARCHAR(MAX) = NULL,
	@thTitleInitials NVARCHAR(MAX) = NULL,
	@thDescription NVARCHAR(MAX) = NULL,
	@enTitleFullName NVARCHAR(MAX) = NULL,
	@enTitleInitials NVARCHAR(MAX) = NULL,
	@enDescription NVARCHAR(MAX) = NULL,
	@perGenderId VARCHAR(MAX) = NULL,
    @by NVARCHAR(255) = NULL
)	
AS
BEGIN
	SET NOCOUNT ON
	
	SET @order = LTRIM(RTRIM(@order))
	SET @id = LTRIM(RTRIM(@id))
	SET @thTitleFullName = LTRIM(RTRIM(@thTitleFullName))
	SET @thTitleInitials = LTRIM(RTRIM(@thTitleInitials))
	SET @thDescription = LTRIM(RTRIM(@thDescription))
	SET @enTitleFullName = LTRIM(RTRIM(@enTitleFullName))
	SET @enTitleInitials = LTRIM(RTRIM(@enTitleInitials))
	SET @enDescription = LTRIM(RTRIM(@enDescription))
	SET @perGenderId = LTRIM(RTRIM(@perGenderId))
	SET @by = LTRIM(RTRIM(@by))
	
	DECLARE @action VARCHAR(10) = 'INSERT'
	DECLARE @table VARCHAR(50) = 'perTitlePrefix'
	DECLARE @i INT = 1
	DECLARE @delimiter CHAR(1) = ';'
	DECLARE @orderSlice VARCHAR(MAX) = NULL
	DECLARE @idSlice VARCHAR(MAX) = NULL
	DECLARE @thTitleFullNameSlice NVARCHAR(MAX) = NULL
	DECLARE @thTitleInitialsSlice NVARCHAR(MAX) = NULL
	DECLARE @thDescriptionSlice NVARCHAR(MAX) = NULL
	DECLARE @enTitleFullNameSlice NVARCHAR(MAX) = NULL
	DECLARE @enTitleInitialsSlice NVARCHAR(MAX) = NULL
	DECLARE @enDescriptionSlice NVARCHAR(MAX) = NULL
	DECLARE @perGenderIdSlice VARCHAR(MAX) = NULL
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
		
		SET @thTitleFullNameSlice = (SELECT stringSlice FROM fnc_perParseString(@thTitleFullName, @delimiter))
		SET @thTitleFullName = (SELECT string FROM fnc_perParseString(@thTitleFullName, @delimiter))
						
		SET @thTitleInitialsSlice = (SELECT stringSlice FROM fnc_perParseString(@thTitleInitials, @delimiter))
		SET @thTitleInitials = (SELECT string FROM fnc_perParseString(@thTitleInitials, @delimiter))
		
		SET @thDescriptionSlice = (SELECT stringSlice FROM fnc_perParseString(@thDescription, @delimiter))
		SET @thDescription = (SELECT string FROM fnc_perParseString(@thDescription, @delimiter))

		SET @enTitleFullNameSlice = (SELECT stringSlice FROM fnc_perParseString(@enTitleFullName, @delimiter))
		SET @enTitleFullName = (SELECT string FROM fnc_perParseString(@enTitleFullName, @delimiter))		
		
		SET @enTitleInitialsSlice = (SELECT stringSlice FROM fnc_perParseString(@enTitleInitials, @delimiter))
		SET @enTitleInitials = (SELECT string FROM fnc_perParseString(@enTitleInitials, @delimiter))				
		
		SET @enDescriptionSlice = (SELECT stringSlice FROM fnc_perParseString(@enDescription, @delimiter))
		SET @enDescription = (SELECT string FROM fnc_perParseString(@enDescription, @delimiter))		
		
		SET @perGenderIdSlice = (SELECT stringSlice FROM fnc_perParseString(@perGenderId, @delimiter))
		SET @perGenderId = (SELECT string FROM fnc_perParseString(@perGenderId, @delimiter))		
		
		IF (LEN(@orderSlice) > 0)
		BEGIN			
			SET @value = 'id=' + (CASE WHEN (@idSlice IS NOT NULL AND LEN(@idSlice) > 0 AND CHARINDEX(@idSlice, @strBlank) = 0) THEN ('"' + @idSlice + '"') ELSE 'NULL' END) + ', ' +
						 'thTitleFullName=' + (CASE WHEN (@thTitleFullNameSlice IS NOT NULL AND LEN(@thTitleFullNameSlice) > 0 AND CHARINDEX(@thTitleFullNameSlice, @strBlank) = 0) THEN ('"' + @thTitleFullNameSlice + '"') ELSE 'NULL' END) + ', ' +
						 'thTitleInitials=' + (CASE WHEN (@thTitleInitialsSlice IS NOT NULL AND LEN(@thTitleInitialsSlice) > 0 AND CHARINDEX(@thTitleInitialsSlice, @strBlank) = 0) THEN ('"' + @thTitleInitialsSlice + '"') ELSE 'NULL' END) + ', ' +
						 'thDescription=' + (CASE WHEN (@thDescriptionSlice IS NOT NULL AND LEN(@thDescriptionSlice) > 0 AND CHARINDEX(@thDescriptionSlice, @strBlank) = 0) THEN ('"' + @thDescriptionSlice + '"') ELSE 'NULL' END) + ', ' +
						 'enTitleFullName=' + (CASE WHEN (@enTitleFullNameSlice IS NOT NULL AND LEN(@enTitleFullNameSlice) > 0 AND CHARINDEX(@enTitleFullNameSlice, @strBlank) = 0) THEN ('"' + @enTitleFullNameSlice + '"') ELSE 'NULL' END) + ', ' +
						 'enTitleInitials=' + (CASE WHEN (@enTitleInitialsSlice IS NOT NULL AND LEN(@enTitleInitialsSlice) > 0 AND CHARINDEX(@enTitleInitialsSlice, @strBlank) = 0) THEN ('"' + @enTitleInitialsSlice + '"') ELSE 'NULL' END) + ', ' +
						 'enDescription=' + (CASE WHEN (@enDescriptionSlice IS NOT NULL AND LEN(@enDescriptionSlice) > 0 AND CHARINDEX(@enDescriptionSlice, @strBlank) = 0) THEN ('"' + @enDescriptionSlice + '"') ELSE 'NULL' END) + ', ' +
						 'perGenderId=' + (CASE WHEN (@perGenderIdSlice IS NOT NULL AND LEN(@perGenderIdSlice) > 0 AND CHARINDEX(@perGenderIdSlice, @strBlank) = 0) THEN ('"' + @perGenderIdSlice + '"') ELSE 'NULL' END)
						 
			BEGIN TRY
				BEGIN TRAN	
					INSERT INTO perTitlePrefix
					(
						id,
						thTitleFullName,
						thTitleInitials,
						thDescription,
						enTitleFullName,
						enTitleInitials,
						enDescription,
						perGenderId,
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
						CASE WHEN (@thTitleFullNameSlice IS NOT NULL AND LEN(@thTitleFullNameSlice) > 0 AND CHARINDEX(@thTitleFullNameSlice, @strBlank) = 0) THEN @thTitleFullNameSlice ELSE NULL END,
						CASE WHEN (@thTitleInitialsSlice IS NOT NULL AND LEN(@thTitleInitialsSlice) > 0 AND CHARINDEX(@thTitleInitialsSlice, @strBlank) = 0) THEN @thTitleInitialsSlice ELSE NULL END,
						CASE WHEN (@thDescriptionSlice IS NOT NULL AND LEN(@thDescriptionSlice) > 0 AND CHARINDEX(@thDescriptionSlice, @strBlank) = 0) THEN @thDescriptionSlice ELSE NULL END,
						CASE WHEN (@enTitleFullNameSlice IS NOT NULL AND LEN(@enTitleFullNameSlice) > 0 AND CHARINDEX(@enTitleFullNameSlice, @strBlank) = 0) THEN @enTitleFullNameSlice ELSE NULL END,
						CASE WHEN (@enTitleInitialsSlice IS NOT NULL AND LEN(@enTitleInitialsSlice) > 0 AND CHARINDEX(@enTitleInitialsSlice, @strBlank) = 0) THEN @enTitleInitialsSlice ELSE NULL END,
						CASE WHEN (@enDescriptionSlice IS NOT NULL AND LEN(@enDescriptionSlice) > 0 AND CHARINDEX(@enDescriptionSlice, @strBlank) = 0) THEN @enDescriptionSlice ELSE NULL END,
						CASE WHEN (@perGenderIdSlice IS NOT NULL AND LEN(@perGenderIdSlice) > 0 AND CHARINDEX(@perGenderIdSlice, @strBlank) = 0) THEN @perGenderIdSlice ELSE NULL END,
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
