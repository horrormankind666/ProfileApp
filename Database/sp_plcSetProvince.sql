USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_plcSetProvince]    Script Date: 11/16/2015 16:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๙/๑๑/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง plcProvince ครั้งละ ๑ เรคคอร์ด>
--  1. action			เป็น VARCHAR	รับค่าการกระทำกับฐานข้อมูล
--  2. id 				เป็น VARCHAR	รับค่ารหัสจังหวัด
--  3. country			เป็น VARCHAR	รับค่ารหัสประเทศ
--  4. provinceNameTH	เป็น NVARCHAR	รับค่าชื่อจังหวัดภาษาไทย
--  5. provinceNameEN	เป็น NVARCHAR	รับค่าชื่อจังหวัดภาษาอังกฤษ
--	6. regionalName		เป็น NVARCHAR	รับค่าชื่อภาคที่จังหวัดตั้งอยู่
--  7. cancelledStatus	เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  8. by				เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
--	9. ip				เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_plcSetProvince]
(
	@action VARCHAR(10) = NULL,
	@id VARCHAR(3) = NULL,
	@country VARCHAR(3) = NULL,
	@provinceNameTH NVARCHAR(255) = NULL,
	@provinceNameEN NVARCHAR(255) = NULL,
	@regionalName NVARCHAR(50) = NULL,
	@cancelledStatus VARCHAR(1) = NULL,
	@by NVARCHAR(255) = NULL,
	@ip VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @action = LTRIM(RTRIM(@action))
	SET @id = LTRIM(RTRIM(@id))
	SET @country = LTRIM(RTRIM(@country))
	SET @provinceNameTH = LTRIM(RTRIM(@provinceNameTH))
	SET @provinceNameEN = LTRIM(RTRIM(@provinceNameEN))
	SET @regionalName = LTRIM(RTRIM(@regionalName))
	SET @cancelledStatus = LTRIM(RTRIM(@cancelledStatus))
	SET @by = LTRIM(RTRIM(@by))
	SET @ip = LTRIM(RTRIM(@ip))
	
	DECLARE @table VARCHAR(50) = 'plcProvince'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	
	SET @action = UPPER(@action)
	
	IF (@action = 'INSERT' OR @action = 'UPDATE' OR @action = 'DELETE')
	BEGIN
		SET @value = 'id=' + (CASE WHEN (@id IS NOT NULL AND LEN(@id) > 0 AND CHARINDEX(@id, @strBlank) = 0) THEN ('"' + @id + '"') ELSE 'NULL' END) + ', ' +
					 'plcCountryId=' + (CASE WHEN (@country IS NOT NULL AND LEN(@country) > 0 AND CHARINDEX(@country, @strBlank) = 0) THEN ('"' + @country + '"') ELSE 'NULL' END) + ', ' +
					 'provinceNameTH=' + (CASE WHEN (@provinceNameTH IS NOT NULL AND LEN(@provinceNameTH) > 0 AND CHARINDEX(@provinceNameTH, @strBlank) = 0) THEN ('"' + @provinceNameTH + '"') ELSE 'NULL' END) + ', ' +
					 'provinceNameEN=' + (CASE WHEN (@provinceNameEN IS NOT NULL AND LEN(@provinceNameEN) > 0 AND CHARINDEX(@provinceNameEN, @strBlank) = 0) THEN ('"' + @provinceNameEN + '"') ELSE 'NULL' END) + ', ' +
					 'regionalName=' + (CASE WHEN (@regionalName IS NOT NULL AND LEN(@regionalName) > 0 AND CHARINDEX(@regionalName, @strBlank) = 0) THEN ('"' + @regionalName + '"') ELSE 'NULL' END) + ', ' +
					 'cancelledStatus=' + (CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN ('"' + @cancelledStatus + '"') ELSE 'NULL' END)
					 
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
 					INSERT INTO plcProvince
 					(
						id,
						plcCountryId,
						provinceNameTH,
						provinceNameEN,
						regionalName,
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
						CASE WHEN (@id IS NOT NULL AND LEN(@id) > 0 AND CHARINDEX(@id, @strBlank) = 0) THEN @id ELSE NULL END,
						CASE WHEN (@country IS NOT NULL AND LEN(@country) > 0 AND CHARINDEX(@country, @strBlank) = 0) THEN @country ELSE NULL END,
						CASE WHEN (@provinceNameTH IS NOT NULL AND LEN(@provinceNameTH) > 0 AND CHARINDEX(@provinceNameTH, @strBlank) = 0) THEN @provinceNameTH ELSE NULL END,
						CASE WHEN (@provinceNameEN IS NOT NULL AND LEN(@provinceNameEN) > 0 AND CHARINDEX(@provinceNameEN, @strBlank) = 0) THEN @provinceNameEN ELSE NULL END,
						CASE WHEN (@regionalName IS NOT NULL AND LEN(@regionalName) > 0 AND CHARINDEX(@regionalName, @strBlank) = 0) THEN @regionalName ELSE NULL END,
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
						SET @rowCountUpdate = (SELECT COUNT(id) FROM plcProvince WHERE id = @id)
						
						IF (@rowCountUpdate > 0)
						BEGIN
							IF (@action = 'UPDATE')
							BEGIN
								UPDATE plcProvince SET
									plcCountryId	= CASE WHEN (@country IS NOT NULL AND LEN(@country) > 0 AND CHARINDEX(@country, @strBlank) = 0) THEN @country ELSE (CASE WHEN (@country IS NOT NULL AND (LEN(@country) = 0 OR CHARINDEX(@country, @strBlank) > 0)) THEN NULL ELSE plcCountryId END) END,
									provinceNameTH	= CASE WHEN (@provinceNameTH IS NOT NULL AND LEN(@provinceNameTH) > 0 AND CHARINDEX(@provinceNameTH, @strBlank) = 0) THEN @provinceNameTH ELSE (CASE WHEN (@provinceNameTH IS NOT NULL AND (LEN(@provinceNameTH) = 0 OR CHARINDEX(@provinceNameTH, @strBlank) > 0)) THEN NULL ELSE provinceNameTH END) END,
									provinceNameEN	= CASE WHEN (@provinceNameEN IS NOT NULL AND LEN(@provinceNameEN) > 0 AND CHARINDEX(@provinceNameEN, @strBlank) = 0) THEN @provinceNameEN ELSE (CASE WHEN (@provinceNameEN IS NOT NULL AND (LEN(@provinceNameEN) = 0 OR CHARINDEX(@provinceNameEN, @strBlank) > 0)) THEN NULL ELSE provinceNameEN END) END,
									regionalName	= CASE WHEN (@regionalName IS NOT NULL AND LEN(@regionalName) > 0 AND CHARINDEX(@regionalName, @strBlank) = 0) THEN @regionalName ELSE (CASE WHEN (@regionalName IS NOT NULL AND (LEN(@regionalName) = 0 OR CHARINDEX(@regionalName, @strBlank) > 0)) THEN NULL ELSE regionalName END) END,
									cancelledStatus	= CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN @cancelledStatus ELSE (CASE WHEN (@cancelledStatus IS NOT NULL AND (LEN(@cancelledStatus) = 0 OR CHARINDEX(@cancelledStatus, @strBlank) > 0)) THEN NULL ELSE cancelledStatus END) END,
									modifyDate		= GETDATE(),
									modifyBy		= CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE (CASE WHEN (@by IS NOT NULL AND (LEN(@by) = 0 OR CHARINDEX(@by, @strBlank) > 0)) THEN NULL ELSE modifyBy END) END,
									modifyIp		= CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE (CASE WHEN (@ip IS NOT NULL AND (LEN(@ip) = 0 OR CHARINDEX(@ip, @strBlank) > 0)) THEN NULL ELSE modifyIp END) END
								WHERE id = @id
							END
							
							IF (@action = 'DELETE')								
							BEGIN
								DELETE FROM plcProvince WHERE id = @id
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
