USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_hcsSetHospital]    Script Date: 12/02/2015 07:45:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๓๐/๑๑/๒๕๕๘>
-- Description	: <สำหรับบันทึกข้อมูลตาราง hcsHospital ครั้งละ ๑ เรคคอร์ด>
--  1. action					เป็น VARCHAR	รับค่าการกระทำกับฐานข้อมูล
--  2. id 						เป็น VARCHAR	รับค่ารหัสหน่วยบริการสุขภาพ
--  3. hospitalNameTH			เป็น NVARCHAR	รับค่าชื่อ
--  4. hospitalNameEN			เป็น NVARCHAR	รับค่าชื่อภาษาอังกฤษ
--  5. cancelledStatus			เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  6. by						เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
--  7. ip						เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_hcsSetHospital]
(
	@action VARCHAR(10) = NULL,
	@id VARCHAR(10) = NULL,
	@hospitalNameTH NVARCHAR(255) = NULL,
	@hospitalNameEN NVARCHAR(255) = NULL,
	@cancelledStatus VARCHAR(1) = NULLL,
	@by NVARCHAR(255) = NULL,
	@ip VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @action = LTRIM(RTRIM(@action))
	SET @id = LTRIM(RTRIM(@id))
	SET @hospitalNameTH = LTRIM(RTRIM(@hospitalNameTH))
	SET @hospitalNameEN = LTRIM(RTRIM(@hospitalNameEN))
	SET @cancelledStatus = LTRIM(RTRIM(@cancelledStatus))
	SET @by = LTRIM(RTRIM(@by))
	SET @ip = LTRIM(RTRIM(@ip))
		
	DECLARE @table VARCHAR(50) = 'hcsHospital'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	
	SET @action = UPPER(@action)
	
	IF (@action = 'INSERT' OR @action = 'UPDATE' OR @action = 'DELETE')
	BEGIN
		SET @value = 'id=' +				(CASE WHEN (@id IS NOT NULL AND LEN(@id) > 0 AND CHARINDEX(@id, @strBlank) = 0) THEN ('"' + @id + '"') ELSE 'NULL' END) + ', ' +
					 'hospitalNameTH=' +	(CASE WHEN (@hospitalNameTH IS NOT NULL AND LEN(@hospitalNameTH) > 0 AND CHARINDEX(@hospitalNameTH, @strBlank) = 0) THEN ('"' + @hospitalNameTH + '"') ELSE 'NULL' END) + ', ' +
					 'hospitalNameEN=' +	(CASE WHEN (@hospitalNameEN IS NOT NULL AND LEN(@hospitalNameEN) > 0 AND CHARINDEX(@hospitalNameEN, @strBlank) = 0) THEN ('"' + @hospitalNameEN + '"') ELSE 'NULL' END) + ', ' +
					 'cancelledStatus=' +	(CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN ('"' + @cancelledStatus + '"') ELSE 'NULL' END)
					 					 
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
					IF (@id IS NOT NULL AND LEN(@id) > 0 AND CHARINDEX(@id, @strBlank) = 0)
					BEGIN
						SET @rowCountUpdate = (SELECT COUNT(id) FROM Infinity..hcsHospital WHERE id = @id)
						
						IF (@rowCountUpdate = 0)
						BEGIN
 							INSERT INTO Infinity..hcsHospital
 							(
								id,
								thHospitalName,
								enHospitalName,
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
								CASE WHEN (@hospitalNameTH IS NOT NULL AND LEN(@hospitalNameTH) > 0 AND CHARINDEX(@hospitalNameTH, @strBlank) = 0) THEN @hospitalNameTH ELSE NULL END,
								CASE WHEN (@hospitalNameEN IS NOT NULL AND LEN(@hospitalNameEN) > 0 AND CHARINDEX(@hospitalNameEN, @strBlank) = 0) THEN @hospitalNameEN ELSE NULL END,
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
					END										
				END
				
				IF (@action = 'UPDATE' OR @action = 'DELETE')					
				BEGIN
					IF (@id IS NOT NULL AND LEN(@id) > 0 AND CHARINDEX(@id, @strBlank) = 0)
					BEGIN
						SET @rowCountUpdate = (SELECT COUNT(id) FROM Infinity..hcsHospital WHERE id = @id)
						
						IF (@rowCountUpdate > 0)
						BEGIN
							IF (@action = 'UPDATE')
							BEGIN
								UPDATE Infinity..hcsHospital SET
									thHospitalName	= CASE WHEN (@hospitalNameTH IS NOT NULL AND LEN(@hospitalNameTH) > 0 AND CHARINDEX(@hospitalNameTH, @strBlank) = 0) THEN @hospitalNameTH ELSE (CASE WHEN (@hospitalNameTH IS NOT NULL AND (LEN(@hospitalNameTH) = 0 OR CHARINDEX(@hospitalNameTH, @strBlank) > 0)) THEN NULL ELSE thHospitalName END) END,
									enHospitalName	= CASE WHEN (@hospitalNameEN IS NOT NULL AND LEN(@hospitalNameEN) > 0 AND CHARINDEX(@hospitalNameEN, @strBlank) = 0) THEN @hospitalNameEN ELSE (CASE WHEN (@hospitalNameEN IS NOT NULL AND (LEN(@hospitalNameEN) = 0 OR CHARINDEX(@hospitalNameEN, @strBlank) > 0)) THEN NULL ELSE enHospitalName END) END,
									cancel			= CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN @cancelledStatus ELSE (CASE WHEN (@cancelledStatus IS NOT NULL AND (LEN(@cancelledStatus) = 0 OR CHARINDEX(@cancelledStatus, @strBlank) > 0)) THEN NULL ELSE cancel END) END,
									modifyDate		= GETDATE(),
									modifyBy		= CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE (CASE WHEN (@by IS NOT NULL AND (LEN(@by) = 0 OR CHARINDEX(@by, @strBlank) > 0)) THEN NULL ELSE modifyBy END) END,
									modifyIp		= CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE (CASE WHEN (@ip IS NOT NULL AND (LEN(@ip) = 0 OR CHARINDEX(@ip, @strBlank) > 0)) THEN NULL ELSE modifyIp END) END
								WHERE id = @id
							END								
							
							IF (@action = 'DELETE')
							BEGIN
								DELETE FROM Infinity..hcsHospital WHERE id = @id
							END
							
							SET @rowCount = @rowCount + 1							
						END							
					END				
				END								
			COMMIT TRAN									
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
			INSERT INTO InfinityLog..hcsErrorLog
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
