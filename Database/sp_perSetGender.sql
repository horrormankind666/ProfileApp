USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetGender]    Script Date: 11/16/2015 16:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๕/๑๑/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perGender ครั้งละ ๑ เรคคอร์ด>
--  1. action			เป็น VARCHAR	รับค่าการกระทำกับฐานข้อมูล
--  2. id				เป็น VARCHAR	รับค่ารหัสเพศ
--  3. genderFullNameTH	เป็น NVARCHAR	รับค่าชื่อเต็มของเพศภาษาไทย
--  4. genderInitialsTH	เป็น NVARCHAR	รับค่าชื่อย่อของเพศภาษาไทย
--  5. genderFullNameEN	เป็น NVARCHAR	รับค่าชื่อเต็มของเพศภาษาอังกฤษ
--  6. genderInitialsEN เป็น NVARCHAR	รับค่าชื่อย่อของเพศภาษาอังกฤษ
--	7. cancelledStatus	เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  8. by				เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
--  9. ip				เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetGender]
(
	@action VARCHAR(10) = NULL,
	@id VARCHAR(2) = NULL,
	@genderFullNameTH NVARCHAR(255) = NULL,
	@genderInitialsTH NVARCHAR(10) = NULL,
	@genderFullNameEN NVARCHAR(255) = NULL,
	@genderInitialsEN NVARCHAR(10) = NULL,
	@cancelledStatus VARCHAR(1) = NULL,
	@by NVARCHAR(255) = NULL,
	@ip VARCHAR(255) = NULL
)	
AS
BEGIN
	SET NOCOUNT ON
	
	SET @action = LTRIM(RTRIM(@action))
	SET @id = LTRIM(RTRIM(@id))
	SET @genderFullNameTH = LTRIM(RTRIM(@genderFullNameTH))
	SET @genderInitialsTH = LTRIM(RTRIM(@genderInitialsTH))
	SET @genderFullNameEN = LTRIM(RTRIM(@genderFullNameEN))
	SET @genderInitialsEN = LTRIM(RTRIM(@genderInitialsEN))
	SET @cancelledStatus = LTRIM(RTRIM(@cancelledStatus))
	SET @by = LTRIM(RTRIM(@by))
	SET @ip = LTRIM(RTRIM(@ip))
	
	DECLARE @table VARCHAR(50) = 'perGender'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	
	SET @action = UPPER(@action)
	
	IF (@action = 'INSERT' OR @action = 'UPDATE' OR @action = 'DELETE')
	BEGIN
		SET @value = 'id=' + (CASE WHEN (@id IS NOT NULL AND LEN(@id) > 0 AND CHARINDEX(@id, @strBlank) = 0) THEN ('"' + @id + '"') ELSE 'NULL' END) + ', ' +
					 'thGenderFullName=' + (CASE WHEN (@genderFullNameTH IS NOT NULL AND LEN(@genderFullNameTH) > 0 AND CHARINDEX(@genderFullNameTH, @strBlank) = 0) THEN ('"' + @genderFullNameTH + '"') ELSE 'NULL' END) + ', ' +
					 'thGenderInitials=' + (CASE WHEN (@genderInitialsTH IS NOT NULL AND LEN(@genderInitialsTH) > 0 AND CHARINDEX(@genderInitialsTH, @strBlank) = 0) THEN ('"' + @genderInitialsTH + '"') ELSE 'NULL' END) + ', ' +
					 'enGenderFullName=' + (CASE WHEN (@genderFullNameEN IS NOT NULL AND LEN(@genderFullNameEN) > 0 AND CHARINDEX(@genderFullNameEN, @strBlank) = 0) THEN ('"' + @genderFullNameEN + '"') ELSE 'NULL' END) + ', ' +
					 'enGenderInitials=' + (CASE WHEN (@genderInitialsEN IS NOT NULL AND LEN(@genderInitialsEN) > 0 AND CHARINDEX(@genderInitialsEN, @strBlank) = 0) THEN ('"' + @genderInitialsEN + '"') ELSE 'NULL' END) + ', ' +
					 'cancel=' + (CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN ('"' + @cancelledStatus + '"') ELSE 'NULL' END)					 
					 
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
 					INSERT INTO perGender
 					(
						id,
						thGenderFullName,
						thGenderInitials,
						enGenderFullName,
						enGenderInitials,
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
						CASE WHEN (@genderFullNameTH IS NOT NULL AND LEN(@genderFullNameTH) > 0 AND CHARINDEX(@genderFullNameTH, @strBlank) = 0) THEN @genderFullNameTH ELSE NULL END,
						CASE WHEN (@genderInitialsTH IS NOT NULL AND LEN(@genderInitialsTH) > 0 AND CHARINDEX(@genderInitialsTH, @strBlank) = 0) THEN @genderInitialsTH ELSE NULL END,
						CASE WHEN (@genderFullNameEN IS NOT NULL AND LEN(@genderFullNameEN) > 0 AND CHARINDEX(@genderFullNameEN, @strBlank) = 0) THEN @genderFullNameEN ELSE NULL END,
						CASE WHEN (@genderInitialsEN IS NOT NULL AND LEN(@genderInitialsEN) > 0 AND CHARINDEX(@genderInitialsEN, @strBlank) = 0) THEN @genderInitialsEN ELSE NULL END,
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
						SET @rowCountUpdate = (SELECT COUNT(id) FROM perGender WHERE id = @id)
						
						IF (@rowCountUpdate > 0)
						BEGIN
							IF (@action = 'UPDATE')
							BEGIN
								UPDATE perGender SET
									thGenderFullName	= CASE WHEN (@genderFullNameTH IS NOT NULL AND LEN(@genderFullNameTH) > 0 AND CHARINDEX(@genderFullNameTH, @strBlank) = 0) THEN @genderFullNameTH ELSE (CASE WHEN (@genderFullNameTH IS NOT NULL AND (LEN(@genderFullNameTH) = 0 OR CHARINDEX(@genderFullNameTH, @strBlank) > 0)) THEN NULL ELSE thGenderFullName END) END,
									thGenderInitials	= CASE WHEN (@genderInitialsTH IS NOT NULL AND LEN(@genderInitialsTH) > 0 AND CHARINDEX(@genderInitialsTH, @strBlank) = 0) THEN @genderInitialsTH ELSE (CASE WHEN (@genderInitialsTH IS NOT NULL AND (LEN(@genderInitialsTH) = 0 OR CHARINDEX(@genderInitialsTH, @strBlank) > 0)) THEN NULL ELSE thGenderInitials END) END,
									enGenderFullName	= CASE WHEN (@genderFullNameEN IS NOT NULL AND LEN(@genderFullNameEN) > 0 AND CHARINDEX(@genderFullNameEN, @strBlank) = 0) THEN @genderFullNameEN ELSE (CASE WHEN (@genderFullNameEN IS NOT NULL AND (LEN(@genderFullNameEN) = 0 OR CHARINDEX(@genderFullNameEN, @strBlank) > 0)) THEN NULL ELSE enGenderFullName END) END,
									enGenderInitials	= CASE WHEN (@genderInitialsEN IS NOT NULL AND LEN(@genderInitialsEN) > 0 AND CHARINDEX(@genderInitialsEN, @strBlank) = 0) THEN @genderInitialsEN ELSE (CASE WHEN (@genderInitialsEN IS NOT NULL AND (LEN(@genderInitialsEN) = 0 OR CHARINDEX(@genderInitialsEN, @strBlank) > 0)) THEN NULL ELSE enGenderInitials END) END,
									cancel				= CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN @cancelledStatus ELSE (CASE WHEN (@cancelledStatus IS NOT NULL AND (LEN(@cancelledStatus) = 0 OR CHARINDEX(@cancelledStatus, @strBlank) > 0)) THEN NULL ELSE cancel END) END,
									modifyDate			= GETDATE(),
									modifyBy			= CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE (CASE WHEN (@by IS NOT NULL AND (LEN(@by) = 0 OR CHARINDEX(@by, @strBlank) > 0)) THEN NULL ELSE modifyBy END) END,
									modifyIp			= CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE (CASE WHEN (@ip IS NOT NULL AND (LEN(@ip) = 0 OR CHARINDEX(@ip, @strBlank) > 0)) THEN NULL ELSE modifyIp END) END
								WHERE id = @id	
							END
							
							IF (@action = 'DELETE')								
							BEGIN
								DELETE FROM perGender WHERE id = @id
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