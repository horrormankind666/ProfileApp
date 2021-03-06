USE [MUStudent]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetListRelationship]    Script Date: 03/31/2014 14:26:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๑/๑๑/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perRelationship ครั้งละหลายเรคคอร์ด>
--  1. order				เป็น VARCHAR	รับค่าลำดับของเรคคอร์ด
--  2. id 					เป็น VARCHAR	รับค่ารหัสความสัมพันธ์ในครอบครัว
--  3. thRelationshipName	เป็น NVARCHAR	รับค่าชื่อความสัมพันธ์ในครอบครัวภาษาไทย
--  4. enRelationshipName	เป็น NVARCHAR	รับค่าชื่อความสัมพันธ์ในครอบครัวภาษาอังกฤษ
--  5. perGenderId			เป็น VARCHAR	รับค่ารหัสเพศ
--  6. by					เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetListRelationship]
(
	@order VARCHAR(MAX) = NULL,
	@id VARCHAR(MAX) = NULL,
	@thRelationshipName NVARCHAR(MAX) = NULL,
	@enRelationshipName NVARCHAR(MAX) = NULL,
	@perGenderId VARCHAR(MAX) = NULL,
    @by NVARCHAR(255) = NULL
)	
AS
BEGIN
	SET NOCOUNT ON

	SET @order = LTRIM(RTRIM(@order))
	SET @id = LTRIM(RTRIM(@id))
	SET @thRelationshipName = LTRIM(RTRIM(@thRelationshipName))
	SET @enRelationshipName = LTRIM(RTRIM(@enRelationshipName))
	SET @perGenderId = LTRIM(RTRIM(@perGenderId))
	SET @by = LTRIM(RTRIM(@by))

	DECLARE @action VARCHAR(10) = 'INSERT'
	DECLARE @table VARCHAR(50) = 'perRelationship'
	DECLARE @i INT = 1
	DECLARE @delimiter CHAR(1) = ';'
	DECLARE @orderSlice VARCHAR(MAX) = NULL
	DECLARE @idSlice VARCHAR(MAX) = NULL
	DECLARE @thRelationshipNameSlice NVARCHAR(MAX) = NULL
	DECLARE @enRelationshipNameSlice NVARCHAR(MAX) = NULL	
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
		
		SET @thRelationshipNameSlice = (SELECT stringSlice FROM fnc_perParseString(@thRelationshipName, @delimiter))
		SET @thRelationshipName = (SELECT string FROM fnc_perParseString(@thRelationshipName, @delimiter))
						
		SET @enRelationshipNameSlice = (SELECT stringSlice FROM fnc_perParseString(@enRelationshipName, @delimiter))
		SET @enRelationshipName = (SELECT string FROM fnc_perParseString(@enRelationshipName, @delimiter))

		SET @perGenderIdSlice = (SELECT stringSlice FROM fnc_perParseString(@perGenderId, @delimiter))
		SET @perGenderId = (SELECT string FROM fnc_perParseString(@perGenderId, @delimiter))		

		IF (LEN(@orderSlice) > 0)
		BEGIN			
			SET @value = 'id=' + (CASE WHEN (@idSlice IS NOT NULL AND LEN(@idSlice) > 0 AND CHARINDEX(@idSlice, @strBlank) = 0) THEN ('"' + @idSlice + '"') ELSE 'NULL' END) + ', ' +
						 'thRelationshipName=' + (CASE WHEN (@thRelationshipNameSlice IS NOT NULL AND LEN(@thRelationshipNameSlice) > 0 AND CHARINDEX(@thRelationshipNameSlice, @strBlank) = 0) THEN ('"' + @thRelationshipNameSlice + '"') ELSE 'NULL' END) + ', ' +
						 'enRelationshipName=' + (CASE WHEN (@enRelationshipNameSlice IS NOT NULL AND LEN(@enRelationshipNameSlice) > 0 AND CHARINDEX(@enRelationshipNameSlice, @strBlank) = 0) THEN ('"' + @enRelationshipNameSlice + '"') ELSE 'NULL' END) + ', ' +
						 'perGenderId=' + (CASE WHEN (@perGenderIdSlice IS NOT NULL AND LEN(@perGenderIdSlice) > 0 AND CHARINDEX(@perGenderIdSlice, @strBlank) = 0) THEN ('"' + @perGenderIdSlice + '"') ELSE 'NULL' END)

			BEGIN TRY
				BEGIN TRAN	
					INSERT INTO perRelationship
					(
						id,
						thRelationshipName,
						enRelationshipName,
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
						CASE WHEN (@thRelationshipNameSlice IS NOT NULL AND LEN(@thRelationshipNameSlice) > 0 AND CHARINDEX(@thRelationshipNameSlice, @strBlank) = 0) THEN @thRelationshipNameSlice ELSE NULL END,
						CASE WHEN (@enRelationshipNameSlice IS NOT NULL AND LEN(@enRelationshipNameSlice) > 0 AND CHARINDEX(@enRelationshipNameSlice, @strBlank) = 0) THEN @enRelationshipNameSlice ELSE NULL END,
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
