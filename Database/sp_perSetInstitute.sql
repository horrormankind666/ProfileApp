USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetInstitute]    Script Date: 14-06-2016 11:16:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๐๔/๑๑/๒๕๕๗>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perInstitute ครั้งละ ๑ เรคคอร์ด>
--  1. action			เป็น VARCHAR	รับค่าการกระทำกับฐานข้อมูล
--	2. id				เป็น VARCHAR	รับค่ารหัสโรงเรียน
--  3. province			เป็น VARCHAR	รับค่ารหัสจังหวัด
--  4. instituteNameTH	เป็น NVARCHAR	รับค่าชื่อสถาบัน / โรงเรียนภาษาไทย
--  5. instituteNameEN	เป็น NVARCHAR	รับค่าชื่อสถาบัน / โรงเรียนภาษาอังกฤษ
--  6. cancelledStatus	เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  7. by				เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
--	8. ip				เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetInstitute]
(
	@action VARCHAR(10) = NULL,
	@id VARCHAR(10) = NULL,
	@province VARCHAR(3) = NULL,
	@instituteNameTH NVARCHAR(255) = NULL,
	@instituteNameEN NVARCHAR(255) = NULL,
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
	SET @instituteNameTH = LTRIM(RTRIM(@instituteNameTH))
	SET @instituteNameEN = LTRIM(RTRIM(@instituteNameEN))	
	SET @cancelledStatus = LTRIM(RTRIM(@cancelledStatus))
	SET @by = LTRIM(RTRIM(@by))
	SET @ip = LTRIM(RTRIM(@ip))
	
	DECLARE @table VARCHAR(50) = 'perInstitute'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @exit int = 1
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	
	SET @action = UPPER(@action)
	
	IF (@action = 'INSERT' OR @action = 'UPDATE' OR @action = 'DELETE')
	BEGIN
		SET @value = 'id=' + (CASE WHEN (@id IS NOT NULL AND LEN(@id) > 0 AND CHARINDEX(@id, @strBlank) = 0) THEN ('"' + @id + '"') ELSE 'NULL' END) + ', ' +
					 'plcProvinceId=' + (CASE WHEN (@province IS NOT NULL AND LEN(@province) > 0 AND CHARINDEX(@province, @strBlank) = 0) THEN ('"' + @province + '"') ELSE 'NULL' END) + ', ' +
					 'institutelNameTH=' + (CASE WHEN (@instituteNameTH IS NOT NULL AND LEN(@instituteNameTH) > 0 AND CHARINDEX(@instituteNameTH, @strBlank) = 0) THEN ('"' + @instituteNameTH + '"') ELSE 'NULL' END) + ', ' +
					 'institutelNameEN=' + (CASE WHEN (@instituteNameEN IS NOT NULL AND LEN(@instituteNameEN) > 0 AND CHARINDEX(@instituteNameEN, @strBlank) = 0) THEN ('"' + @instituteNameEN + '"') ELSE 'NULL' END) + ', ' +
					 'cancelledStatus=' + (CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN ('"' + @cancelledStatus + '"') ELSE 'NULL' END)
					 
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN 													
					SET @rowCountUpdate = 1
					SET @id = (SELECT COUNT(id) FROM perInstitute)					

					WHILE (@exit = 1)
					BEGIN						
						IF (@exit = 1)
						BEGIN
							SET @id = @id + 1
							SET @id = (SELECT RIGHT('0000000000' + CONVERT(VARCHAR, @id), 10))
							SET @rowCountUpdate = (SELECT COUNT(id) FROM perInstitute WHERE id = @id)

							IF (@rowCountUpdate = 0) SET @exit = 0
						END
					END

					INSERT INTO perInstitute
 					(
						id,
						plcProvinceId,
						institutelNameTH,
						institutelNameEN,
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
						CASE WHEN (@province IS NOT NULL AND LEN(@province) > 0 AND CHARINDEX(@province, @strBlank) = 0) THEN @province ELSE NULL END,
						CASE WHEN (@instituteNameTH IS NOT NULL AND LEN(@instituteNameTH) > 0 AND CHARINDEX(@instituteNameTH, @strBlank) = 0) THEN @instituteNameTH ELSE NULL END,
						CASE WHEN (@instituteNameEN IS NOT NULL AND LEN(@instituteNameEN) > 0 AND CHARINDEX(@instituteNameEN, @strBlank) = 0) THEN @instituteNameEN ELSE NULL END,
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
						SET @rowCountUpdate = (SELECT COUNT(id) FROM perInstitute WHERE id = @id)
						
						IF (@rowCountUpdate > 0)
						BEGIN
							IF (@action = 'UPDATE')
							BEGIN
								UPDATE perInstitute SET									
									id					= CASE WHEN (@id IS NOT NULL AND LEN(@id) > 0 AND CHARINDEX(@id, @strBlank) = 0) THEN @id ELSE (CASE WHEN (@id IS NOT NULL AND (LEN(@id) = 0 OR CHARINDEX(@id, @strBlank) > 0)) THEN NULL ELSE id END) END,
									plcProvinceId		= CASE WHEN (@province IS NOT NULL AND LEN(@province) > 0 AND CHARINDEX(@province, @strBlank) = 0) THEN @province ELSE (CASE WHEN (@province IS NOT NULL AND (LEN(@province) = 0 OR CHARINDEX(@province, @strBlank) > 0)) THEN NULL ELSE plcProvinceId END) END,
									institutelNameTH	= CASE WHEN (@instituteNameTH IS NOT NULL AND LEN(@instituteNameTH) > 0 AND CHARINDEX(@instituteNameTH, @strBlank) = 0) THEN @instituteNameTH ELSE (CASE WHEN (@instituteNameTH IS NOT NULL AND (LEN(@instituteNameTH) = 0 OR CHARINDEX(@instituteNameTH, @strBlank) > 0)) THEN NULL ELSE institutelNameTH END) END,
									institutelNameEN	= CASE WHEN (@instituteNameEN IS NOT NULL AND LEN(@instituteNameEN) > 0 AND CHARINDEX(@instituteNameEN, @strBlank) = 0) THEN @instituteNameEN ELSE (CASE WHEN (@instituteNameEN IS NOT NULL AND (LEN(@instituteNameEN) = 0 OR CHARINDEX(@instituteNameEN, @strBlank) > 0)) THEN NULL ELSE institutelNameEN END) END,
									cancelledStatus		= CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN @cancelledStatus ELSE (CASE WHEN (@cancelledStatus IS NOT NULL AND (LEN(@cancelledStatus) = 0 OR CHARINDEX(@cancelledStatus, @strBlank) > 0)) THEN NULL ELSE cancelledStatus END) END,
									modifyDate			= GETDATE(),
									modifyBy			= CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE (CASE WHEN (@by IS NOT NULL AND (LEN(@by) = 0 OR CHARINDEX(@by, @strBlank) > 0)) THEN NULL ELSE modifyBy END) END,
									modifyIp			= CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE (CASE WHEN (@ip IS NOT NULL AND (LEN(@ip) = 0 OR CHARINDEX(@ip, @strBlank) > 0)) THEN NULL ELSE modifyIp END) END
								WHERE id = @id
							END
							
							IF (@action = 'DELETE')								
							BEGIN
								DELETE FROM perInstitute WHERE id = @id
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
