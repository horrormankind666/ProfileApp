USE [MUStudent]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetListHealthy]    Script Date: 03/27/2014 11:49:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๙/๑๑/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perHealthy ครั้งละหลายเรคคอร์ด>
--  1. order					เป็น VARCHAR	รับค่าลำดับของเรคคอร์ด
--  2. perPersonId				เป็น VARCHAR	รับค่ารหัสบุคคล
--  3. intolerance				เป็น VARCHAR	รับค่ามีประวัติการแพ้ยาหรือไม่
--  4. intoleranceDetail		เป็น NVARCHAR	รับค่ารายละเอียดของการแพ้ยา
--  5. diseases					เป็น VARCHAR	รับค่ามีโรคประจำตัวหรือไม่
--  6. diseasesDetail			เป็น NVARCHAR	รับค่ารายละเอียดของโรคประจำตัว
--  7. ailHistoryFamily			เป็น VARCHAR	รับค่ามีประวัติการเจ็บป่วยในครอบครัวหรือไม่
--  8. ailHistoryFamilyDetail	เป็น NVARCHAR	รับค่ารายละเอียดของประวัติการเจ็บป่วยในครอบครัว
--  9. by						เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetListHealthy] 
(
	@order VARCHAR(MAX) = NULL,
	@perPersonId VARCHAR(MAX) = NULL,
	@intolerance VARCHAR(MAX) = NULL,
	@intoleranceDetail NVARCHAR(MAX) = NULL,
	@diseases VARCHAR(MAX) = NULL,
	@diseasesDetail NVARCHAR(MAX) = NULL,
	@ailHistoryFamily VARCHAR(MAX) = NULL,
	@ailHistoryFamilyDetail NVARCHAR(MAX) = NULL,
	@by NVARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @order = LTRIM(RTRIM(@order))
	SET @perPersonId = LTRIM(RTRIM(@perPersonId))
	SET @intolerance = LTRIM(RTRIM(@intolerance))
	SET @intoleranceDetail = LTRIM(RTRIM(@intoleranceDetail))
	SET @diseases = LTRIM(RTRIM(@diseases))
	SET @diseasesDetail = LTRIM(RTRIM(@diseasesDetail))
	SET @ailHistoryFamily = LTRIM(RTRIM(@ailHistoryFamily))
	SET @ailHistoryFamilyDetail = LTRIM(RTRIM(@ailHistoryFamilyDetail))
	SET @by = LTRIM(RTRIM(@by))
	
	DECLARE @action VARCHAR(10) = 'INSERT'
	DECLARE @table VARCHAR(50) = 'perHealthy'
	DECLARE @i INT = 1
	DECLARE @delimiter CHAR(1) = ';'
	DECLARE @orderSlice VARCHAR(MAX) = NULL
	DECLARE @perPersonIdSlice VARCHAR(MAX) = NULL
	DECLARE @intoleranceSlice VARCHAR(MAX) = NULL
	DECLARE @intoleranceDetailSlice NVARCHAR(MAX) = NULL	
	DECLARE @diseasesSlice VARCHAR(MAX) = NULL	
	DECLARE @diseasesDetailSlice NVARCHAR(MAX) = NULL	
	DECLARE @ailHistoryFamilySlice VARCHAR(MAX) = NULL	
	DECLARE @ailHistoryFamilyDetailSlice NVARCHAR(MAX) = NULL	
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
		
		SET @intoleranceSlice = (SELECT stringSlice FROM fnc_perParseString(@intolerance, @delimiter))
		SET @intolerance = (SELECT string FROM fnc_perParseString(@intolerance, @delimiter))
						
		SET @intoleranceDetailSlice = (SELECT stringSlice FROM fnc_perParseString(@intoleranceDetail, @delimiter))
		SET @intoleranceDetail = (SELECT string FROM fnc_perParseString(@intoleranceDetail, @delimiter))

		SET @diseasesSlice = (SELECT stringSlice FROM fnc_perParseString(@diseases, @delimiter))
		SET @diseases = (SELECT string FROM fnc_perParseString(@diseases, @delimiter))

		SET @diseasesDetailSlice = (SELECT stringSlice FROM fnc_perParseString(@diseasesDetail, @delimiter))
		SET @diseasesDetail = (SELECT string FROM fnc_perParseString(@diseasesDetail, @delimiter))

		SET @ailHistoryFamilySlice = (SELECT stringSlice FROM fnc_perParseString(@ailHistoryFamily, @delimiter))
		SET @ailHistoryFamily = (SELECT string FROM fnc_perParseString(@ailHistoryFamily, @delimiter))

		SET @ailHistoryFamilyDetailSlice = (SELECT stringSlice FROM fnc_perParseString(@ailHistoryFamilyDetail, @delimiter))
		SET @ailHistoryFamilyDetail = (SELECT string FROM fnc_perParseString(@ailHistoryFamilyDetail, @delimiter))

		IF (LEN(@orderSlice) > 0)
		BEGIN			
			SET @value = 'perPersonId=' + (CASE WHEN (@perPersonIdSlice IS NOT NULL AND LEN(@perPersonIdSlice) > 0 AND CHARINDEX(@perPersonIdSlice, @strBlank) = 0) THEN ('"' + @perPersonIdSlice + '"') ELSE 'NULL' END) + ', ' +
						 'intolerance=' + (CASE WHEN (@intoleranceSlice IS NOT NULL AND LEN(@intoleranceSlice) > 0 AND CHARINDEX(@intoleranceSlice, @strBlank) = 0) THEN ('"' + @intoleranceSlice + '"') ELSE 'NULL' END) + ', ' +
						 'intoleranceDetail=' + (CASE WHEN (@intoleranceDetailSlice IS NOT NULL AND LEN(@intoleranceDetailSlice) > 0 AND CHARINDEX(@intoleranceDetailSlice, @strBlank) = 0) THEN ('"' + @intoleranceDetailSlice + '"') ELSE 'NULL' END) + ', ' +
						 'diseases=' + (CASE WHEN (@diseasesSlice IS NOT NULL AND LEN(@diseasesSlice) > 0 AND CHARINDEX(@diseasesSlice, @strBlank) = 0) THEN ('"' + @diseasesSlice + '"') ELSE 'NULL' END) + ', ' +
						 'diseasesDetail=' + (CASE WHEN (@diseasesDetailSlice IS NOT NULL AND LEN(@diseasesDetailSlice) > 0 AND CHARINDEX(@diseasesDetailSlice, @strBlank) = 0) THEN ('"' + @diseasesDetailSlice + '"') ELSE 'NULL' END) + ', ' +
						 'ailHistoryFamily=' + (CASE WHEN (@ailHistoryFamilySlice IS NOT NULL AND LEN(@ailHistoryFamilySlice) > 0 AND CHARINDEX(@ailHistoryFamilySlice, @strBlank) = 0) THEN ('"' + @ailHistoryFamilySlice + '"') ELSE 'NULL' END) + ', ' +
						 'ailHistoryFamilyDetail=' + (CASE WHEN (@ailHistoryFamilyDetailSlice IS NOT NULL AND LEN(@ailHistoryFamilyDetailSlice) > 0 AND CHARINDEX(@ailHistoryFamilyDetailSlice, @strBlank) = 0) THEN ('"' + @ailHistoryFamilyDetailSlice + '"') ELSE 'NULL' END)

			BEGIN TRY
				BEGIN TRAN	
					INSERT INTO perHealthy
					(
						perPersonId,
						intolerance,
						intoleranceDetail,
						diseases,
						diseasesDetail,
						ailHistoryFamily,
						ailHistoryFamilyDetail,
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
						CASE WHEN (@intoleranceSlice IS NOT NULL AND LEN(@intoleranceSlice) > 0 AND CHARINDEX(@intoleranceSlice, @strBlank) = 0) THEN @intoleranceSlice ELSE NULL END,
						CASE WHEN (@intoleranceDetailSlice IS NOT NULL AND LEN(@intoleranceDetailSlice) > 0 AND CHARINDEX(@intoleranceDetailSlice, @strBlank) = 0) THEN @intoleranceDetailSlice ELSE NULL END,
						CASE WHEN (@diseasesSlice IS NOT NULL AND LEN(@diseasesSlice) > 0 AND CHARINDEX(@diseasesSlice, @strBlank) = 0) THEN @diseasesSlice ELSE NULL END,
						CASE WHEN (@diseasesDetailSlice IS NOT NULL AND LEN(@diseasesDetailSlice) > 0 AND CHARINDEX(@diseasesDetailSlice, @strBlank) = 0) THEN @diseasesDetailSlice ELSE NULL END,
						CASE WHEN (@ailHistoryFamilySlice IS NOT NULL AND LEN(@ailHistoryFamilySlice) > 0 AND CHARINDEX(@ailHistoryFamilySlice, @strBlank) = 0) THEN @ailHistoryFamilySlice ELSE NULL END,
						CASE WHEN (@ailHistoryFamilyDetailSlice IS NOT NULL AND LEN(@ailHistoryFamilyDetailSlice) > 0 AND CHARINDEX(@ailHistoryFamilyDetailSlice, @strBlank) = 0) THEN @ailHistoryFamilyDetailSlice ELSE NULL END,
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
