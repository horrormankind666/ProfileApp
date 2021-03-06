USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetHealthy]    Script Date: 11/16/2015 16:33:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๙/๑๑/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perHealthy ครั้งละ ๑ เรคคอร์ด>
--   1. action					เป็น VARCHAR	รับค่าการกระทำกับฐานข้อมูล
--   2. personId				เป็น VARCHAR	รับค่ารหัสบุคคล
--	 3. bodyMassDetail			เป็น NVARCHAR	รับค่ารายละเอียดของน้ำหนักและส่วนสูง
--   4. intoleranceStatus		เป็น VARCHAR	รับค่ามีประวัติการแพ้ยาหรือไม่
--   5. intoleranceDetail		เป็น NVARCHAR	รับค่ารายละเอียดของการแพ้ยา
--   6. diseasesStatus			เป็น VARCHAR	รับค่ามีโรคประจำตัวหรือไม่
--   7. diseasesDetail			เป็น NVARCHAR	รับค่ารายละเอียดของโรคประจำตัว
--   8. ailHistoryFamilyStatus	เป็น VARCHAR	รับค่ามีประวัติการเจ็บป่วยในครอบครัวหรือไม่
--   9. ailHistoryFamilyDetail	เป็น NVARCHAR	รับค่ารายละเอียดของประวัติการเจ็บป่วยในครอบครัว
--	10. travelAbroadStatus		เป็น VARCHAR	รับค่าเคยเดินทางไปต่างประเทศหรือไม่
--	11. travelAbroadDetail		เป็น NVARCHAR	รับค่ารายละเอียดของประเทศที่เคยเดินทางไป
--	12. impairmentsStatus		เป็น VARCHAR	รับค่ามีความบกพร่องด้านสุขภาพหรือไม่
--	13. impairments				เป็น VARCHAR	รับค่ารหัสความบกพร่องด้านสุขภาพ
--	14.	impairmentsEquipment	เป็น NVARCHAR รับค่ารายละเอียดของอุปกรณ์ที่ใช้สำหรับช่วยเหลือกรณีมีความบกพร่อง
--  15. by						เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
--  16. ip						เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetHealthy]
(
	@action VARCHAR(10) = NULL,
	@personId VARCHAR(10) = NULL,
	@bodyMassDetail NVARCHAR(MAX) = NULL,
	@intoleranceStatus VARCHAR(1) = NULL,
	@intoleranceDetail NVARCHAR(MAX) = NULL,
	@diseasesStatus VARCHAR(1) = NULL,
	@diseasesDetail NVARCHAR(MAX) = NULL,
	@ailHistoryFamilyStatus VARCHAR(1) = NULL,
	@ailHistoryFamilyDetail NVARCHAR(MAX) = NULL,
	@travelAbroadStatus VARCHAR(1) = NULL,
	@travelAbroadDetail NVARCHAR(MAX) = NULL,
	@impairmentsStatus VARCHAR(1) = NULL,
	@impairments VARCHAR(3) = NULL,
	@impairmentsEquipment NVARCHAR(255) = NULL,
	@by NVARCHAR(255) = NULL,
	@ip VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @action = LTRIM(RTRIM(@action))
	SET @personId = LTRIM(RTRIM(@personId))
	SET @bodyMassDetail = LTRIM(RTRIM(@bodyMassDetail))
	SET @intoleranceStatus = LTRIM(RTRIM(@intoleranceStatus))
	SET @intoleranceDetail = LTRIM(RTRIM(@intoleranceDetail))
	SET @diseasesStatus = LTRIM(RTRIM(@diseasesStatus))
	SET @diseasesDetail = LTRIM(RTRIM(@diseasesDetail))
	SET @ailHistoryFamilyStatus = LTRIM(RTRIM(@ailHistoryFamilyStatus))
	SET @ailHistoryFamilyDetail = LTRIM(RTRIM(@ailHistoryFamilyDetail))
	SET @travelAbroadStatus = LTRIM(RTRIM(@travelAbroadStatus)) 
	SET @travelAbroadDetail = LTRIM(RTRIM(@travelAbroadDetail)) 
	SET @impairmentsStatus = LTRIM(RTRIM(@impairmentsStatus)) 
	SET @impairments = LTRIM(RTRIM(@impairments)) 
	SET @impairmentsEquipment = LTRIM(RTRIM(@impairmentsEquipment)) 
	SET @by = LTRIM(RTRIM(@by))
	SET @ip = LTRIM(RTRIM(@ip))
	
	DECLARE @table VARCHAR(50) = 'perHealthy'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	
	SET @action = UPPER(@action)	
	
	IF (@action = 'INSERT' OR @action = 'UPDATE' OR @action = 'DELETE')
	BEGIN
		SET @value = 'perPersonId=' + (CASE WHEN (@personId IS NOT NULL AND LEN(@personId) > 0 AND CHARINDEX(@personId, @strBlank) = 0) THEN ('"' + @personId + '"') ELSE 'NULL' END) + ', ' +
					 'bodyMassDetail=' + (CASE WHEN (@bodyMassDetail IS NOT NULL AND LEN(@bodyMassDetail) > 0 AND CHARINDEX(@bodyMassDetail, @strBlank) = 0) THEN ('"' + @bodyMassDetail + '"') ELSE 'NULL' END) + ', ' +		
					 'intolerance=' + (CASE WHEN (@intoleranceStatus IS NOT NULL AND LEN(@intoleranceStatus) > 0 AND CHARINDEX(@intoleranceStatus, @strBlank) = 0) THEN ('"' + @intoleranceStatus + '"') ELSE 'NULL' END) + ', ' +
					 'intoleranceDetail=' + (CASE WHEN (@intoleranceDetail IS NOT NULL AND LEN(@intoleranceDetail) > 0 AND CHARINDEX(@intoleranceDetail, @strBlank) = 0) THEN ('"' + @intoleranceDetail + '"') ELSE 'NULL' END) + ', ' +
					 'diseases=' + (CASE WHEN (@diseasesStatus IS NOT NULL AND LEN(@diseasesStatus) > 0 AND CHARINDEX(@diseasesStatus, @strBlank) = 0) THEN ('"' + @diseasesStatus + '"') ELSE 'NULL' END) + ', ' +
					 'diseasesDetail=' + (CASE WHEN (@diseasesDetail IS NOT NULL AND LEN(@diseasesDetail) > 0 AND CHARINDEX(@diseasesDetail, @strBlank) = 0) THEN ('"' + @diseasesDetail + '"') ELSE 'NULL' END) + ', ' +
					 'ailHistoryFamily=' + (CASE WHEN (@ailHistoryFamilyStatus IS NOT NULL AND LEN(@ailHistoryFamilyStatus) > 0 AND CHARINDEX(@ailHistoryFamilyStatus, @strBlank) = 0) THEN ('"' + @ailHistoryFamilyStatus + '"') ELSE 'NULL' END) + ', ' +
					 'ailHistoryFamilyDetail=' + (CASE WHEN (@ailHistoryFamilyDetail IS NOT NULL AND LEN(@ailHistoryFamilyDetail) > 0 AND CHARINDEX(@ailHistoryFamilyDetail, @strBlank) = 0) THEN ('"' + @ailHistoryFamilyDetail + '"') ELSE 'NULL' END) + ', ' +
					 'travelAbroad=' + (CASE WHEN (@travelAbroadStatus IS NOT NULL AND LEN(@travelAbroadStatus) > 0 AND CHARINDEX(@travelAbroadStatus, @strBlank) = 0) THEN ('"' + @travelAbroadStatus + '"') ELSE 'NULL' END) + ', ' +
					 'travelAbroadDetail=' + (CASE WHEN (@travelAbroadDetail IS NOT NULL AND LEN(@travelAbroadDetail) > 0 AND CHARINDEX(@travelAbroadDetail, @strBlank) = 0) THEN ('"' + @travelAbroadDetail + '"') ELSE 'NULL' END) + ', ' +					 
					 'impairments=' + (CASE WHEN (@impairmentsStatus IS NOT NULL AND LEN(@impairmentsStatus) > 0 AND CHARINDEX(@impairmentsStatus, @strBlank) = 0) THEN ('"' + @impairmentsStatus + '"') ELSE 'NULL' END) + ', ' +
					 'perImpairmentsId=' + (CASE WHEN (@impairments IS NOT NULL AND LEN(@impairments) > 0 AND CHARINDEX(@impairments, @strBlank) = 0) THEN ('"' + @impairments + '"') ELSE 'NULL' END) + ', ' +
					 'impairmentsEquipment=' + (CASE WHEN (@impairmentsEquipment IS NOT NULL AND LEN(@impairmentsEquipment) > 0 AND CHARINDEX(@impairmentsEquipment, @strBlank) = 0) THEN ('"' + @impairmentsEquipment + '"') ELSE 'NULL' END)
		
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
 					INSERT INTO perHealthy
 					(
						perPersonId,
						bodyMassDetail,
						intolerance,
						intoleranceDetail,
						diseases,
						diseasesDetail,
						ailHistoryFamily,
						ailHistoryFamilyDetail,
						travelAbroad,
						travelAbroadDetail,
						impairments,
						perImpairmentsId,
						impairmentsEquipment,
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
						CASE WHEN (@bodyMassDetail IS NOT NULL AND LEN(@bodyMassDetail) > 0 AND CHARINDEX(@bodyMassDetail, @strBlank) = 0) THEN @bodyMassDetail ELSE NULL END,
						CASE WHEN (@intoleranceStatus IS NOT NULL AND LEN(@intoleranceStatus) > 0 AND CHARINDEX(@intoleranceStatus, @strBlank) = 0) THEN @intoleranceStatus ELSE NULL END,
						CASE WHEN (@intoleranceDetail IS NOT NULL AND LEN(@intoleranceDetail) > 0 AND CHARINDEX(@intoleranceDetail, @strBlank) = 0) THEN @intoleranceDetail ELSE NULL END,
						CASE WHEN (@diseasesStatus IS NOT NULL AND LEN(@diseasesStatus) > 0 AND CHARINDEX(@diseasesStatus, @strBlank) = 0) THEN @diseasesStatus ELSE NULL END,
						CASE WHEN (@diseasesDetail IS NOT NULL AND LEN(@diseasesDetail) > 0 AND CHARINDEX(@diseasesDetail, @strBlank) = 0) THEN @diseasesDetail ELSE NULL END,
						CASE WHEN (@ailHistoryFamilyStatus IS NOT NULL AND LEN(@ailHistoryFamilyStatus) > 0 AND CHARINDEX(@ailHistoryFamilyStatus, @strBlank) = 0) THEN @ailHistoryFamilyStatus ELSE NULL END,
						CASE WHEN (@ailHistoryFamilyDetail IS NOT NULL AND LEN(@ailHistoryFamilyDetail) > 0 AND CHARINDEX(@ailHistoryFamilyDetail, @strBlank) = 0) THEN @ailHistoryFamilyDetail ELSE NULL END,
						CASE WHEN (@travelAbroadStatus IS NOT NULL AND LEN(@travelAbroadStatus) > 0 AND CHARINDEX(@travelAbroadStatus, @strBlank) = 0) THEN @travelAbroadStatus ELSE NULL END,
						CASE WHEN (@travelAbroadDetail IS NOT NULL AND LEN(@travelAbroadDetail) > 0 AND CHARINDEX(@travelAbroadDetail, @strBlank) = 0) THEN @travelAbroadDetail ELSE NULL END,
						CASE WHEN (@impairmentsStatus IS NOT NULL AND LEN(@impairmentsStatus) > 0 AND CHARINDEX(@impairmentsStatus, @strBlank) = 0) THEN @impairmentsStatus ELSE NULL END,
						CASE WHEN (@impairments IS NOT NULL AND LEN(@impairments) > 0 AND CHARINDEX(@impairments, @strBlank) = 0) THEN @impairments ELSE NULL END,
						CASE WHEN (@impairmentsEquipment IS NOT NULL AND LEN(@impairmentsEquipment) > 0 AND CHARINDEX(@impairmentsEquipment, @strBlank) = 0) THEN @impairmentsEquipment ELSE NULL END,
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
						SET @rowCountUpdate = (SELECT COUNT(perPersonId) FROM perHealthy WHERE perPersonId = @personId)
						
						IF (@rowCountUpdate > 0)
						BEGIN
							IF (@action = 'UPDATE')
							BEGIN
								UPDATE perHealthy SET
									bodyMassDetail			= CASE WHEN (@bodyMassDetail IS NOT NULL AND LEN(@bodyMassDetail) > 0 AND CHARINDEX(@bodyMassDetail, @strBlank) = 0) THEN @bodyMassDetail ELSE (CASE WHEN (@bodyMassDetail IS NOT NULL AND (LEN(@bodyMassDetail) = 0 OR CHARINDEX(@bodyMassDetail, @strBlank) > 0)) THEN NULL ELSE bodyMassDetail END) END,
									intolerance				= CASE WHEN (@intoleranceStatus IS NOT NULL AND LEN(@intoleranceStatus) > 0 AND CHARINDEX(@intoleranceStatus, @strBlank) = 0) THEN @intoleranceStatus ELSE (CASE WHEN (@intoleranceStatus IS NOT NULL AND (LEN(@intoleranceStatus) = 0 OR CHARINDEX(@intoleranceStatus, @strBlank) > 0)) THEN NULL ELSE intolerance END) END,
									intoleranceDetail		= CASE WHEN (@intoleranceDetail IS NOT NULL AND LEN(@intoleranceDetail) > 0 AND CHARINDEX(@intoleranceDetail, @strBlank) = 0) THEN @intoleranceDetail ELSE (CASE WHEN (@intoleranceDetail IS NOT NULL AND (LEN(@intoleranceDetail) = 0 OR CHARINDEX(@intoleranceDetail, @strBlank) > 0)) THEN NULL ELSE intoleranceDetail END) END,
									diseases				= CASE WHEN (@diseasesStatus IS NOT NULL AND LEN(@diseasesStatus) > 0 AND CHARINDEX(@diseasesStatus, @strBlank) = 0) THEN @diseasesStatus ELSE (CASE WHEN (@diseasesStatus IS NOT NULL AND (LEN(@diseasesStatus) = 0 OR CHARINDEX(@diseasesStatus, @strBlank) > 0)) THEN NULL ELSE diseases END) END,
									diseasesDetail			= CASE WHEN (@diseasesDetail IS NOT NULL AND LEN(@diseasesDetail) > 0 AND CHARINDEX(@diseasesDetail, @strBlank) = 0) THEN @diseasesDetail ELSE (CASE WHEN (@diseasesDetail IS NOT NULL AND (LEN(@diseasesDetail) = 0 OR CHARINDEX(@diseasesDetail, @strBlank) > 0)) THEN NULL ELSE diseasesDetail END) END,
									ailHistoryFamily		= CASE WHEN (@ailHistoryFamilyStatus IS NOT NULL AND LEN(@ailHistoryFamilyStatus) > 0 AND CHARINDEX(@ailHistoryFamilyStatus, @strBlank) = 0) THEN @ailHistoryFamilyStatus ELSE (CASE WHEN (@ailHistoryFamilyStatus IS NOT NULL AND (LEN(@ailHistoryFamilyStatus) = 0 OR CHARINDEX(@ailHistoryFamilyStatus, @strBlank) > 0)) THEN NULL ELSE ailHistoryFamily END) END,
									ailHistoryFamilyDetail	= CASE WHEN (@ailHistoryFamilyDetail IS NOT NULL AND LEN(@ailHistoryFamilyDetail) > 0 AND CHARINDEX(@ailHistoryFamilyDetail, @strBlank) = 0) THEN @ailHistoryFamilyDetail ELSE (CASE WHEN (@ailHistoryFamilyDetail IS NOT NULL AND (LEN(@ailHistoryFamilyDetail) = 0 OR CHARINDEX(@ailHistoryFamilyDetail, @strBlank) > 0)) THEN NULL ELSE ailHistoryFamilyDetail END) END,
									travelAbroad			= CASE WHEN (@travelAbroadStatus IS NOT NULL AND LEN(@travelAbroadStatus) > 0 AND CHARINDEX(@travelAbroadStatus, @strBlank) = 0) THEN @travelAbroadStatus ELSE (CASE WHEN (@travelAbroadStatus IS NOT NULL AND (LEN(@travelAbroadStatus) = 0 OR CHARINDEX(@travelAbroadStatus, @strBlank) > 0)) THEN NULL ELSE travelAbroad END) END,
									travelAbroadDetail		= CASE WHEN (@travelAbroadDetail IS NOT NULL AND LEN(@travelAbroadDetail) > 0 AND CHARINDEX(@travelAbroadDetail, @strBlank) = 0) THEN @travelAbroadDetail ELSE (CASE WHEN (@travelAbroadDetail IS NOT NULL AND (LEN(@travelAbroadDetail) = 0 OR CHARINDEX(@travelAbroadDetail, @strBlank) > 0)) THEN NULL ELSE travelAbroadDetail END) END,
									impairments				= CASE WHEN (@impairmentsStatus IS NOT NULL AND LEN(@impairmentsStatus) > 0 AND CHARINDEX(@impairmentsStatus, @strBlank) = 0) THEN @impairmentsStatus ELSE (CASE WHEN (@impairmentsStatus IS NOT NULL AND (LEN(@impairmentsStatus) = 0 OR CHARINDEX(@impairmentsStatus, @strBlank) > 0)) THEN NULL ELSE impairments END) END,
									perImpairmentsId		= CASE WHEN (@impairments IS NOT NULL AND LEN(@impairments) > 0 AND CHARINDEX(@impairments, @strBlank) = 0) THEN @impairments ELSE (CASE WHEN (@impairments IS NOT NULL AND (LEN(@impairments) = 0 OR CHARINDEX(@impairments, @strBlank) > 0)) THEN NULL ELSE perImpairmentsId END) END,
									impairmentsEquipment	= CASE WHEN (@impairmentsEquipment IS NOT NULL AND LEN(@impairmentsEquipment) > 0 AND CHARINDEX(@impairmentsEquipment, @strBlank) = 0) THEN @impairmentsEquipment ELSE (CASE WHEN (@impairmentsEquipment IS NOT NULL AND (LEN(@impairmentsEquipment) = 0 OR CHARINDEX(@impairmentsEquipment, @strBlank) > 0)) THEN NULL ELSE impairmentsEquipment END) END,
									modifyDate				= GETDATE(),
									modifyBy				= CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE (CASE WHEN (@by IS NOT NULL AND (LEN(@by) = 0 OR CHARINDEX(@by, @strBlank) > 0)) THEN NULL ELSE modifyBy END) END,
									modifyIp				= CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE (CASE WHEN (@ip IS NOT NULL AND (LEN(@ip) = 0 OR CHARINDEX(@ip, @strBlank) > 0)) THEN NULL ELSE modifyBy END) END
								WHERE perPersonId = @personId	
							END
							
							IF (@action = 'DELETE')								
							BEGIN
								DELETE FROM perHealthy WHERE perPersonId = @personId
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
