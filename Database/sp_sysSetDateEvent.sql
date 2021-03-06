USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_sysSetDateEvent]    Script Date: 06/15/2015 08:39:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๘/๑๑/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perReligion ครั้งละ ๑ เรคคอร์ด>
--  1. action			เป็น VARCHAR	รับค่าการกระทำกับฐานข้อมูล
--	2. sysName			เป็น VARCHAR	รับค่าชื่อระบบ
--	3. sysEvent			เป็น VARCHAR	รับค่าชื่อเหตุการณ์
--  4. startDate 		เป็น VARCHAR	รับค่าวันทำการเริ่มต้น
--  5. startTime 		เป็น VARCHAR	รับค่าเวลาทำการเริ่มต้น
--  6. endDate 			เป็น VARCHAR	รับค่าวันทำการสิ้นสุด
--  7. endTime 			เป็น VARCHAR	รับค่าเวลาทำการสิ้นสุด
--	8. yearEntry		เป็น VARCHAR	รับค่าปีที่เข้าศึกษาของนักศึกษา
--	9. entranceType		เป็น VARCHAR	รับค่าระบบการสอบเข้า
-- 10. facultyprogram	เป็น VARCHAR	รับค่าคณะและหลักสูตร
-- 11. cancel			เป็น VARCHAR	รับค่าสถานะการยกเลิก
-- 12. by				เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_sysSetDateEvent]
(
	@action VARCHAR(10) = NULL,
	@sysName VARCHAR(MAX) = NULL,
	@sysEvent VARCHAR(MAX) = NULL,
	@startDate VARCHAR(MAX) = NULL,
	@startTime VARCHAR(MAX) = NULL,
	@endDate VARCHAR(MAX) = NULL,
	@endTime VARCHAR(MAX) = NULL,
	@yearEntry VARCHAR(MAX) = NULL,
	@entranceType VARCHAR(MAX) = NULL,
	@facultyprogram VARCHAR(MAX) = NULL,
	@cancel VARCHAR(MAX) = NULL,
	@by NVARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @action = LTRIM(RTRIM(@action))
	SET @sysName = LTRIM(RTRIM(@sysName))
	SET @sysEvent = LTRIM(RTRIM(@sysEvent))
	SET @startDate = LTRIM(RTRIM(@startDate))
	SET @startTime = LTRIM(RTRIM(@startTime))
	SET @endDate = LTRIM(RTRIM(@endDate))
	SET @endTime = LTRIM(RTRIM(@endTime))
	SET @yearEntry = LTRIM(RTRIM(@yearEntry))
	SET @entranceType = LTRIM(RTRIM(@entranceType))
	SET @facultyprogram = LTRIM(RTRIM(@facultyprogram))
	SET @cancel = LTRIM(RTRIM(@cancel))
	SET @by = LTRIM(RTRIM(@by))
	
	DECLARE @table VARCHAR(50) = 'sysDateEvent'		
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	DECLARE @ip VARCHAR(255) = dbo.fnc_perGetIP()
	DECLARE @startDateTime VARCHAR(MAX) = NULL
	DECLARE @endDateTime VARCHAR(MAX) = NULL
		
	IF (@startDate IS NOT NULL AND LEN(@startDate) > 0 AND CHARINDEX(@startDate, @strBlank) = 0)
	BEGIN
		SET @startDateTime = @startDate
		
		IF (@startTime IS NOT NULL AND LEN(@startTime) > 0 AND CHARINDEX(@startTime, @strBlank) = 0)
			SET @startDateTime = (@startDateTime + ' ' + @startTime)
	END			
	
	IF (@endDate IS NOT NULL AND LEN(@endDate) > 0 AND CHARINDEX(@endDate, @strBlank) = 0)
	BEGIN
		SET @endDateTime = @endDate
		
		IF (@endTime IS NOT NULL AND LEN(@endTime) > 0 AND CHARINDEX(@endTime, @strBlank) = 0)
			SET @endDateTime = (@endDateTime + ' ' + @endTime)
	END
		
	IF (@action IS NULL OR LEN(@action) = 0)
	BEGIN
		SET @rowCount = (SELECT COUNT(id) FROM sysDateEvent WHERE (sysName = @sysName AND sysEvent = @sysEvent))	
		SET @action = (CASE WHEN @rowCount > 0 THEN 'UPDATE' ELSE 'INSERT' END)
	END		
	
	SET @rowCount = 0
	SET @action = UPPER(@action)
	
	IF (@action = 'INSERT' OR @action = 'UPDATE' OR @action = 'DELETE')
	BEGIN
		SET @value = 'sysName=' + (CASE WHEN (@sysName IS NOT NULL AND LEN(@sysName) > 0 AND CHARINDEX(@sysName, @strBlank) = 0) THEN ('"' + @sysName + '"') ELSE 'NULL' END) + ', ' +
					 'sysEvent=' + (CASE WHEN (@sysEvent IS NOT NULL AND LEN(@sysEvent) > 0 AND CHARINDEX(@sysEvent, @strBlank) = 0) THEN ('"' + @sysEvent + '"') ELSE 'NULL' END) + ', ' +
					 'startDate=' + (CASE WHEN (@startDateTime IS NOT NULL AND LEN(@startDateTime) > 0 AND CHARINDEX(@startDateTime, @strBlank) = 0) THEN ('"' + @startDateTime + '"') ELSE 'NULL' END) + ', ' +
					 'endDate=' + (CASE WHEN (@endDateTime IS NOT NULL AND LEN(@endDateTime) > 0 AND CHARINDEX(@endDateTime, @strBlank) = 0) THEN ('"' + @endDateTime + '"') ELSE 'NULL' END) + ', ' +
					 'yearEntry=' + (CASE WHEN (@yearEntry IS NOT NULL AND LEN(@yearEntry) > 0 AND CHARINDEX(@yearEntry, @strBlank) = 0) THEN ('"' + @yearEntry + '"') ELSE 'NULL' END) + ', ' +
					 'entranceType=' + (CASE WHEN (@entranceType IS NOT NULL AND LEN(@entranceType) > 0 AND CHARINDEX(@entranceType, @strBlank) = 0) THEN ('"' + @entranceType + '"') ELSE 'NULL' END) + ', ' +
					 'facultyprogram=' + (CASE WHEN (@facultyprogram IS NOT NULL AND LEN(@facultyprogram) > 0 AND CHARINDEX(@facultyprogram, @strBlank) = 0) THEN ('"' + @facultyprogram + '"') ELSE 'NULL' END) + ', ' +
					 'cancelStatus=' + (CASE WHEN (@cancel IS NOT NULL AND LEN(@cancel) > 0 AND CHARINDEX(@cancel, @strBlank) = 0) THEN ('"' + @cancel + '"') ELSE 'NULL' END)
	
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
 					INSERT INTO sysDateEvent
 					(
						sysName,
						sysEvent,
						startDate,
						endDate,
						yearEntry,
						entranceType,
						facultyprogram,
						fileName,
						cancelStatus,						
						createdBy,
						createdDate,
						remark					
					)
					VALUES
					(
						CASE WHEN (@sysName IS NOT NULL AND LEN(@sysName) > 0 AND CHARINDEX(@sysName, @strBlank) = 0) THEN @sysName ELSE NULL END,
						CASE WHEN (@sysEvent IS NOT NULL AND LEN(@sysEvent) > 0 AND CHARINDEX(@sysEvent, @strBlank) = 0) THEN @sysEvent ELSE NULL END,
						CASE WHEN (@startDateTime IS NOT NULL AND LEN(@startDateTime) > 0 AND CHARINDEX(@startDateTime, @strBlank) = 0) THEN CONVERT(DATETIME, @startDateTime, 103) ELSE NULL END,												
						CASE WHEN (@endDateTime IS NOT NULL AND LEN(@endDateTime) > 0 AND CHARINDEX(@endDateTime, @strBlank) = 0) THEN CONVERT(DATETIME, @endDateTime, 103) ELSE NULL END,												
						CASE WHEN (@yearEntry IS NOT NULL AND LEN(@yearEntry) > 0 AND CHARINDEX(@yearEntry, @strBlank) = 0) THEN @yearEntry ELSE NULL END,																		
						CASE WHEN (@entranceType IS NOT NULL AND LEN(@entranceType) > 0 AND CHARINDEX(@entranceType, @strBlank) = 0) THEN @entranceType ELSE NULL END,																		
						CASE WHEN (@facultyprogram IS NOT NULL AND LEN(@facultyprogram) > 0 AND CHARINDEX(@facultyprogram, @strBlank) = 0) THEN @facultyprogram ELSE NULL END,
						NULL,
						CASE WHEN (@cancel IS NOT NULL AND LEN(@cancel) > 0 AND CHARINDEX(@cancel, @strBlank) = 0) THEN @cancel ELSE NULL END,						
						CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE NULL END,
						GETDATE(),
						NULL
					)		
					
					SET @rowCount = @rowCount + 1
				END
				
				IF (@action = 'UPDATE' OR @action = 'DELETE')					
				BEGIN
					IF ((@sysName IS NOT NULL AND LEN(@sysName) > 0 AND CHARINDEX(@sysName, @strBlank) = 0) AND
						(@sysEvent IS NOT NULL AND LEN(@sysEvent) > 0 AND CHARINDEX(@sysEvent, @strBlank) = 0))
					BEGIN
						SET @rowCountUpdate = (SELECT COUNT(id) FROM sysDateEvent WHERE (sysName = @sysName AND sysEvent = @sysEvent))
						
						IF (@rowCountUpdate > 0)
						BEGIN
							IF (@action = 'UPDATE')
							BEGIN
								UPDATE sysDateEvent SET
									startDate = CASE WHEN (@startDateTime IS NOT NULL AND LEN(@startDateTime) > 0 AND CHARINDEX(@startDateTime, @strBlank) = 0) THEN CONVERT(DATETIME, @startDateTime, 103) ELSE (CASE WHEN (@startDateTime IS NOT NULL AND (LEN(@startDateTime) = 0 OR CHARINDEX(@startDateTime, @strBlank) > 0)) THEN NULL ELSE startDate END) END,
									endDate = CASE WHEN (@endDateTime IS NOT NULL AND LEN(@endDateTime) > 0 AND CHARINDEX(@endDateTime, @strBlank) = 0) THEN CONVERT(DATETIME, @endDateTime, 103) ELSE (CASE WHEN (@endDateTime IS NOT NULL AND (LEN(@endDateTime) = 0 OR CHARINDEX(@endDateTime, @strBlank) > 0)) THEN NULL ELSE endDate END) END,
									yearEntry = CASE WHEN (@yearEntry IS NOT NULL AND LEN(@yearEntry) > 0 AND CHARINDEX(@yearEntry, @strBlank) = 0) THEN @yearEntry ELSE (CASE WHEN (@yearEntry IS NOT NULL AND (LEN(@yearEntry) = 0 OR CHARINDEX(@yearEntry, @strBlank) > 0)) THEN NULL ELSE yearEntry END) END,
									entranceType = CASE WHEN (@entranceType IS NOT NULL AND LEN(@entranceType) > 0 AND CHARINDEX(@entranceType, @strBlank) = 0) THEN @entranceType ELSE (CASE WHEN (@entranceType IS NOT NULL AND (LEN(@entranceType) = 0 OR CHARINDEX(@entranceType, @strBlank) > 0)) THEN NULL ELSE entranceType END) END,
									facultyprogram = CASE WHEN (@facultyprogram IS NOT NULL AND LEN(@facultyprogram) > 0 AND CHARINDEX(@facultyprogram, @strBlank) = 0) THEN @facultyprogram ELSE (CASE WHEN (@facultyprogram IS NOT NULL AND (LEN(@facultyprogram) = 0 OR CHARINDEX(@facultyprogram, @strBlank) > 0)) THEN NULL ELSE facultyprogram END) END,
									cancelStatus = CASE WHEN (@cancel IS NOT NULL AND LEN(@cancel) > 0 AND CHARINDEX(@cancel, @strBlank) = 0) THEN @cancel ELSE (CASE WHEN (@cancel IS NOT NULL AND (LEN(@cancel) = 0 OR CHARINDEX(@cancel, @strBlank) > 0)) THEN NULL ELSE cancelStatus END) END,
									createdBy = CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE (CASE WHEN (@by IS NOT NULL AND (LEN(@by) = 0 OR CHARINDEX(@by, @strBlank) > 0)) THEN NULL ELSE createdBy END) END,
									createdDate = GETDATE()
								WHERE (sysName = @sysName AND sysEvent = @sysEvent)
							END
							
							IF (@action = 'DELETE')								
							BEGIN
								DELETE FROM sysDateEvent WHERE (sysName = @sysName AND sysEvent = @sysEvent)
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
				@ip
			)			
		END CATCH					 
	END
	
	SELECT @rowCount		
END