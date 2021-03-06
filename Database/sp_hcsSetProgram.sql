USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_hcsSetProgram]    Script Date: 11/16/2015 15:29:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๓/๐๗/๒๕๕๘>
-- Description	: <สำหรับบันทึกข้อมูลตาราง  hcsProgram ครั้งละ ๑ เรคคอร์ด>
--	1. programId				เป็น VARCHAR	รับค่ารหัสหลักสูตร
--	2. hospital					เป็น VARCHAR	รับค่าหน่วยบริการสุขภาพ
--  3. activeRARegisForm		เป็น VARCHAR	รับค่าสถานะการใช้งานแบบฟอร์ม
--	4. activeSIRegisForm		เป็น VARCHAR	รับค่าสถานะการใช้งานแบบฟอร์ม
--  5. activeRAPatientRegisForm	เป็น VARCHAR	รับค่าสถานะการใช้งานแบบฟอร์ม
--	6. activeSIPatientRegisForm	เป็น VARCHAR	รับค่าสถานะการใช้งานแบบฟอร์ม
--	7. activeTMPatientRegisForm	เป็น VARCHAR	รับค่าสถานะการใช้งานแบบฟอร์ม
--	8. activeGJPatientRegisForm	เป็น VARCHAR	รับค่าสถานะการใช้งานแบบฟอร์ม
--	9. activeKN001Form			เป็น VARCHAR	รับค่าสถานะการใช้งานแบบฟอร์ม
-- 10. activeKN002Form			เป็น VARCHAR	รับค่าสถานะการใช้งานแบบฟอร์ม
-- 11. activeKN003Form			เป็น VARCHAR	รับค่าสถานะการใช้งานแบบฟอร์ม
-- 12. cancel					เป็น VARCHAR	รับค่าสถานะการยกเลิก
-- 13. by						เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- 14. ip						เป็น VARCHAR	รับค่าหมายเลขไอพี
-- =============================================
ALTER PROCEDURE [dbo].[sp_hcsSetProgram]
(
	@programId VARCHAR(15) = NULL,
	@hospital VARCHAR(15) = NULL,
	@activeRARegisForm VARCHAR(1) = NULL,	
	@activeSIRegisForm VARCHAR(1) = NULL,	
	@activeRAPatientRegisForm VARCHAR(1) = NULL,
	@activeSIPatientRegisForm VARCHAR(1) = NULL,
	@activeTMPatientRegisForm VARCHAR(1) = NULL,
	@activeGJPatientRegisForm NVARCHAR(1) = NULL,
	@activeKN001Form VARCHAR(1) = NULL,
	@activeKN002Form VARCHAR(1) = NULL,
	@activeKN003Form VARCHAR(1) = NULL,
	@cancel VARCHAR(1) = NULL,
	@by NVARCHAR(255) = NULL,
	@ip VARCHAR(255) = NULL
)	
AS
BEGIN
	SET NOCOUNT ON

	SET @programId = LTRIM(RTRIM(@programId))
	SET @hospital = LTRIM(RTRIM(@hospital))
	SET @activeRARegisForm = LTRIM(RTRIM(@activeRARegisForm))	
	SET @activeSIRegisForm = LTRIM(RTRIM(@activeSIRegisForm))
	SET @activeRAPatientRegisForm = LTRIM(RTRIM(@activeRAPatientRegisForm))
	SET @activeSIPatientRegisForm = LTRIM(RTRIM(@activeSIPatientRegisForm))
	SET @activeTMPatientRegisForm = LTRIM(RTRIM(@activeTMPatientRegisForm))
	SET @activeGJPatientRegisForm = LTRIM(RTRIM(@activeGJPatientRegisForm))
	SET @activeKN001Form = LTRIM(RTRIM(@activeKN001Form))
	SET @activeKN002Form = LTRIM(RTRIM(@activeKN002Form))
	SET @activeKN003Form = LTRIM(RTRIM(@activeKN003Form))
	SET @cancel = LTRIM(RTRIM(@cancel))
	SET @by = LTRIM(RTRIM(@by))
	SET @ip = LTRIM(RTRIM(@ip))
	
	DECLARE @action VARCHAR(10) = NULL	
	DECLARE @table VARCHAR(50) = 'hcsProgram'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	
	IF (@programId IS NOT NULL AND LEN(@programId) > 0)
	BEGIN
		SET @rowCountUpdate = (SELECT COUNT(acaProgramId) FROM Infinity..hcsProgram WHERE acaProgramId = @programId)
		SET @action = (CASE WHEN @rowCountUpdate = 0 THEN 'INSERT' ELSE 'UPDATE' END)		

		SET @value = 'acaProgramId='			+ (CASE WHEN (@programId IS NOT NULL AND LEN(@programId) > 0 AND CHARINDEX(@programId, @strBlank) = 0) THEN ('"' + @programId + '"') ELSE 'NULL' END) + ', ' +
					 'stdHSCHospitalId='		+ (CASE WHEN (@hospital IS NOT NULL AND LEN(@hospital) > 0 AND CHARINDEX(@hospital, @strBlank) = 0) THEN ('"' + @hospital + '"') ELSE 'NULL' END) + ', ' +
					 'showRARegisForm='			+ (CASE WHEN (@activeRARegisForm IS NOT NULL AND LEN(@activeRARegisForm) > 0 AND CHARINDEX(@activeRARegisForm, @strBlank) = 0) THEN ('"' + @activeRARegisForm + '"') ELSE 'NULL' END) + ', ' +
					 'showSIRegisForm='			+ (CASE WHEN (@activeSIRegisForm IS NOT NULL AND LEN(@activeSIRegisForm) > 0 AND CHARINDEX(@activeSIRegisForm, @strBlank) = 0) THEN ('"' + @activeSIRegisForm + '"') ELSE 'NULL' END) + ', ' +
					 'showRAPatientRegisForm='	+ (CASE WHEN (@activeRAPatientRegisForm IS NOT NULL AND LEN(@activeRAPatientRegisForm) > 0 AND CHARINDEX(@activeRAPatientRegisForm, @strBlank) = 0) THEN ('"' + @activeRAPatientRegisForm + '"') ELSE 'NULL' END) + ', ' +
					 'showSIPatientRegisForm='	+ (CASE WHEN (@activeSIPatientRegisForm IS NOT NULL AND LEN(@activeSIPatientRegisForm) > 0 AND CHARINDEX(@activeSIPatientRegisForm, @strBlank) = 0) THEN ('"' + @activeSIPatientRegisForm + '"') ELSE 'NULL' END) + ', ' +
					 'showTMPatientRegisForm='	+ (CASE WHEN (@activeTMPatientRegisForm IS NOT NULL AND LEN(@activeTMPatientRegisForm) > 0 AND CHARINDEX(@activeTMPatientRegisForm, @strBlank) = 0) THEN ('"' + @activeTMPatientRegisForm + '"') ELSE 'NULL' END) + ', ' +
					 'showGJPatientRegisForm='	+ (CASE WHEN (@activeGJPatientRegisForm IS NOT NULL AND LEN(@activeGJPatientRegisForm) > 0 AND CHARINDEX(@activeGJPatientRegisForm, @strBlank) = 0) THEN ('"' + @activeGJPatientRegisForm + '"') ELSE 'NULL' END) + ', ' +
					 'showKN001Form='			+ (CASE WHEN (@activeKN001Form IS NOT NULL AND LEN(@activeKN001Form) > 0 AND CHARINDEX(@activeKN001Form, @strBlank) = 0) THEN ('"' + @activeKN001Form + '"') ELSE 'NULL' END) + ', ' +
					 'showKN002Form='			+ (CASE WHEN (@activeKN002Form IS NOT NULL AND LEN(@activeKN002Form) > 0 AND CHARINDEX(@activeKN002Form, @strBlank) = 0) THEN ('"' + @activeKN002Form + '"') ELSE 'NULL' END) + ', ' +
					 'showKN003Form='			+ (CASE WHEN (@activeKN003Form IS NOT NULL AND LEN(@activeKN003Form) > 0 AND CHARINDEX(@activeKN003Form, @strBlank) = 0) THEN ('"' + @activeKN003Form + '"') ELSE 'NULL' END) + ', ' +
					 'cancel='					+ (CASE WHEN (@cancel IS NOT NULL AND LEN(@cancel) > 0 AND CHARINDEX(@cancel, @strBlank) = 0) THEN ('"' + @cancel + '"') ELSE 'NULL' END)
					 
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
 					INSERT INTO Infinity..hcsProgram
 					(
						acaProgramId,
						stdHSCHospitalId,
						showRARegisForm,
						showSIRegisForm,
						showRAPatientRegisForm,
						showSIPatientRegisForm,
						showTMPatientRegisForm,
						showGJPatientRegisForm,
						showKN001Form,
						showKN002Form,
						showKN003Form,
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
						CASE WHEN (@programId IS NOT NULL AND LEN(@programId) > 0 AND CHARINDEX(@programId, @strBlank) = 0) THEN @programId ELSE NULL END,
						CASE WHEN (@hospital IS NOT NULL AND LEN(@hospital) > 0 AND CHARINDEX(@hospital, @strBlank) = 0) THEN @hospital ELSE NULL END,
						CASE WHEN (@activeRARegisForm IS NOT NULL AND LEN(@activeRARegisForm) > 0 AND CHARINDEX(@activeRARegisForm, @strBlank) = 0) THEN @activeRARegisForm ELSE NULL END,
						CASE WHEN (@activeSIRegisForm IS NOT NULL AND LEN(@activeSIRegisForm) > 0 AND CHARINDEX(@activeSIRegisForm, @strBlank) = 0) THEN @activeSIRegisForm ELSE NULL END,
						CASE WHEN (@activeRAPatientRegisForm IS NOT NULL AND LEN(@activeRAPatientRegisForm) > 0 AND CHARINDEX(@activeRAPatientRegisForm, @strBlank) = 0) THEN @activeRAPatientRegisForm ELSE NULL END,
						CASE WHEN (@activeSIPatientRegisForm IS NOT NULL AND LEN(@activeSIPatientRegisForm) > 0 AND CHARINDEX(@activeSIPatientRegisForm, @strBlank) = 0) THEN @activeSIPatientRegisForm ELSE NULL END,
						CASE WHEN (@activeTMPatientRegisForm IS NOT NULL AND LEN(@activeTMPatientRegisForm) > 0 AND CHARINDEX(@activeTMPatientRegisForm, @strBlank) = 0) THEN @activeTMPatientRegisForm ELSE NULL END,
						CASE WHEN (@activeGJPatientRegisForm IS NOT NULL AND LEN(@activeGJPatientRegisForm) > 0 AND CHARINDEX(@activeGJPatientRegisForm, @strBlank) = 0) THEN @activeGJPatientRegisForm ELSE NULL END,
						CASE WHEN (@activeKN001Form IS NOT NULL AND LEN(@activeKN001Form) > 0 AND CHARINDEX(@activeKN001Form, @strBlank) = 0) THEN @activeKN001Form ELSE NULL END,
						CASE WHEN (@activeKN002Form IS NOT NULL AND LEN(@activeKN002Form) > 0 AND CHARINDEX(@activeKN002Form, @strBlank) = 0) THEN @activeKN002Form ELSE NULL END,
						CASE WHEN (@activeKN003Form IS NOT NULL AND LEN(@activeKN003Form) > 0 AND CHARINDEX(@activeKN003Form, @strBlank) = 0) THEN @activeKN003Form ELSE NULL END,
						CASE WHEN (@cancel IS NOT NULL AND LEN(@cancel) > 0 AND CHARINDEX(@cancel, @strBlank) = 0) THEN @cancel ELSE NULL END,
						GETDATE(),
						CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE NULL END,
						CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE NULL END,
						NULL,
						NULL,
						NULL												
					)		
					
					SET @rowCount = @rowCount + 1
				END					 
				
				IF (@action = 'UPDATE')
				BEGIN
					UPDATE Infinity..hcsProgram SET
						acaProgramId			= (CASE WHEN (@programId IS NOT NULL AND LEN(@programId) > 0 AND CHARINDEX(@programId, @strBlank) = 0) THEN @programId ELSE (CASE WHEN (@programId IS NOT NULL AND (LEN(@programId) = 0 OR CHARINDEX(@programId, @strBlank) > 0)) THEN NULL ELSE acaProgramId END) END),
						stdHSCHospitalId		= (CASE WHEN (@hospital IS NOT NULL AND LEN(@hospital) > 0 AND CHARINDEX(@hospital, @strBlank) = 0) THEN @hospital ELSE (CASE WHEN (@hospital IS NOT NULL AND (LEN(@hospital) = 0 OR CHARINDEX(@hospital, @strBlank) > 0)) THEN NULL ELSE stdHSCHospitalId END) END),
						showRARegisForm			= (CASE WHEN (@activeRARegisForm IS NOT NULL AND LEN(@activeRARegisForm) > 0 AND CHARINDEX(@activeRARegisForm, @strBlank) = 0) THEN @activeRARegisForm ELSE (CASE WHEN (@activeRARegisForm IS NOT NULL AND (LEN(@activeRARegisForm) = 0 OR CHARINDEX(@activeRARegisForm, @strBlank) > 0)) THEN NULL ELSE showRARegisForm END) END),
						showSIRegisForm			= (CASE WHEN (@activeSIRegisForm IS NOT NULL AND LEN(@activeSIRegisForm) > 0 AND CHARINDEX(@activeSIRegisForm, @strBlank) = 0) THEN @activeSIRegisForm ELSE (CASE WHEN (@activeSIRegisForm IS NOT NULL AND (LEN(@activeSIRegisForm) = 0 OR CHARINDEX(@activeSIRegisForm, @strBlank) > 0)) THEN NULL ELSE showSIRegisForm END) END),
						showRAPatientRegisForm	= (CASE WHEN (@activeRAPatientRegisForm IS NOT NULL AND LEN(@activeRAPatientRegisForm) > 0 AND CHARINDEX(@activeRAPatientRegisForm, @strBlank) = 0) THEN @activeRAPatientRegisForm ELSE (CASE WHEN (@activeRAPatientRegisForm IS NOT NULL AND (LEN(@activeRAPatientRegisForm) = 0 OR CHARINDEX(@activeRAPatientRegisForm, @strBlank) > 0)) THEN NULL ELSE showRAPatientRegisForm END) END),
						showSIPatientRegisForm	= (CASE WHEN (@activeSIPatientRegisForm IS NOT NULL AND LEN(@activeSIPatientRegisForm) > 0 AND CHARINDEX(@activeSIPatientRegisForm, @strBlank) = 0) THEN @activeSIPatientRegisForm ELSE (CASE WHEN (@activeSIPatientRegisForm IS NOT NULL AND (LEN(@activeSIPatientRegisForm) = 0 OR CHARINDEX(@activeSIPatientRegisForm, @strBlank) > 0)) THEN NULL ELSE showSIPatientRegisForm END) END),
						showTMPatientRegisForm	= (CASE WHEN (@activeTMPatientRegisForm IS NOT NULL AND LEN(@activeTMPatientRegisForm) > 0 AND CHARINDEX(@activeTMPatientRegisForm, @strBlank) = 0) THEN @activeTMPatientRegisForm ELSE (CASE WHEN (@activeTMPatientRegisForm IS NOT NULL AND (LEN(@activeTMPatientRegisForm) = 0 OR CHARINDEX(@activeTMPatientRegisForm, @strBlank) > 0)) THEN NULL ELSE showTMPatientRegisForm END) END),
						showGJPatientRegisForm	= (CASE WHEN (@activeGJPatientRegisForm IS NOT NULL AND LEN(@activeGJPatientRegisForm) > 0 AND CHARINDEX(@activeGJPatientRegisForm, @strBlank) = 0) THEN @activeGJPatientRegisForm ELSE (CASE WHEN (@activeGJPatientRegisForm IS NOT NULL AND (LEN(@activeGJPatientRegisForm) = 0 OR CHARINDEX(@activeGJPatientRegisForm, @strBlank) > 0)) THEN NULL ELSE showGJPatientRegisForm END) END),
						showKN001Form			= (CASE WHEN (@activeKN001Form IS NOT NULL AND LEN(@activeKN001Form) > 0 AND CHARINDEX(@activeKN001Form, @strBlank) = 0) THEN @activeKN001Form ELSE (CASE WHEN (@activeKN001Form IS NOT NULL AND (LEN(@activeKN001Form) = 0 OR CHARINDEX(@activeKN001Form, @strBlank) > 0)) THEN NULL ELSE showKN001Form END) END),
						showKN002Form			= (CASE WHEN (@activeKN002Form IS NOT NULL AND LEN(@activeKN002Form) > 0 AND CHARINDEX(@activeKN002Form, @strBlank) = 0) THEN @activeKN002Form ELSE (CASE WHEN (@activeKN002Form IS NOT NULL AND (LEN(@activeKN002Form) = 0 OR CHARINDEX(@activeKN002Form, @strBlank) > 0)) THEN NULL ELSE showKN002Form END) END),
						showKN003Form			= (CASE WHEN (@activeKN003Form IS NOT NULL AND LEN(@activeKN003Form) > 0 AND CHARINDEX(@activeKN003Form, @strBlank) = 0) THEN @activeKN003Form ELSE (CASE WHEN (@activeKN003Form IS NOT NULL AND (LEN(@activeKN003Form) = 0 OR CHARINDEX(@activeKN003Form, @strBlank) > 0)) THEN NULL ELSE showKN003Form END) END),
						cancel					= (CASE WHEN (@cancel IS NOT NULL AND LEN(@cancel) > 0 AND CHARINDEX(@cancel, @strBlank) = 0) THEN @cancel ELSE (CASE WHEN (@cancel IS NOT NULL AND (LEN(@cancel) = 0 OR CHARINDEX(@cancel, @strBlank) > 0)) THEN NULL ELSE cancel END) END),
						modifyDate				= GETDATE(),
						modifyBy				= (CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE NULL END),
						modifyIp				= (CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE NULL END)
					WHERE (acaProgramId = @programId)
					
					SET @rowCount = @rowCount + 1							
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
	
	SELECT @rowCount, @action
END