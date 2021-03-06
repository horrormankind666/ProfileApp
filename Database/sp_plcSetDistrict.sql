USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_plcSetDistrict]    Script Date: 11/16/2015 16:52:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๐๔/๑๑/๒๕๕๗>
-- Description	: <สำหรับบันทึกข้อมูลตาราง plcDistrict ครั้งละ ๑ เรคคอร์ด>
--  1. action			เป็น VARCHAR	รับค่าการกระทำกับฐานข้อมูล
--  2. id 				เป็น VARCHAR	รับค่ารหัสสถานที่หรืออำเภอ
--  3. province			เป็น VARCHAR	รับค่ารหัสจังหวัด
--  4. districtNameTH	เป็น NVARCHAR	รับค่าชื่อสถานที่หรืออำเภอภาษาไทย
--  5. districtNameEN	เป็น NVARCHAR	รับค่าชื่อสถานที่หรืออำเภอภาษาอังกฤษ
--  6. zipCode			เป็น NVARCHAR	รับค่ารหัสไปรษณีย์
--  7. cancelledStatus	เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  8. by				เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
--	9. ip				เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_plcSetDistrict]
(
	@action VARCHAR(10) = NULL,
	@id VARCHAR(5) = NULL,
	@province VARCHAR(3) = NULL,
	@districtNameTH NVARCHAR(255) = NULL,
	@districtNameEN NVARCHAR(255) = NULL,
	@zipCode NVARCHAR(10) = NULL,
	@cancelledStatus VARCHAR(1) = NULL,
	@by NVARCHAR(255) = NULL,
	@ip VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @action = LTRIM(RTRIM(@action))
	SET @id = LTRIM(RTRIM(@id))
	SET @province = LTRIM(RTRIM(@province))
	SET @districtNameTH = LTRIM(RTRIM(@districtNameTH))
	SET @districtNameEN = LTRIM(RTRIM(@districtNameEN))	
	SET @zipCode = LTRIM(RTRIM(@zipCode))
	SET @cancelledStatus = LTRIM(RTRIM(@cancelledStatus))
	SET @by = LTRIM(RTRIM(@by))
	SET @ip = LTRIM(RTRIM(@ip))
	
	DECLARE @table VARCHAR(50) = 'plcDistrict'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	
	SET @action = UPPER(@action)
	
	IF (@action = 'INSERT' OR @action = 'UPDATE' OR @action = 'DELETE')
	BEGIN
		SET @value = 'id=' + (CASE WHEN (@id IS NOT NULL AND LEN(@id) > 0 AND CHARINDEX(@id, @strBlank) = 0) THEN ('"' + @id + '"') ELSE 'NULL' END) + ', ' +
					 'plcProvinceId=' + (CASE WHEN (@province IS NOT NULL AND LEN(@province) > 0 AND CHARINDEX(@province, @strBlank) = 0) THEN ('"' + @province + '"') ELSE 'NULL' END) + ', ' +
					 'thDistrictName=' + (CASE WHEN (@districtNameTH IS NOT NULL AND LEN(@districtNameTH) > 0 AND CHARINDEX(@districtNameTH, @strBlank) = 0) THEN ('"' + @districtNameTH + '"') ELSE 'NULL' END) + ', ' +
					 'enDistrictName=' + (CASE WHEN (@districtNameEN IS NOT NULL AND LEN(@districtNameEN) > 0 AND CHARINDEX(@districtNameEN, @strBlank) = 0) THEN ('"' + @districtNameEN + '"') ELSE 'NULL' END) + ', ' +
					 'zipCode=' + (CASE WHEN (@zipCode IS NOT NULL AND LEN(@zipCode) > 0 AND CHARINDEX(@zipCode, @strBlank) = 0) THEN ('"' + @zipCode + '"') ELSE 'NULL' END) + ', ' +
					 'cancel=' + (CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN ('"' + @cancelledStatus + '"') ELSE 'NULL' END)
					 
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
 					INSERT INTO plcDistrict
 					(
						id,
						plcProvinceId,
						thDistrictName,
						enDistrictName,
						zipCode,
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
						CASE WHEN (@province IS NOT NULL AND LEN(@province) > 0 AND CHARINDEX(@province, @strBlank) = 0) THEN @province ELSE NULL END,
						CASE WHEN (@districtNameTH IS NOT NULL AND LEN(@districtNameTH) > 0 AND CHARINDEX(@districtNameTH, @strBlank) = 0) THEN @districtNameTH ELSE NULL END,
						CASE WHEN (@districtNameEN IS NOT NULL AND LEN(@districtNameEN) > 0 AND CHARINDEX(@districtNameEN, @strBlank) = 0) THEN @districtNameEN ELSE NULL END,
						CASE WHEN (@zipCode IS NOT NULL AND LEN(@zipCode) > 0 AND CHARINDEX(@zipCode, @strBlank) = 0) THEN @zipCode ELSE NULL END,
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
						SET @rowCountUpdate = (SELECT COUNT(id) FROM plcDistrict WHERE id = @id)
						
						IF (@rowCountUpdate > 0)
						BEGIN
							IF (@action = 'UPDATE')
							BEGIN
								UPDATE plcDistrict SET
									plcProvinceId	= CASE WHEN (@province IS NOT NULL AND LEN(@province) > 0 AND CHARINDEX(@province, @strBlank) = 0) THEN @province ELSE (CASE WHEN (@province IS NOT NULL AND (LEN(@province) = 0 OR CHARINDEX(@province, @strBlank) > 0)) THEN NULL ELSE plcProvinceId END) END,
									thDistrictName	= CASE WHEN (@districtNameTH IS NOT NULL AND LEN(@districtNameTH) > 0 AND CHARINDEX(@districtNameTH, @strBlank) = 0) THEN @districtNameTH ELSE (CASE WHEN (@districtNameTH IS NOT NULL AND (LEN(@districtNameTH) = 0 OR CHARINDEX(@districtNameTH, @strBlank) > 0)) THEN NULL ELSE thDistrictName END) END,
									enDistrictName	= CASE WHEN (@districtNameEN IS NOT NULL AND LEN(@districtNameEN) > 0 AND CHARINDEX(@districtNameEN, @strBlank) = 0) THEN @districtNameEN ELSE (CASE WHEN (@districtNameEN IS NOT NULL AND (LEN(@districtNameEN) = 0 OR CHARINDEX(@districtNameEN, @strBlank) > 0)) THEN NULL ELSE enDistrictName END) END,
									zipCode			= CASE WHEN (@zipCode IS NOT NULL AND LEN(@zipCode) > 0 AND CHARINDEX(@zipCode, @strBlank) = 0) THEN @zipCode ELSE (CASE WHEN (@zipCode IS NOT NULL AND (LEN(@zipCode) = 0 OR CHARINDEX(@zipCode, @strBlank) > 0)) THEN NULL ELSE zipCode END) END,
									cancel			= CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN @cancelledStatus ELSE (CASE WHEN (@cancelledStatus IS NOT NULL AND (LEN(@cancelledStatus) = 0 OR CHARINDEX(@cancelledStatus, @strBlank) > 0)) THEN NULL ELSE cancel END) END,
									modifyDate		= GETDATE(),
									modifyBy		= CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE (CASE WHEN (@by IS NOT NULL AND (LEN(@by) = 0 OR CHARINDEX(@by, @strBlank) > 0)) THEN NULL ELSE modifyBy END) END,
									modifyIp		= CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE (CASE WHEN (@ip IS NOT NULL AND (LEN(@ip) = 0 OR CHARINDEX(@ip, @strBlank) > 0)) THEN NULL ELSE modifyIp END) END
								WHERE id = @id
							END
							
							IF (@action = 'DELETE')								
							BEGIN
								DELETE FROM plcDistrict WHERE id = @id
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
