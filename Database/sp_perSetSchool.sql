USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_plcSetDistrict]    Script Date: 08/10/2015 09:47:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๐๔/๑๑/๒๕๕๗>
-- Description	: <สำหรับบันทึกข้อมูลตาราง plcDistrict ครั้งละ ๑ เรคคอร์ด>
--  1. action			เป็น VARCHAR	รับค่าการกระทำกับฐานข้อมูล
--	2. id				เป็น VARCHAR	รับค่ารหัสโรงเรียน
--  3. plcProvinceId	เป็น VARCHAR	รับค่ารหัสจังหวัด
--  4. thSchoolName		เป็น NVARCHAR	รับค่าชื่อโรงเรียนภาษาไทย
--  5. enSchoolName		เป็น NVARCHAR	รับค่าชื่อโรงเรียนภาษาอังกฤษ
--  6. cancel			เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  7. by				เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetSchool]
(
	@action VARCHAR(10) = NULL,
	@id VARCHAR(MAX) = NULL,
	@plcProvinceId VARCHAR(MAX) = NULL,
	@thSchoolName NVARCHAR(MAX) = NULL,
	@enSchoolName NVARCHAR(MAX) = NULL,
	@cancel VARCHAR(MAX) = NULL,
	@by NVARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @action = LTRIM(RTRIM(@action))
	SET @id = LTRIM(RTRIM(@id))
	SET @plcProvinceId = LTRIM(RTRIM(@plcProvinceId))
	SET @thSchoolName = LTRIM(RTRIM(@thSchoolName))
	SET @enSchoolName = LTRIM(RTRIM(@enSchoolName))	
	SET @cancel = LTRIM(RTRIM(@cancel))
	SET @by = LTRIM(RTRIM(@by))
	
	DECLARE @table VARCHAR(50) = 'perSchool'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	DECLARE @ip VARCHAR(255) = dbo.fnc_perGetIP()
	
	SET @action = UPPER(@action)
	
	IF (@action = 'INSERT' OR @action = 'UPDATE' OR @action = 'DELETE')
	BEGIN
		SET @value = 'id=' + (CASE WHEN (@id IS NOT NULL AND LEN(@id) > 0 AND CHARINDEX(@id, @strBlank) = 0) THEN ('"' + @id + '"') ELSE 'NULL' END) + ', ' +
					 'plcProvinceId=' + (CASE WHEN (@plcProvinceId IS NOT NULL AND LEN(@plcProvinceId) > 0 AND CHARINDEX(@plcProvinceId, @strBlank) = 0) THEN ('"' + @plcProvinceId + '"') ELSE 'NULL' END) + ', ' +
					 'thSchoolName=' + (CASE WHEN (@thSchoolName IS NOT NULL AND LEN(@thSchoolName) > 0 AND CHARINDEX(@thSchoolName, @strBlank) = 0) THEN ('"' + @thSchoolName + '"') ELSE 'NULL' END) + ', ' +
					 'enSchoolName=' + (CASE WHEN (@enSchoolName IS NOT NULL AND LEN(@enSchoolName) > 0 AND CHARINDEX(@enSchoolName, @strBlank) = 0) THEN ('"' + @enSchoolName + '"') ELSE 'NULL' END) + ', ' +
					 'cancel=' + (CASE WHEN (@cancel IS NOT NULL AND LEN(@cancel) > 0 AND CHARINDEX(@cancel, @strBlank) = 0) THEN ('"' + @cancel + '"') ELSE 'NULL' END)
					 
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
 					INSERT INTO perSchool
 					(
						id,
						plcProvinceId,
						thSchoolName,
						enSchoolName,
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
						CASE WHEN (@plcProvinceId IS NOT NULL AND LEN(@plcProvinceId) > 0 AND CHARINDEX(@plcProvinceId, @strBlank) = 0) THEN @plcProvinceId ELSE NULL END,
						CASE WHEN (@thSchoolName IS NOT NULL AND LEN(@thSchoolName) > 0 AND CHARINDEX(@thSchoolName, @strBlank) = 0) THEN @thSchoolName ELSE NULL END,
						CASE WHEN (@enSchoolName IS NOT NULL AND LEN(@enSchoolName) > 0 AND CHARINDEX(@enSchoolName, @strBlank) = 0) THEN @enSchoolName ELSE NULL END,
						CASE WHEN (@cancel IS NOT NULL AND LEN(@cancel) > 0 AND CHARINDEX(@cancel, @strBlank) = 0) THEN @cancel ELSE NULL END,
						GETDATE(),
						CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE NULL END,
						@ip,
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
						SET @rowCountUpdate = (SELECT COUNT(id) FROM perSchool WHERE id = @id)
						
						IF (@rowCountUpdate > 0)
						BEGIN
							IF (@action = 'UPDATE')
							BEGIN
								UPDATE perSchool SET									
									id = CASE WHEN (@id IS NOT NULL AND LEN(@id) > 0 AND CHARINDEX(@id, @strBlank) = 0) THEN @id ELSE (CASE WHEN (@id IS NOT NULL AND (LEN(@id) = 0 OR CHARINDEX(@id, @strBlank) > 0)) THEN NULL ELSE id END) END,
									plcProvinceId = CASE WHEN (@plcProvinceId IS NOT NULL AND LEN(@plcProvinceId) > 0 AND CHARINDEX(@plcProvinceId, @strBlank) = 0) THEN @plcProvinceId ELSE (CASE WHEN (@plcProvinceId IS NOT NULL AND (LEN(@plcProvinceId) = 0 OR CHARINDEX(@plcProvinceId, @strBlank) > 0)) THEN NULL ELSE plcProvinceId END) END,
									thSchoolName = CASE WHEN (@thSchoolName IS NOT NULL AND LEN(@thSchoolName) > 0 AND CHARINDEX(@thSchoolName, @strBlank) = 0) THEN @thSchoolName ELSE (CASE WHEN (@thSchoolName IS NOT NULL AND (LEN(@thSchoolName) = 0 OR CHARINDEX(@thSchoolName, @strBlank) > 0)) THEN NULL ELSE thSchoolName END) END,
									enSchoolName = CASE WHEN (@enSchoolName IS NOT NULL AND LEN(@enSchoolName) > 0 AND CHARINDEX(@enSchoolName, @strBlank) = 0) THEN @enSchoolName ELSE (CASE WHEN (@enSchoolName IS NOT NULL AND (LEN(@enSchoolName) = 0 OR CHARINDEX(@enSchoolName, @strBlank) > 0)) THEN NULL ELSE enSchoolName END) END,
									cancel = CASE WHEN (@cancel IS NOT NULL AND LEN(@cancel) > 0 AND CHARINDEX(@cancel, @strBlank) = 0) THEN @cancel ELSE (CASE WHEN (@cancel IS NOT NULL AND (LEN(@cancel) = 0 OR CHARINDEX(@cancel, @strBlank) > 0)) THEN NULL ELSE cancel END) END,
									modifyDate = GETDATE(),
									modifyBy = CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE (CASE WHEN (@by IS NOT NULL AND (LEN(@by) = 0 OR CHARINDEX(@by, @strBlank) > 0)) THEN NULL ELSE modifyBy END) END,
									modifyIp = @ip
								WHERE id = @id
							END
							
							IF (@action = 'DELETE')								
							BEGIN
								DELETE FROM perSchool WHERE id = @id
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
