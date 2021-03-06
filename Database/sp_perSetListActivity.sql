USE [MUStudent]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetListActivity]    Script Date: 03/27/2014 11:46:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<ยุทธภูมิ ตวันนา>
-- Create date: <๑๗/๑๒/๒๕๕๖>
-- Description:	<สำหรับบันทึกข้อมูลตาราง perActivity ครั้งละหลายเรคคอร์ด>
--  1. order						เป็น VARCHAR	รับค่าลำดับของเรคคอร์ด
--  2. perPersonId					เป็น VARCHAR	รับค่ารหัสบุคคล
--  3. sportsman					เป็น VARCHAR	รับค่าเคยเป็นนักกีฬาหรือไม่
--  4. sportsmanDetail				เป็น NVARCHAR	รับค่ารายละเอียดของการเคยเป็นนักกีฬา
--  5. specialist					เป็น VARCHAR	รับค่ามีความสามารถพิเศษหรือไม่
--  6. specialistSport				เป็น VARCHAR	รับค่ามีความสามารถพิเศษด้านกีฬาหรือไม่
--  7. specialistSportDetail		เป็น NVARCHAR	รับค่ารายละเอียดของความสามารถพิเศษด้านกีฬา
--  8. specialistArt				เป็น VARCHAR	รับค่ามีความสามารถพิเศษด้านศิลปะหรือไม่
--  9. specialistArtDetail			เป็น NVARCHAR	รับค่ารายละเอียดของความสามารถพิเศษด้านศิลปะ
-- 10. specialistTechnical			เป็น VARCHAR	รับค่ามีความสามารถพิเศษด้านวิชาการหรือไม่
-- 11. specialistTechnicalDetail	เป็น NVARCHAR	รับค่ารายละเอียดของความสามารถพิเศษด้านวิชาการ
-- 12. specialistOther				เป็น VARCHAR	รับค่ามีความสามารถพิเศษด้านอื่น ๆ หรือไม่
-- 13. specialistOtherDetail		เป็น NVARCHAR	รับค่ารายละเอียดของความสามารถพิเศษด้านอื่น ๆ
-- 14. activity						เป็น VARCHAR	รับค่าเคยร่วมกิจกรรมของโรงเรียนหรือไม่
-- 15. activityDetail				เป็น NVARCHAR	รับค่ารายละเอียดของกิจกรรมของโรงเรียนที่เคยร่วม
-- 16. reward						เป็น VARCHAR	รับค่าเคยได้รับทุน / รางวัลหรือไม่
-- 17. rewardDetail					เป็น NVARCHAR	รับค่ารายละเอียดของทุน / รางวัลที่เคยได้รับ
-- 18. by							เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetListActivity] 
(
	@order VARCHAR(MAX) = NULL,
	@perPersonId VARCHAR(MAX) = NULL,
	@sportsman VARCHAR(MAX) = NULL,
	@sportsmanDetail NVARCHAR(MAX) = NULL,
	@specialist VARCHAR(MAX) = NULL,
	@specialistSport VARCHAR(MAX) = NULL,
	@specialistSportDetail NVARCHAR(MAX) = NULL,
	@specialistArt VARCHAR(MAX) = NULL,
	@specialistArtDetail NVARCHAR(MAX) = NULL,
	@specialistTechnical VARCHAR(MAX) = NULL,
	@specialistTechnicalDetail NVARCHAR(MAX) = NULL,
	@specialistOther VARCHAR(MAX) = NULL,
	@specialistOtherDetail NVARCHAR(MAX) = NULL,
	@activity VARCHAR(MAX) = NULL,
	@activityDetail NVARCHAR(MAX) = NULL,
	@reward VARCHAR(MAX) = NULL,
	@rewardDetail NVARCHAR(MAX) = NULL,
	@by NVARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @order = LTRIM(RTRIM(@order))
	SET @perPersonId = LTRIM(RTRIM(@perPersonId))
	SET @sportsman = LTRIM(RTRIM(@sportsman))
	SET @sportsmanDetail = LTRIM(RTRIM(@sportsmanDetail))
	SET @specialist = LTRIM(RTRIM(@specialist))
	SET @specialistSport = LTRIM(RTRIM(@specialistSport))
	SET @specialistSportDetail = LTRIM(RTRIM(@specialistSportDetail))
	SET @specialistArt = LTRIM(RTRIM(@specialistArt))
	SET @specialistArtDetail = LTRIM(RTRIM(@specialistArtDetail))
	SET @specialistTechnical = LTRIM(RTRIM(@specialistTechnical))
	SET @specialistTechnicalDetail = LTRIM(RTRIM(@specialistTechnicalDetail))
	SET @specialistOther = LTRIM(RTRIM(@specialistOther))
	SET @specialistOtherDetail = LTRIM(RTRIM(@specialistOtherDetail))
	SET @activity = LTRIM(RTRIM(@activity))
	SET @activityDetail = LTRIM(RTRIM(@activityDetail))
	SET @reward = LTRIM(RTRIM(@reward))
	SET @rewardDetail = LTRIM(RTRIM(@rewardDetail))
	SET @by = LTRIM(RTRIM(@by))
	
	DECLARE @action VARCHAR(10) = 'INSERT'
	DECLARE @table VARCHAR(50) = 'perActivity'
	DECLARE @i INT = 1
	DECLARE @delimiter CHAR(1) = ';'
	DECLARE @orderSlice VARCHAR(MAX) = NULL
	DECLARE @perPersonIdSlice VARCHAR(MAX) = NULL
	DECLARE @sportsmanSlice VARCHAR(MAX) = NULL
	DECLARE @sportsmanDetailSlice NVARCHAR(MAX) = NULL
	DECLARE @specialistSlice VARCHAR(MAX) = NULL
	DECLARE @specialistSportSlice VARCHAR(MAX) = NULL
	DECLARE @specialistSportDetailSlice NVARCHAR(MAX) = NULL
	DECLARE @specialistArtSlice VARCHAR(MAX) = NULL
	DECLARE	@specialistArtDetailSlice NVARCHAR(MAX) = NULL
	DECLARE @specialistTechnicalSlice VARCHAR(MAX) = NULL
	DECLARE @specialistTechnicalDetailSlice NVARCHAR(MAX) = NULL
	DECLARE @specialistOtherSlice VARCHAR(MAX) = NULL
	DECLARE @specialistOtherDetailSlice NVARCHAR(MAX) = NULL
	DECLARE @activitySlice VARCHAR(MAX) = NULL
	DECLARE @activityDetailSlice NVARCHAR(MAX) = NULL
	DECLARE @rewardSlice VARCHAR(MAX) = NULL
	DECLARE @rewardDetailSlice NVARCHAR(MAX) = NULL
	DECLARE @rowCount INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	DECLARE @ip VARCHAR(255) = dbo.fnc_perGetIP()
	
	WHILE (LEN(@order) > 0)
	BEGIN
		SET @orderSlice = (SELECT stringSlice FROM fnc_perParseString(@order, @delimiter))
		SET @order = (SELECT string FROM fnc_perParseString(@order, @delimiter))
		
		SET @perPersonIdSlice = (SELECT stringSlice FROM fnc_perParseString(@perPersonId, @delimiter))
		SET @perPersonId = (SELECT string FROM fnc_perParseString(@perPersonId, @delimiter))
		
		SET @sportsmanSlice = (SELECT stringSlice FROM fnc_perParseString(@sportsman, @delimiter))
		SET @sportsman = (SELECT string FROM fnc_perParseString(@sportsman, @delimiter))
		
		SET @sportsmanDetailSlice = (SELECT stringSlice FROM fnc_perParseString(@sportsmanDetail, @delimiter))
		SET @sportsmanDetail = (SELECT string FROM fnc_perParseString(@sportsmanDetail, @delimiter))

		SET @specialistSlice = (SELECT stringSlice FROM fnc_perParseString(@specialist, @delimiter))
		SET @specialist = (SELECT string FROM fnc_perParseString(@specialist, @delimiter))

		SET @specialistSportSlice = (SELECT stringSlice FROM fnc_perParseString(@specialistSport, @delimiter))
		SET @specialistSport = (SELECT string FROM fnc_perParseString(@specialistSport, @delimiter))

		SET @specialistSportDetailSlice = (SELECT stringSlice FROM fnc_perParseString(@specialistSportDetail, @delimiter))
		SET @specialistSportDetail = (SELECT string FROM fnc_perParseString(@specialistSportDetail, @delimiter))

		SET @specialistArtSlice = (SELECT stringSlice FROM fnc_perParseString(@specialistArt, @delimiter))
		SET @specialistArt = (SELECT string FROM fnc_perParseString(@specialistArt, @delimiter))

		SET @specialistArtDetailSlice = (SELECT stringSlice FROM fnc_perParseString(@specialistArtDetail, @delimiter))
		SET @specialistArtDetail = (SELECT string FROM fnc_perParseString(@specialistArtDetail, @delimiter))

		SET @specialistTechnicalSlice = (SELECT stringSlice FROM fnc_perParseString(@specialistTechnical, @delimiter))
		SET @specialistTechnical = (SELECT string FROM fnc_perParseString(@specialistTechnical, @delimiter))

		SET @specialistTechnicalDetailSlice = (SELECT stringSlice FROM fnc_perParseString(@specialistTechnicalDetail, @delimiter))
		SET @specialistTechnicalDetail = (SELECT string FROM fnc_perParseString(@specialistTechnicalDetail, @delimiter))

		SET @specialistOtherSlice = (SELECT stringSlice FROM fnc_perParseString(@specialistOther, @delimiter))
		SET @specialistOther = (SELECT string FROM fnc_perParseString(@specialistOther, @delimiter))

		SET @specialistOtherDetailSlice = (SELECT stringSlice FROM fnc_perParseString(@specialistOtherDetail, @delimiter))
		SET @specialistOtherDetail = (SELECT string FROM fnc_perParseString(@specialistOtherDetail, @delimiter))

		SET @activitySlice = (SELECT stringSlice FROM fnc_perParseString(@activity, @delimiter))
		SET @activity = (SELECT string FROM fnc_perParseString(@activity, @delimiter))

		SET @activityDetailSlice = (SELECT stringSlice FROM fnc_perParseString(@activityDetail, @delimiter))
		SET @activityDetail = (SELECT string FROM fnc_perParseString(@activityDetail, @delimiter))

		SET @rewardSlice = (SELECT stringSlice FROM fnc_perParseString(@reward, @delimiter))
		SET @reward = (SELECT string FROM fnc_perParseString(@reward, @delimiter))

		SET @rewardDetailSlice = (SELECT stringSlice FROM fnc_perParseString(@rewardDetail, @delimiter))
		SET @rewardDetail = (SELECT string FROM fnc_perParseString(@rewardDetail, @delimiter))

		IF (LEN(@orderSlice) > 0)
		BEGIN			
			SET @value = 'perPersonId=' + (CASE WHEN (@perPersonIdSlice IS NOT NULL AND LEN(@perPersonIdSlice) > 0 AND CHARINDEX(@perPersonIdSlice, @strBlank) = 0) THEN ('"' + @perPersonIdSlice + '"') ELSE 'NULL' END) + ', ' +
						 'sportsman=' + (CASE WHEN (@sportsmanSlice IS NOT NULL AND LEN(@sportsmanSlice) > 0 AND CHARINDEX(@sportsmanSlice, @strBlank) = 0) THEN ('"' + @sportsmanSlice + '"') ELSE 'NULL' END) + ', ' +
						 'sportsmanDetail=' + (CASE WHEN (@sportsmanDetailSlice IS NOT NULL AND LEN(@sportsmanDetailSlice) > 0 AND CHARINDEX(@sportsmanDetailSlice, @strBlank) = 0) THEN ('"' + @sportsmanDetailSlice + '"') ELSE 'NULL' END) + ', ' +
						 'specialist=' + (CASE WHEN (@specialistSlice IS NOT NULL AND LEN(@specialistSlice) > 0 AND CHARINDEX(@specialistSlice, @strBlank) = 0) THEN ('"' + @specialistSlice + '"') ELSE 'NULL' END) + ', ' +
						 'specialistSport=' + (CASE WHEN (@specialistSportSlice IS NOT NULL AND LEN(@specialistSportSlice) > 0 AND CHARINDEX(@specialistSportSlice, @strBlank) = 0) THEN ('"' + @specialistSportSlice + '"') ELSE 'NULL' END) + ', ' +
						 'specialistSportDetail=' + (CASE WHEN (@specialistSportDetailSlice IS NOT NULL AND LEN(@specialistSportDetailSlice) > 0 AND CHARINDEX(@specialistSportDetailSlice, @strBlank) = 0) THEN ('"' + @specialistSportDetailSlice + '"') ELSE 'NULL' END) + ', ' +
						 'specialistArt=' + (CASE WHEN (@specialistArtSlice IS NOT NULL AND LEN(@specialistArtSlice) > 0 AND CHARINDEX(@specialistArtSlice, @strBlank) = 0) THEN ('"' + @specialistArtSlice + '"') ELSE 'NULL' END) + ', ' +
						 'specialistArtDetail=' + (CASE WHEN (@specialistArtDetailSlice IS NOT NULL AND LEN(@specialistArtDetailSlice) > 0 AND CHARINDEX(@specialistArtDetailSlice, @strBlank) = 0) THEN ('"' + @specialistArtDetailSlice + '"') ELSE 'NULL' END) + ', ' +
						 'specialistTechnical=' + (CASE WHEN (@specialistTechnicalSlice IS NOT NULL AND LEN(@specialistTechnicalSlice) > 0 AND CHARINDEX(@specialistTechnicalSlice, @strBlank) = 0) THEN ('"' + @specialistTechnicalSlice + '"') ELSE 'NULL' END) + ', ' +
						 'specialistTechnicalDetail=' + (CASE WHEN (@specialistTechnicalDetailSlice IS NOT NULL AND LEN(@specialistTechnicalDetailSlice) > 0 AND CHARINDEX(@specialistTechnicalDetailSlice, @strBlank) = 0) THEN ('"' + @specialistTechnicalDetailSlice + '"') ELSE 'NULL' END) + ', ' +					 
						 'specialistOther=' + (CASE WHEN (@specialistOtherSlice IS NOT NULL AND LEN(@specialistOtherSlice) > 0 AND CHARINDEX(@specialistOtherSlice, @strBlank) = 0) THEN ('"' + @specialistOtherSlice + '"') ELSE 'NULL' END) + ', ' +
						 'specialistOtherDetail=' + (CASE WHEN (@specialistOtherDetailSlice IS NOT NULL AND LEN(@specialistOtherDetailSlice) > 0 AND CHARINDEX(@specialistOtherDetailSlice, @strBlank) = 0) THEN ('"' + @specialistOtherDetailSlice + '"') ELSE 'NULL' END) + ', ' +
						 'activity=' + (CASE WHEN (@activitySlice IS NOT NULL AND LEN(@activitySlice) > 0 AND CHARINDEX(@activitySlice, @strBlank) = 0) THEN ('"' + @activitySlice + '"') ELSE 'NULL' END) + ', ' +
						 'activityDetail=' + (CASE WHEN (@activityDetailSlice IS NOT NULL AND LEN(@activityDetailSlice) > 0 AND CHARINDEX(@activityDetailSlice, @strBlank) = 0) THEN ('"' + @activityDetailSlice + '"') ELSE 'NULL' END) + ', ' +
						 'reward=' + (CASE WHEN (@rewardSlice IS NOT NULL AND LEN(@rewardSlice) > 0 AND CHARINDEX(@rewardSlice, @strBlank) = 0) THEN ('"' + @rewardSlice + '"') ELSE 'NULL' END) + ', ' +
						 'rewardDetail=' + (CASE WHEN (@rewardDetailSlice IS NOT NULL AND LEN(@rewardDetailSlice) > 0 AND CHARINDEX(@rewardDetailSlice, @strBlank) = 0) THEN ('"' + @rewardDetailSlice + '"') ELSE 'NULL' END)

			BEGIN TRY
				BEGIN TRAN	
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
						CASE WHEN (@perPersonIdSlice IS NOT NULL AND LEN(@perPersonIdSlice) > 0 AND CHARINDEX(@perPersonIdSlice, @strBlank) = 0) THEN @perPersonIdSlice ELSE NULL END,
						CASE WHEN (@sportsmanSlice IS NOT NULL AND LEN(@sportsmanSlice) > 0 AND CHARINDEX(@sportsmanSlice, @strBlank) = 0) THEN @sportsmanSlice ELSE NULL END,
						CASE WHEN (@sportsmanDetailSlice IS NOT NULL AND LEN(@sportsmanDetailSlice) > 0 AND CHARINDEX(@sportsmanDetailSlice, @strBlank) = 0) THEN @sportsmanDetailSlice ELSE NULL END,
						CASE WHEN (@specialistSlice IS NOT NULL AND LEN(@specialistSlice) > 0 AND CHARINDEX(@specialistSlice, @strBlank) = 0) THEN @specialistSlice ELSE NULL END,
						CASE WHEN (@specialistSportSlice IS NOT NULL AND LEN(@specialistSportSlice) > 0 AND CHARINDEX(@specialistSportSlice, @strBlank) = 0) THEN @specialistSportSlice ELSE NULL END,
						CASE WHEN (@specialistSportDetailSlice IS NOT NULL AND LEN(@specialistSportDetailSlice) > 0 AND CHARINDEX(@specialistSportDetailSlice, @strBlank) = 0) THEN @specialistSportDetailSlice ELSE NULL END,
						CASE WHEN (@specialistArtSlice IS NOT NULL AND LEN(@specialistArtSlice) > 0 AND CHARINDEX(@specialistArtSlice, @strBlank) = 0) THEN @specialistArtSlice ELSE NULL END,
						CASE WHEN (@specialistArtDetailSlice IS NOT NULL AND LEN(@specialistArtDetailSlice) > 0 AND CHARINDEX(@specialistArtDetailSlice, @strBlank) = 0) THEN @specialistArtDetailSlice ELSE NULL END,
						CASE WHEN (@specialistTechnicalSlice IS NOT NULL AND LEN(@specialistTechnicalSlice) > 0 AND CHARINDEX(@specialistTechnicalSlice, @strBlank) = 0) THEN @specialistTechnicalSlice ELSE NULL END,
						CASE WHEN (@specialistTechnicalDetailSlice IS NOT NULL AND LEN(@specialistTechnicalDetailSlice) > 0 AND CHARINDEX(@specialistTechnicalDetailSlice, @strBlank) = 0) THEN @specialistTechnicalDetailSlice ELSE NULL END,
						CASE WHEN (@specialistOtherSlice IS NOT NULL AND LEN(@specialistOtherSlice) > 0 AND CHARINDEX(@specialistOtherSlice, @strBlank) = 0) THEN @specialistOtherSlice ELSE NULL END,
						CASE WHEN (@specialistOtherDetailSlice IS NOT NULL AND LEN(@specialistOtherDetailSlice) > 0 AND CHARINDEX(@specialistOtherDetailSlice, @strBlank) = 0) THEN @specialistOtherDetailSlice ELSE NULL END,
						CASE WHEN (@activitySlice IS NOT NULL AND LEN(@activitySlice) > 0 AND CHARINDEX(@activitySlice, @strBlank) = 0) THEN @activitySlice ELSE NULL END,
						CASE WHEN (@activityDetailSlice IS NOT NULL AND LEN(@activityDetailSlice) > 0 AND CHARINDEX(@activityDetailSlice, @strBlank) = 0) THEN @activityDetailSlice ELSE NULL END,
						CASE WHEN (@rewardSlice IS NOT NULL AND LEN(@rewardSlice) > 0 AND CHARINDEX(@rewardSlice, @strBlank) = 0) THEN @rewardSlice ELSE NULL END,
						CASE WHEN (@rewardDetailSlice IS NOT NULL AND LEN(@rewardDetailSlice) > 0 AND CHARINDEX(@rewardDetailSlice, @strBlank) = 0) THEN @rewardDetailSlice ELSE NULL END,
						GETDATE(),
						CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE NULL END,
						@ip,
						NULL,
						NULL,
						NULL
					)
				COMMIT TRAN
				SET @rowCount = @rowCount + 1
			END TRY
			BEGIN CATCH
				ROLLBACK TRAN
				INSERT INTO perErrorLog
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
	END
	
	SELECT @rowCount	
END
