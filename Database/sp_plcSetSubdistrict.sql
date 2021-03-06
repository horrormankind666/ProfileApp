USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_plcSetSubdistrict]    Script Date: 11/16/2015 16:55:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๐๔/๑๑/๒๕๕๗>
-- Description	: <สำหรับบันทึกข้อมูลตาราง plcSubdistrict ครั้งละ ๑ เรคคอร์ด>
--  1. action				เป็น VARCHAR	รับค่าการกระทำกับฐานข้อมูล
--  2. id 					เป็น VARCHAR	รับค่ารหัสสถานที่หรือตำบล
--  3. district				เป็น VARCHAR	รับค่ารหัสอำเภอ
--  4. subdistrictNameTH	เป็น NVARCHAR	รับค่าชื่อสถานที่หรือตำบลภาษาไทย
--  5. subdistrictNameEN	เป็น NVARCHAR	รับค่าชื่อสถานที่หรือตำบลภาษาอังกฤษ
--  6. cancelledStatus		เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  7. by					เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
--	8. ip					เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_plcSetSubdistrict]
(
	@action VARCHAR(10) = NULL,
	@id VARCHAR(7) = NULL,
	@district VARCHAR(5) = NULL,
	@subdistrictNameTH NVARCHAR(255) = NULL,
	@subdistrictNameEN NVARCHAR(255) = NULL,
	@cancelledStatus VARCHAR(1) = NULL,
	@by NVARCHAR(255) = NULL,
	@ip VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @action = LTRIM(RTRIM(@action))
	SET @id = LTRIM(RTRIM(@id))
	SET @district = LTRIM(RTRIM(@district))
	SET @subdistrictNameTH = LTRIM(RTRIM(@subdistrictNameTH))
	SET @subdistrictNameEN = LTRIM(RTRIM(@subdistrictNameEN))
	SET @cancelledStatus = LTRIM(RTRIM(@cancelledStatus))
	SET @by = LTRIM(RTRIM(@by))
	SET @ip = LTRIM(RTRIM(@ip))
	
	DECLARE @table VARCHAR(50) = 'plcSubdistrict'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	
	SET @action = UPPER(@action)
	
	IF (@action = 'INSERT' OR @action = 'UPDATE' OR @action = 'DELETE')
	BEGIN
		SET @value = 'id=' + (CASE WHEN (@id IS NOT NULL AND LEN(@id) > 0 AND CHARINDEX(@id, @strBlank) = 0) THEN ('"' + @id + '"') ELSE 'NULL' END) + ', ' +
					 'plcDistrictId=' + (CASE WHEN (@district IS NOT NULL AND LEN(@district) > 0 AND CHARINDEX(@district, @strBlank) = 0) THEN ('"' + @district + '"') ELSE 'NULL' END) + ', ' +
					 'thSubdistrictName=' + (CASE WHEN (@subdistrictNameTH IS NOT NULL AND LEN(@subdistrictNameTH) > 0 AND CHARINDEX(@subdistrictNameTH, @strBlank) = 0) THEN ('"' + @subdistrictNameTH + '"') ELSE 'NULL' END) + ', ' +
					 'enSubdistrictName=' + (CASE WHEN (@subdistrictNameEN IS NOT NULL AND LEN(@subdistrictNameEN) > 0 AND CHARINDEX(@subdistrictNameEN, @strBlank) = 0) THEN ('"' + @subdistrictNameEN + '"') ELSE 'NULL' END) + ', ' +	 
					 'cancel=' + (CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN ('"' + @cancelledStatus + '"') ELSE 'NULL' END)				 
		
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
 					INSERT INTO plcSubdistrict
 					(
						id,
						plcDistrictId,
						thSubdistrictName,
						enSubdistrictName,
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
						CASE WHEN (@district IS NOT NULL AND LEN(@district) > 0 AND CHARINDEX(@district, @strBlank) = 0) THEN @district ELSE NULL END,
						CASE WHEN (@subdistrictNameTH IS NOT NULL AND LEN(@subdistrictNameTH) > 0 AND CHARINDEX(@subdistrictNameTH, @strBlank) = 0) THEN @subdistrictNameTH ELSE NULL END,
						CASE WHEN (@subdistrictNameEN IS NOT NULL AND LEN(@subdistrictNameEN) > 0 AND CHARINDEX(@subdistrictNameEN, @strBlank) = 0) THEN @subdistrictNameEN ELSE NULL END,
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
						SET @rowCountUpdate = (SELECT COUNT(id) FROM plcSubdistrict WHERE id = @id)
						
						IF (@rowCountUpdate > 0)
						BEGIN
							IF (@action = 'UPDATE')
							BEGIN
								UPDATE plcSubdistrict SET
									plcDistrictId		= CASE WHEN (@district IS NOT NULL AND LEN(@district) > 0 AND CHARINDEX(@district, @strBlank) = 0) THEN @district ELSE (CASE WHEN (@district IS NOT NULL AND (LEN(@district) = 0 OR CHARINDEX(@district, @strBlank) > 0)) THEN NULL ELSE plcDistrictId END) END,
									thSubdistrictName	= CASE WHEN (@subdistrictNameTH IS NOT NULL AND LEN(@subdistrictNameTH) > 0 AND CHARINDEX(@subdistrictNameTH, @strBlank) = 0) THEN @subdistrictNameTH ELSE (CASE WHEN (@subdistrictNameTH IS NOT NULL AND (LEN(@subdistrictNameTH) = 0 OR CHARINDEX(@subdistrictNameTH, @strBlank) > 0)) THEN NULL ELSE thSubdistrictName END) END,
									enSubdistrictName	= CASE WHEN (@subdistrictNameEN IS NOT NULL AND LEN(@subdistrictNameEN) > 0 AND CHARINDEX(@subdistrictNameEN, @strBlank) = 0) THEN @subdistrictNameEN ELSE (CASE WHEN (@subdistrictNameEN IS NOT NULL AND (LEN(@subdistrictNameEN) = 0 OR CHARINDEX(@subdistrictNameEN, @strBlank) > 0)) THEN NULL ELSE enSubdistrictName END) END,
									cancel				= CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN @cancelledStatus ELSE (CASE WHEN (@cancelledStatus IS NOT NULL AND (LEN(@cancelledStatus) = 0 OR CHARINDEX(@cancelledStatus, @strBlank) > 0)) THEN NULL ELSE cancel END) END,
									modifyDate			= GETDATE(),
									modifyBy			= CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE (CASE WHEN (@by IS NOT NULL AND (LEN(@by) = 0 OR CHARINDEX(@by, @strBlank) > 0)) THEN NULL ELSE modifyBy END) END,
									modifyIp			= CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE (CASE WHEN (@by IS NOT NULL AND (LEN(@by) = 0 OR CHARINDEX(@by, @strBlank) > 0)) THEN NULL ELSE modifyIp END) END
								WHERE id = @id
							END
							
							IF (@action = 'DELETE')								
							BEGIN
								DELETE FROM plcSubdistrict WHERE id = @id
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
