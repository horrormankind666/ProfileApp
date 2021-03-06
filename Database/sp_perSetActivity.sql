USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetActivity]    Script Date: 11/16/2015 16:14:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๗/๑๒/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perActivity ครั้งละ ๑ เรคคอร์ด>
--  1. action						เป็น VARCHAR	รับค่าการกระทำกับฐานข้อมูล
--  2. personId						เป็น VARCHAR	รับค่ารหัสบุคคล
--  3. sportsmanStatus				เป็น VARCHAR	รับค่าเคยเป็นนักกีฬาหรือไม่
--  4. sportsmanDetail				เป็น NVARCHAR	รับค่ารายละเอียดของการเคยเป็นนักกีฬา
--  5. specialistStatus				เป็น VARCHAR	รับค่ามีความสามารถพิเศษหรือไม่
--  6. specialistSportStatus		เป็น VARCHAR	รับค่ามีความสามารถพิเศษด้านกีฬาหรือไม่
--  7. specialistSportDetail		เป็น NVARCHAR	รับค่ารายละเอียดของความสามารถพิเศษด้านกีฬา
--  8. specialistArtStatus			เป็น VARCHAR	รับค่ามีความสามารถพิเศษด้านศิลปะหรือไม่
--  9. specialistArtDetail			เป็น NVARCHAR	รับค่ารายละเอียดของความสามารถพิเศษด้านศิลปะ
-- 10. specialistTechnicalStatus	เป็น VARCHAR	รับค่ามีความสามารถพิเศษด้านวิชาการหรือไม่
-- 11. specialistTechnicalDetail	เป็น NVARCHAR	รับค่ารายละเอียดของความสามารถพิเศษด้านวิชาการ
-- 12. specialistOtherStatus		เป็น VARCHAR	รับค่ามีความสามารถพิเศษด้านอื่น ๆ หรือไม่
-- 13. specialistOtherDetail		เป็น NVARCHAR	รับค่ารายละเอียดของความสามารถพิเศษด้านอื่น ๆ
-- 14. activityStatus				เป็น VARCHAR	รับค่าเคยร่วมกิจกรรมของโรงเรียนหรือไม่
-- 15. activityDetail				เป็น NVARCHAR	รับค่ารายละเอียดของกิจกรรมของโรงเรียนที่เคยร่วม
-- 16. rewardStatus					เป็น VARCHAR	รับค่าเคยได้รับทุน / รางวัลหรือไม่
-- 17. rewardDetail					เป็น NVARCHAR	รับค่ารายละเอียดของทุน / รางวัลที่เคยได้รับ
-- 18. by							เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- 19. ip							เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetActivity]
(
	@action VARCHAR(10) = NULL,
	@personId VARCHAR(10) = NULL,
	@sportsmanStatus VARCHAR(1) = NULL,
	@sportsmanDetail NVARCHAR(MAX) = NULL,
	@specialistStatus VARCHAR(1) = NULL,
	@specialistSportStatus VARCHAR(1) = NULL,
	@specialistSportDetail NVARCHAR(MAX) = NULL,
	@specialistArtStatus VARCHAR(1) = NULL,
	@specialistArtDetail NVARCHAR(MAX) = NULL,
	@specialistTechnicalStatus VARCHAR(1) = NULL,
	@specialistTechnicalDetail NVARCHAR(MAX) = NULL,
	@specialistOtherStatus VARCHAR(1) = NULL,
	@specialistOtherDetail NVARCHAR(MAX) = NULL,
	@activityStatus VARCHAR(1) = NULL,
	@activityDetail NVARCHAR(MAX) = NULL,
	@rewardStatus VARCHAR(1) = NULL,
	@rewardDetail NVARCHAR(MAX) = NULL,
	@by NVARCHAR(255) = NULL,
	@ip VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @action = LTRIM(RTRIM(@action))
	SET @personId = LTRIM(RTRIM(@personId))
	SET @sportsmanStatus = LTRIM(RTRIM(@sportsmanStatus))
	SET @sportsmanDetail = LTRIM(RTRIM(@sportsmanDetail))
	SET @specialistStatus = LTRIM(RTRIM(@specialistStatus))
	SET @specialistSportStatus = LTRIM(RTRIM(@specialistSportStatus))
	SET @specialistSportDetail = LTRIM(RTRIM(@specialistSportDetail))
	SET @specialistArtStatus = LTRIM(RTRIM(@specialistArtStatus))
	SET @specialistArtDetail = LTRIM(RTRIM(@specialistArtDetail))
	SET @specialistTechnicalStatus = LTRIM(RTRIM(@specialistTechnicalStatus))
	SET @specialistTechnicalDetail = LTRIM(RTRIM(@specialistTechnicalDetail))
	SET @specialistOtherStatus = LTRIM(RTRIM(@specialistOtherStatus))
	SET @specialistOtherDetail = LTRIM(RTRIM(@specialistOtherDetail))
	SET @activityStatus = LTRIM(RTRIM(@activityStatus))
	SET @activityDetail = LTRIM(RTRIM(@activityDetail))
	SET @rewardStatus = LTRIM(RTRIM(@rewardStatus))
	SET @rewardDetail = LTRIM(RTRIM(@rewardDetail))
	SET @by = LTRIM(RTRIM(@by))
	SET @ip = LTRIM(RTRIM(@ip))
	
	DECLARE @table VARCHAR(50) = 'perActivity'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	
	SET @action = UPPER(@action)	
	
	IF (@action = 'INSERT' OR @action = 'UPDATE' OR @action = 'DELETE')
	BEGIN
		SET @value = 'perPersonId=' + (CASE WHEN (@personId IS NOT NULL AND LEN(@personId) > 0 AND CHARINDEX(@personId, @strBlank) = 0) THEN ('"' + @personId + '"') ELSE 'NULL' END) + ', ' +
					 'sportsman=' + (CASE WHEN (@sportsmanStatus IS NOT NULL AND LEN(@sportsmanStatus) > 0 AND CHARINDEX(@sportsmanStatus, @strBlank) = 0) THEN ('"' + @sportsmanStatus + '"') ELSE 'NULL' END) + ', ' +
					 'sportsmanDetail=' + (CASE WHEN (@sportsmanDetail IS NOT NULL AND LEN(@sportsmanDetail) > 0 AND CHARINDEX(@sportsmanDetail, @strBlank) = 0) THEN ('"' + @sportsmanDetail + '"') ELSE 'NULL' END) + ', ' +
					 'specialist=' + (CASE WHEN (@specialistStatus IS NOT NULL AND LEN(@specialistStatus) > 0 AND CHARINDEX(@specialistStatus, @strBlank) = 0) THEN ('"' + @specialistStatus + '"') ELSE 'NULL' END) + ', ' +
					 'specialistSport=' + (CASE WHEN (@specialistSportStatus IS NOT NULL AND LEN(@specialistSportStatus) > 0 AND CHARINDEX(@specialistSportStatus, @strBlank) = 0) THEN ('"' + @specialistSportStatus + '"') ELSE 'NULL' END) + ', ' +
					 'specialistSportDetail=' + (CASE WHEN (@specialistSportDetail IS NOT NULL AND LEN(@specialistSportDetail) > 0 AND CHARINDEX(@specialistSportDetail, @strBlank) = 0) THEN ('"' + @specialistSportDetail + '"') ELSE 'NULL' END) + ', ' +
					 'specialistArt=' + (CASE WHEN (@specialistArtStatus IS NOT NULL AND LEN(@specialistArtStatus) > 0 AND CHARINDEX(@specialistArtStatus, @strBlank) = 0) THEN ('"' + @specialistArtStatus + '"') ELSE 'NULL' END) + ', ' +
					 'specialistArtDetail=' + (CASE WHEN (@specialistArtDetail IS NOT NULL AND LEN(@specialistArtDetail) > 0 AND CHARINDEX(@specialistArtDetail, @strBlank) = 0) THEN ('"' + @specialistArtDetail + '"') ELSE 'NULL' END) + ', ' +
					 'specialistTechnical=' + (CASE WHEN (@specialistTechnicalStatus IS NOT NULL AND LEN(@specialistTechnicalStatus) > 0 AND CHARINDEX(@specialistTechnicalStatus, @strBlank) = 0) THEN ('"' + @specialistTechnicalStatus + '"') ELSE 'NULL' END) + ', ' +
					 'specialistTechnicalDetail=' + (CASE WHEN (@specialistTechnicalDetail IS NOT NULL AND LEN(@specialistTechnicalDetail) > 0 AND CHARINDEX(@specialistTechnicalDetail, @strBlank) = 0) THEN ('"' + @specialistTechnicalDetail + '"') ELSE 'NULL' END) + ', ' +					 
					 'specialistOther=' + (CASE WHEN (@specialistOtherStatus IS NOT NULL AND LEN(@specialistOtherStatus) > 0 AND CHARINDEX(@specialistOtherStatus, @strBlank) = 0) THEN ('"' + @specialistOtherStatus + '"') ELSE 'NULL' END) + ', ' +
					 'specialistOtherDetail=' + (CASE WHEN (@specialistOtherDetail IS NOT NULL AND LEN(@specialistOtherDetail) > 0 AND CHARINDEX(@specialistOtherDetail, @strBlank) = 0) THEN ('"' + @specialistOtherDetail + '"') ELSE 'NULL' END) + ', ' +
					 'activity=' + (CASE WHEN (@activityStatus IS NOT NULL AND LEN(@activityStatus) > 0 AND CHARINDEX(@activityStatus, @strBlank) = 0) THEN ('"' + @activityStatus + '"') ELSE 'NULL' END) + ', ' +
					 'activityDetail=' + (CASE WHEN (@activityDetail IS NOT NULL AND LEN(@activityDetail) > 0 AND CHARINDEX(@activityDetail, @strBlank) = 0) THEN ('"' + @activityDetail + '"') ELSE 'NULL' END) + ', ' +
					 'reward=' + (CASE WHEN (@rewardStatus IS NOT NULL AND LEN(@rewardStatus) > 0 AND CHARINDEX(@rewardStatus, @strBlank) = 0) THEN ('"' + @rewardStatus + '"') ELSE 'NULL' END) + ', ' +
					 'rewardDetail=' + (CASE WHEN (@rewardDetail IS NOT NULL AND LEN(@rewardDetail) > 0 AND CHARINDEX(@rewardDetail, @strBlank) = 0) THEN ('"' + @rewardDetail + '"') ELSE 'NULL' END)
		
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
 					INSERT INTO perActivity
 					(
						perPersonId,
						sportsman,
						sportsmanDetail,
						specialist,
						specialistSport,
						specialistSportDetail,
						specialistArt,
						specialistArtDetail,
						specialistTechnical,
						specialistTechnicalDetail,
						specialistOther,
						specialistOtherDetail,
						activity,
						activityDetail,
						reward,
						rewardDetail,
						createDate,
						createBy,
						createIp,
						modifyDate,
						modifyBy,
						modifyIp
					)
					VALUES
					(
						CASE WHEN (@personId IS NOT NULL AND LEN(@personId) > 0 AND CHARINDEX(@personId, @strBlank) = 0) THEN @personId ELSE NULL END,
						CASE WHEN (@sportsmanStatus IS NOT NULL AND LEN(@sportsmanStatus) > 0 AND CHARINDEX(@sportsmanStatus, @strBlank) = 0) THEN @sportsmanStatus ELSE NULL END,
						CASE WHEN (@sportsmanDetail IS NOT NULL AND LEN(@sportsmanDetail) > 0 AND CHARINDEX(@sportsmanDetail, @strBlank) = 0) THEN @sportsmanDetail ELSE NULL END,
						CASE WHEN (@specialistStatus IS NOT NULL AND LEN(@specialistStatus) > 0 AND CHARINDEX(@specialistStatus, @strBlank) = 0) THEN @specialistStatus ELSE NULL END,
						CASE WHEN (@specialistSportStatus IS NOT NULL AND LEN(@specialistSportStatus) > 0 AND CHARINDEX(@specialistSportStatus, @strBlank) = 0) THEN @specialistSportStatus ELSE NULL END,
						CASE WHEN (@specialistSportDetail IS NOT NULL AND LEN(@specialistSportDetail) > 0 AND CHARINDEX(@specialistSportDetail, @strBlank) = 0) THEN @specialistSportDetail ELSE NULL END,
						CASE WHEN (@specialistArtStatus IS NOT NULL AND LEN(@specialistArtStatus) > 0 AND CHARINDEX(@specialistArtStatus, @strBlank) = 0) THEN @specialistArtStatus ELSE NULL END,
						CASE WHEN (@specialistArtDetail IS NOT NULL AND LEN(@specialistArtDetail) > 0 AND CHARINDEX(@specialistArtDetail, @strBlank) = 0) THEN @specialistArtDetail ELSE NULL END,
						CASE WHEN (@specialistTechnicalStatus IS NOT NULL AND LEN(@specialistTechnicalStatus) > 0 AND CHARINDEX(@specialistTechnicalStatus, @strBlank) = 0) THEN @specialistTechnicalStatus ELSE NULL END,
						CASE WHEN (@specialistTechnicalDetail IS NOT NULL AND LEN(@specialistTechnicalDetail) > 0 AND CHARINDEX(@specialistTechnicalDetail, @strBlank) = 0) THEN @specialistTechnicalDetail ELSE NULL END,
						CASE WHEN (@specialistOtherStatus IS NOT NULL AND LEN(@specialistOtherStatus) > 0 AND CHARINDEX(@specialistOtherStatus, @strBlank) = 0) THEN @specialistOtherStatus ELSE NULL END,
						CASE WHEN (@specialistOtherDetail IS NOT NULL AND LEN(@specialistOtherDetail) > 0 AND CHARINDEX(@specialistOtherDetail, @strBlank) = 0) THEN @specialistOtherDetail ELSE NULL END,
						CASE WHEN (@activityStatus IS NOT NULL AND LEN(@activityStatus) > 0 AND CHARINDEX(@activityStatus, @strBlank) = 0) THEN @activityStatus ELSE NULL END,
						CASE WHEN (@activityDetail IS NOT NULL AND LEN(@activityDetail) > 0 AND CHARINDEX(@activityDetail, @strBlank) = 0) THEN @activityDetail ELSE NULL END,
						CASE WHEN (@rewardStatus IS NOT NULL AND LEN(@rewardStatus) > 0 AND CHARINDEX(@rewardStatus, @strBlank) = 0) THEN @rewardStatus ELSE NULL END,
						CASE WHEN (@rewardDetail IS NOT NULL AND LEN(@rewardDetail) > 0 AND CHARINDEX(@rewardDetail, @strBlank) = 0) THEN @rewardDetail ELSE NULL END,
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
					IF (@personId IS NOT NULL AND LEN(@personId) > 0 AND CHARINDEX(@personId, @strBlank) = 0)
					BEGIN
						SET @rowCountUpdate = (SELECT COUNT(perPersonId) FROM perActivity WHERE perPersonId = @personId)
						
						IF (@rowCountUpdate > 0)
						BEGIN
							IF (@action = 'UPDATE')
							BEGIN
								UPDATE perActivity SET
									sportsman					= CASE WHEN (@sportsmanStatus IS NOT NULL AND LEN(@sportsmanStatus) > 0 AND CHARINDEX(@sportsmanStatus, @strBlank) = 0) THEN @sportsmanStatus ELSE (CASE WHEN (@sportsmanStatus IS NOT NULL AND (LEN(@sportsmanStatus) = 0 OR CHARINDEX(@sportsmanStatus, @strBlank) > 0)) THEN NULL ELSE sportsman END) END,
									sportsmanDetail				= CASE WHEN (@sportsmanDetail IS NOT NULL AND LEN(@sportsmanDetail) > 0 AND CHARINDEX(@sportsmanDetail, @strBlank) = 0) THEN @sportsmanDetail ELSE (CASE WHEN (@sportsmanDetail IS NOT NULL AND (LEN(@sportsmanDetail) = 0 OR CHARINDEX(@sportsmanDetail, @strBlank) > 0)) THEN NULL ELSE sportsmanDetail END) END,
									specialist					= CASE WHEN (@specialistStatus IS NOT NULL AND LEN(@specialistStatus) > 0 AND CHARINDEX(@specialistStatus, @strBlank) = 0) THEN @specialistStatus ELSE (CASE WHEN (@specialistStatus IS NOT NULL AND (LEN(@specialistStatus) = 0 OR CHARINDEX(@specialistStatus, @strBlank) > 0)) THEN NULL ELSE specialist END) END,
									specialistSport				= CASE WHEN (@specialistSportStatus IS NOT NULL AND LEN(@specialistSportStatus) > 0 AND CHARINDEX(@specialistSportStatus, @strBlank) = 0) THEN @specialistSportStatus ELSE (CASE WHEN (@specialistSportStatus IS NOT NULL AND (LEN(@specialistSportStatus) = 0 OR CHARINDEX(@specialistSportStatus, @strBlank) > 0)) THEN NULL ELSE specialistSport END) END,
									specialistSportDetail		= CASE WHEN (@specialistSportDetail IS NOT NULL AND LEN(@specialistSportDetail) > 0 AND CHARINDEX(@specialistSportDetail, @strBlank) = 0) THEN @specialistSportDetail ELSE (CASE WHEN (@specialistSportDetail IS NOT NULL AND (LEN(@specialistSportDetail) = 0 OR CHARINDEX(@specialistSportDetail, @strBlank) > 0)) THEN NULL ELSE specialistSportDetail END) END,
									specialistArt				= CASE WHEN (@specialistArtStatus IS NOT NULL AND LEN(@specialistArtStatus) > 0 AND CHARINDEX(@specialistArtStatus, @strBlank) = 0) THEN @specialistArtStatus ELSE (CASE WHEN (@specialistArtStatus IS NOT NULL AND (LEN(@specialistArtStatus) = 0 OR CHARINDEX(@specialistArtStatus, @strBlank) > 0)) THEN NULL ELSE specialistArt END) END,
									specialistArtDetail			= CASE WHEN (@specialistArtDetail IS NOT NULL AND LEN(@specialistArtDetail) > 0 AND CHARINDEX(@specialistArtDetail, @strBlank) = 0) THEN @specialistArtDetail ELSE (CASE WHEN (@specialistArtDetail IS NOT NULL AND (LEN(@specialistArtDetail) = 0 OR CHARINDEX(@specialistArtDetail, @strBlank) > 0)) THEN NULL ELSE specialistArtDetail END) END,
									specialistTechnical			= CASE WHEN (@specialistTechnicalStatus IS NOT NULL AND LEN(@specialistTechnicalStatus) > 0 AND CHARINDEX(@specialistTechnicalStatus, @strBlank) = 0) THEN @specialistTechnicalStatus ELSE (CASE WHEN (@specialistTechnicalStatus IS NOT NULL AND (LEN(@specialistTechnicalStatus) = 0 OR CHARINDEX(@specialistTechnicalStatus, @strBlank) > 0)) THEN NULL ELSE specialistTechnical END) END,
									specialistTechnicalDetail	= CASE WHEN (@specialistTechnicalDetail IS NOT NULL AND LEN(@specialistTechnicalDetail) > 0 AND CHARINDEX(@specialistTechnicalDetail, @strBlank) = 0) THEN @specialistTechnicalDetail ELSE (CASE WHEN (@specialistTechnicalDetail IS NOT NULL AND (LEN(@specialistTechnicalDetail) = 0 OR CHARINDEX(@specialistTechnicalDetail, @strBlank) > 0)) THEN NULL ELSE specialistTechnicalDetail END) END,
									specialistOther				= CASE WHEN (@specialistOtherStatus IS NOT NULL AND LEN(@specialistOtherStatus) > 0 AND CHARINDEX(@specialistOtherStatus, @strBlank) = 0) THEN @specialistOtherStatus ELSE (CASE WHEN (@specialistOtherStatus IS NOT NULL AND (LEN(@specialistOtherStatus) = 0 OR CHARINDEX(@specialistOtherStatus, @strBlank) > 0)) THEN NULL ELSE specialistOther END) END,
									specialistOtherDetail		= CASE WHEN (@specialistOtherDetail IS NOT NULL AND LEN(@specialistOtherDetail) > 0 AND CHARINDEX(@specialistOtherDetail, @strBlank) = 0) THEN @specialistOtherDetail ELSE (CASE WHEN (@specialistOtherDetail IS NOT NULL AND (LEN(@specialistOtherDetail) = 0 OR CHARINDEX(@specialistOtherDetail, @strBlank) > 0)) THEN NULL ELSE specialistOtherDetail END) END,
									activity					= CASE WHEN (@activityStatus IS NOT NULL AND LEN(@activityStatus) > 0 AND CHARINDEX(@activityStatus, @strBlank) = 0) THEN @activityStatus ELSE (CASE WHEN (@activityStatus IS NOT NULL AND (LEN(@activityStatus) = 0 OR CHARINDEX(@activityStatus, @strBlank) > 0)) THEN NULL ELSE activity END) END,
									activityDetail				= CASE WHEN (@activityDetail IS NOT NULL AND LEN(@activityDetail) > 0 AND CHARINDEX(@activityDetail, @strBlank) = 0) THEN @activityDetail ELSE (CASE WHEN (@activityDetail IS NOT NULL AND (LEN(@activityDetail) = 0 OR CHARINDEX(@activityDetail, @strBlank) > 0)) THEN NULL ELSE activityDetail END) END,
									reward						= CASE WHEN (@rewardStatus IS NOT NULL AND LEN(@rewardStatus) > 0 AND CHARINDEX(@rewardStatus, @strBlank) = 0) THEN @rewardStatus ELSE (CASE WHEN (@rewardStatus IS NOT NULL AND (LEN(@rewardStatus) = 0 OR CHARINDEX(@rewardStatus, @strBlank) > 0)) THEN NULL ELSE reward END) END,
									rewardDetail				= CASE WHEN (@rewardDetail IS NOT NULL AND LEN(@rewardDetail) > 0 AND CHARINDEX(@rewardDetail, @strBlank) = 0) THEN @rewardDetail ELSE (CASE WHEN (@rewardDetail IS NOT NULL AND (LEN(@rewardDetail) = 0 OR CHARINDEX(@rewardDetail, @strBlank) > 0)) THEN NULL ELSE rewardDetail END) END,								
									modifyDate					= GETDATE(),
									modifyBy					= CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE (CASE WHEN (@by IS NOT NULL AND (LEN(@by) = 0 OR CHARINDEX(@by, @strBlank) > 0)) THEN NULL ELSE modifyBy END) END,
									modifyIp					= CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE (CASE WHEN (@ip IS NOT NULL AND (LEN(@ip) = 0 OR CHARINDEX(@ip, @strBlank) > 0)) THEN NULL ELSE modifyIp END) END
								WHERE perPersonId = @personId	
							END
							
							IF (@action = 'DELETE')								
							BEGIN
								DELETE FROM perActivity WHERE perPersonId = @personId
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
	
	EXEC sp_stdTransferStudentRecordsToMUStudent
		@personId = @personId	
END