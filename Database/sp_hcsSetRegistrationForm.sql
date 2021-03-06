USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_hcsSetRegistrationForm]    Script Date: 12/02/2015 07:18:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๐๒/๑๒/๒๕๕๘>
-- Description	: <สำหรับบันทึกข้อมูลตาราง hcsForm ครั้งละ ๑ เรคคอร์ด>
--  1. action			เป็น VARCHAR	รับค่าการกระทำกับฐานข้อมูล
--  2. id 				เป็น NVARCHAR	รับค่ารหัสแบบฟอร์มบริการสุขภาพ
--  3. formNameTH		เป็น NVARCHAR	รับค่าชื่อ
--  4. formNameEN		เป็น NVARCHAR	รับค่าชื่อภาษาอังกฤษ
--	5. forPublicServant	เป็น VARCHAR	รับค่าแบบฟอร์มสำหรับข้าราชการ
--	6. orderForm		เป็น VARCHAR	รับค่าลำดับแบบฟอร์ม
--  7. cancelledStatus	เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  8. by				เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
--  9. ip				เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_hcsSetRegistrationForm]
(
	@action VARCHAR(10) = NULL,
	@id NVARCHAR(50) = NULL,
	@formNameTH NVARCHAR(255) = NULL,
	@formNameEN NVARCHAR(255) = NULL,
	@forPublicServant VARCHAR(1) = NULL,
	@orderForm VARCHAR(2) = NULL,
	@cancelledStatus VARCHAR(1) = NULLL,
	@by NVARCHAR(255) = NULL,
	@ip VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @action = LTRIM(RTRIM(@action))
	SET @id = LTRIM(RTRIM(@id))
	SET @formNameTH = LTRIM(RTRIM(@formNameTH))
	SET @formNameEN = LTRIM(RTRIM(@formNameEN))
	SET @forPublicServant = LTRIM(RTRIM(@forPublicServant))
	SET @orderForm = LTRIM(RTRIM(@orderForm))
	SET @cancelledStatus = LTRIM(RTRIM(@cancelledStatus))
	SET @by = LTRIM(RTRIM(@by))
	SET @ip = LTRIM(RTRIM(@ip))
		
	DECLARE @table VARCHAR(50) = 'hcsForm'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	
	SET @action = UPPER(@action)
	
	IF (@action = 'INSERT' OR @action = 'UPDATE' OR @action = 'DELETE')
	BEGIN
		SET @value = 'id=' +				(CASE WHEN (@id IS NOT NULL AND LEN(@id) > 0 AND CHARINDEX(@id, @strBlank) = 0) THEN ('"' + @id + '"') ELSE 'NULL' END) + ', ' +
					 'formNameTH=' +		(CASE WHEN (@formNameTH IS NOT NULL AND LEN(@formNameTH) > 0 AND CHARINDEX(@formNameTH, @strBlank) = 0) THEN ('"' + @formNameTH + '"') ELSE 'NULL' END) + ', ' +
					 'formNameEN=' +		(CASE WHEN (@formNameEN IS NOT NULL AND LEN(@formNameEN) > 0 AND CHARINDEX(@formNameEN, @strBlank) = 0) THEN ('"' + @formNameEN + '"') ELSE 'NULL' END) + ', ' +
					 'forPublicServant=' +	(CASE WHEN (@forPublicServant IS NOT NULL AND LEN(@forPublicServant) > 0 AND CHARINDEX(@forPublicServant, @strBlank) = 0) THEN ('"' + @forPublicServant + '"') ELSE 'NULL' END) + ', ' +
					 'orderForm=' +			(CASE WHEN (@orderForm IS NOT NULL AND LEN(@orderForm) > 0 AND CHARINDEX(@orderForm, @strBlank) = 0) THEN ('"' + @orderForm + '"') ELSE 'NULL' END) + ', ' +
					 'cancelledStatus=' +	(CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN ('"' + @cancelledStatus + '"') ELSE 'NULL' END)
					 					 
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
					IF (@id IS NOT NULL AND LEN(@id) > 0 AND CHARINDEX(@id, @strBlank) = 0)
					BEGIN
						SET @rowCountUpdate = (SELECT COUNT(id) FROM Infinity..hcsForm WHERE id = @id)
						
						IF (@rowCountUpdate = 0)
						BEGIN
 							INSERT INTO Infinity..hcsForm
 							(
								id,
								thFormName,
								enFormName,
								forPublicServant,
								orderForm,
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
								CASE WHEN (@formNameTH IS NOT NULL AND LEN(@formNameTH) > 0 AND CHARINDEX(@formNameTH, @strBlank) = 0) THEN @formNameTH ELSE NULL END,
								CASE WHEN (@formNameEN IS NOT NULL AND LEN(@formNameEN) > 0 AND CHARINDEX(@formNameEN, @strBlank) = 0) THEN @formNameEN ELSE NULL END,
								CASE WHEN (@forPublicServant IS NOT NULL AND LEN(@forPublicServant) > 0 AND CHARINDEX(@forPublicServant, @strBlank) = 0) THEN @forPublicServant ELSE NULL END,
								CASE WHEN (@orderForm IS NOT NULL AND LEN(@orderForm) > 0 AND CHARINDEX(@orderForm, @strBlank) = 0) THEN @orderForm ELSE NULL END,
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
						SET @rowCountUpdate = (SELECT COUNT(id) FROM Infinity..hcsForm WHERE id = @id)
						
						IF (@rowCountUpdate > 0)
						BEGIN
							IF (@action = 'UPDATE')
							BEGIN
								UPDATE Infinity..hcsForm SET
									thFormName			= CASE WHEN (@formNameTH IS NOT NULL AND LEN(@formNameTH) > 0 AND CHARINDEX(@formNameTH, @strBlank) = 0) THEN @formNameTH ELSE (CASE WHEN (@formNameTH IS NOT NULL AND (LEN(@formNameTH) = 0 OR CHARINDEX(@formNameTH, @strBlank) > 0)) THEN NULL ELSE thFormName END) END,
									enFormName			= CASE WHEN (@formNameEN IS NOT NULL AND LEN(@formNameEN) > 0 AND CHARINDEX(@formNameEN, @strBlank) = 0) THEN @formNameEN ELSE (CASE WHEN (@formNameEN IS NOT NULL AND (LEN(@formNameEN) = 0 OR CHARINDEX(@formNameEN, @strBlank) > 0)) THEN NULL ELSE enFormName END) END,
									forPublicServant	= CASE WHEN (@forPublicServant IS NOT NULL AND LEN(@forPublicServant) > 0 AND CHARINDEX(@forPublicServant, @strBlank) = 0) THEN @forPublicServant ELSE (CASE WHEN (@forPublicServant IS NOT NULL AND (LEN(@forPublicServant) = 0 OR CHARINDEX(@forPublicServant, @strBlank) > 0)) THEN NULL ELSE forPublicServant END) END,
									orderForm			= CASE WHEN (@orderForm IS NOT NULL AND LEN(@orderForm) > 0 AND CHARINDEX(@orderForm, @strBlank) = 0) THEN @orderForm ELSE (CASE WHEN (@orderForm IS NOT NULL AND (LEN(@orderForm) = 0 OR CHARINDEX(@orderForm, @strBlank) > 0)) THEN NULL ELSE orderForm END) END,									
									cancel				= CASE WHEN (@cancelledStatus IS NOT NULL AND LEN(@cancelledStatus) > 0 AND CHARINDEX(@cancelledStatus, @strBlank) = 0) THEN @cancelledStatus ELSE (CASE WHEN (@cancelledStatus IS NOT NULL AND (LEN(@cancelledStatus) = 0 OR CHARINDEX(@cancelledStatus, @strBlank) > 0)) THEN NULL ELSE cancel END) END,
									modifyDate			= GETDATE(),
									modifyBy			= CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE (CASE WHEN (@by IS NOT NULL AND (LEN(@by) = 0 OR CHARINDEX(@by, @strBlank) > 0)) THEN NULL ELSE modifyBy END) END,
									modifyIp			= CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE (CASE WHEN (@ip IS NOT NULL AND (LEN(@ip) = 0 OR CHARINDEX(@ip, @strBlank) > 0)) THEN NULL ELSE modifyIp END) END
								WHERE id = @id
							END								
							
							IF (@action = 'DELETE')
							BEGIN
								DELETE FROM Infinity..hcsForm WHERE id = @id
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
