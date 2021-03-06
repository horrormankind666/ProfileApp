USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetNationality]    Script Date: 11/16/2015 16:37:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๐/๑๑/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perNationality ครั้งละ ๑ เรคคอร์ด>
--  1. action					เป็น VARCHAR	รับค่าการกระทำกับฐานข้อมูล
--  2. id						เป็น VARCHAR	รับค่ารหัสสัญชาติหรือเชื้อชาติ
--  3. nationalityNameTH		เป็น NVARCHAR	รับค่าชื่อสัญชาติหรือเชื้อชาติภาษาไทย
--  4. nationalityNameEN		เป็น NVARCHAR	รับค่าชื่อสัญชาติหรือเชื้อชาติภาษาอังกฤษ
--	5. isoCountryCodes2Letter	เป็น VARCHAR	รับค่าชื่อตัวย่อ 2 ตัวอักษร
--	6. isoCountryCodes3Letter	เป็น VARCHAR	รับค่าชื่อตัวย่อ 3 ตัวอักษร
--	7. cancelledStatus			เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  8. by						เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
--	9. ip						เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetNationality] 
(
	@action VARCHAR(10) = NULL,
	@id	VARCHAR(3) = NULL,
	@nationalityNameTH NVARCHAR(255) = NULL,
	@nationalityNameEN NVARCHAR(255) = NULL,
	@isoCountryCodes2Letter VARCHAR(2) = NULL,
	@isoCountryCodes3Letter VARCHAR(3) = NULL,
	@cancelledStatus VARCHAR(1) = NULL,
	@by NVARCHAR(255) = NULL,
	@ip VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @action = LTRIM(RTRIM(@action))
	SET @id = LTRIM(RTRIM(@id))
	SET @nationalityNameTH = LTRIM(RTRIM(@nationalityNameTH))
	SET @nationalityNameEN = LTRIM(RTRIM(@nationalityNameEN))
	SET @isoCountryCodes2Letter = LTRIM(RTRIM(@isoCountryCodes2Letter))
	SET @isoCountryCodes3Letter = LTRIM(RTRIM(@isoCountryCodes3Letter))
	SET @cancelledStatus = LTRIM(RTRIM(@cancelledStatus))
	SET @by = LTRIM(RTRIM(@by))
	SET @ip = LTRIM(RTRIM(@ip))
	
	DECLARE @table VARCHAR(50) = 'perNationality'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	
	SET @action = UPPER(@action)
	
	IF (@action = 'INSERT' OR @action = 'UPDATE' OR @action= 'DELETE')
	BEGIN
		SET @value = 'id=' + (CASE WHEN (@id IS NOT NULL AND LEN(@id) > 0 AND CHARINDEX(@id, @strBlank) = 0) THEN ('"' + @id + '"') ELSE 'NULL' END) + ', ' +					 
					 'thNationalityName=' + (CASE WHEN (@nationalityNameTH IS NOT NULL AND LEN(@nationalityNameTH) > 0 AND CHARINDEX(@nationalityNameTH, @strBlank) = 0) THEN ('"' + @nationalityNameTH + '"') ELSE 'NULL' END) + ', ' +
					 'enNationalityName=' + (CASE WHEN (@nationalityNameEN IS NOT NULL AND LEN(@nationalityNameEN) > 0 AND CHARINDEX(@nationalityNameEN, @strBlank) = 0) THEN ('"' + @nationalityNameEN + '"') ELSE 'NULL' END) + ', ' +
					 'isoCountryCodes2Letter=' + (CASE WHEN (@isoCountryCodes2Letter IS NOT NULL AND LEN(@isoCountryCodes2Letter) > 0 AND CHARINDEX(@isoCountryCodes2Letter, @strBlank) = 0) THEN ('"' + @isoCountryCodes2Letter + '"') ELSE 'NULL' END) + ', ' +
					 'isoCountryCodes3Letter=' + (CASE WHEN (@isoCountryCodes3Letter IS NOT NULL AND LEN(@isoCountryCodes3Letter) > 0 AND CHARINDEX(@isoCountryCodes3Letter, @strBlank) = 0) THEN ('"' + @isoCountryCodes3Letter + '"') ELSE 'NULL' END) + ', ' +
					 'cancel=' + (CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN ('"' + @cancelledStatus + '"') ELSE 'NULL' END)
					 
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
 					INSERT INTO perNationality
 					(
						id,
						thNationalityName,
						enNationalityName,
						isoCountryCodes2Letter,
						isoCountryCodes3Letter,
						cancel,
						createDate,
						createBy,
						createIp,
						modifyDate,
						modifyBy,
						modifyIp						
					)
					VALUES
					(
						CASE WHEN (@id IS NOT NULL AND LEN(@id) > 0 AND CHARINDEX(@id, @strBlank) = 0) THEN @id ELSE NULL END,
						CASE WHEN (@nationalityNameTH IS NOT NULL AND LEN(@nationalityNameTH) > 0 AND CHARINDEX(@nationalityNameTH, @strBlank) = 0) THEN @nationalityNameTH ELSE NULL END,
						CASE WHEN (@nationalityNameEN IS NOT NULL AND LEN(@nationalityNameEN) > 0 AND CHARINDEX(@nationalityNameEN, @strBlank) = 0) THEN @nationalityNameEN ELSE NULL END,
						CASE WHEN (@isoCountryCodes2Letter IS NOT NULL AND LEN(@isoCountryCodes2Letter) > 0 AND CHARINDEX(@isoCountryCodes2Letter, @strBlank) = 0) THEN @isoCountryCodes2Letter ELSE NULL END,
						CASE WHEN (@isoCountryCodes3Letter IS NOT NULL AND LEN(@isoCountryCodes3Letter) > 0 AND CHARINDEX(@isoCountryCodes3Letter, @strBlank) = 0) THEN @isoCountryCodes3Letter ELSE NULL END,
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
				
				IF (@action = 'UPDATE' OR @action = 'DELETE')					
				BEGIN
					IF (@id IS NOT NULL AND LEN(@id) > 0 AND CHARINDEX(@id, @strBlank) = 0)
					BEGIN
						SET @rowCountUpdate = (SELECT COUNT(id) FROM perNationality WHERE id = @id)
						
						IF (@rowCountUpdate > 0)
						BEGIN
							IF (@action = 'UPDATE')
							BEGIN
								UPDATE perNationality SET
									thNationalityName		= CASE WHEN (@nationalityNameTH IS NOT NULL AND LEN(@nationalityNameTH) > 0 AND CHARINDEX(@nationalityNameTH, @strBlank) = 0) THEN @nationalityNameTH ELSE (CASE WHEN (@nationalityNameTH IS NOT NULL AND (LEN(@nationalityNameTH) = 0 OR CHARINDEX(@nationalityNameTH, @strBlank) > 0)) THEN NULL ELSE thNationalityName END) END,
									enNationalityName		= CASE WHEN (@nationalityNameEN IS NOT NULL AND LEN(@nationalityNameEN) > 0 AND CHARINDEX(@nationalityNameEN, @strBlank) = 0) THEN @nationalityNameEN ELSE (CASE WHEN (@nationalityNameEN IS NOT NULL AND (LEN(@nationalityNameEN) = 0 OR CHARINDEX(@nationalityNameEN, @strBlank) > 0)) THEN NULL ELSE enNationalityName END) END,
									isoCountryCodes2Letter	= CASE WHEN (@isoCountryCodes2Letter IS NOT NULL AND LEN(@isoCountryCodes2Letter) > 0 AND CHARINDEX(@isoCountryCodes2Letter, @strBlank) = 0) THEN @isoCountryCodes2Letter ELSE (CASE WHEN (@isoCountryCodes2Letter IS NOT NULL AND (LEN(@isoCountryCodes2Letter) = 0 OR CHARINDEX(@isoCountryCodes2Letter, @strBlank) > 0)) THEN NULL ELSE isoCountryCodes2Letter END) END,
									isoCountryCodes3Letter	= CASE WHEN (@isoCountryCodes3Letter IS NOT NULL AND LEN(@isoCountryCodes3Letter) > 0 AND CHARINDEX(@isoCountryCodes3Letter, @strBlank) = 0) THEN @isoCountryCodes3Letter ELSE (CASE WHEN (@isoCountryCodes3Letter IS NOT NULL AND (LEN(@isoCountryCodes3Letter) = 0 OR CHARINDEX(@isoCountryCodes3Letter, @strBlank) > 0)) THEN NULL ELSE isoCountryCodes3Letter END) END,
									cancel					= CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN @cancelledStatus ELSE (CASE WHEN (@cancelledStatus IS NOT NULL AND (LEN(@cancelledStatus) = 0 OR CHARINDEX(@cancelledStatus, @strBlank) > 0)) THEN NULL ELSE cancel END) END,
									modifyDate				= GETDATE(),
									modifyBy				= CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE (CASE WHEN (@by IS NOT NULL AND (LEN(@by) = 0 OR CHARINDEX(@by, @strBlank) > 0)) THEN NULL ELSE modifyBy END) END,
									modifyIp				= CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE (CASE WHEN (@ip IS NOT NULL AND (LEN(@ip) = 0 OR CHARINDEX(@ip, @strBlank) > 0)) THEN NULL ELSE modifyIp END) END
								WHERE id = @id	
							END
							
							IF (@action = 'DELETE')								
							BEGIN
								DELETE FROM perNationality WHERE id = @id
							END
							
							SET @rowCount = @rowCount + 1						
						END							
					END				
				END
			COMMIT TRAN									
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
			INSERT INTO InfinityLog..perErrorLog
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