USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_udsSetSPictureLookup]    Script Date: 11/16/2015 15:15:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๔/๐๗/๒๕๕๘>
-- Description	: <สำหรับบันทึกข้อมูลตาราง SPictureLookup ครั้งละ ๑ เรคคอร์ด>
--	1. studentId	เป็น VARCHAR	รับค่ารหัสนักศึกษา
--	2. fileName		เป็น VARCHAR	รับค่าชื่อไฟล์
--  3. folderName	เป็น VARCHAR	รับค่าชื่อโฟลเดอร์
-- =============================================
ALTER PROCEDURE [dbo].[sp_udsSetSPictureLookup]
(
	@studentId VARCHAR(7) = NULL,
	@fileName VARCHAR(50) = NULL,
	@folderName VARCHAR(2) = NULL
)	
AS
BEGIN
	SET NOCOUNT ON

	SET @studentId = LTRIM(RTRIM(@studentId))
	SET @fileName = LTRIM(RTRIM(@fileName))
	SET @folderName = LTRIM(RTRIM(@folderName))
		
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @action VARCHAR(10) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	
	IF (@studentId IS NOT NULL AND LEN(@studentId) > 0)
	BEGIN
		SET @rowCountUpdate = (SELECT COUNT(StudentID) FROM MUStudent..SPictureLookup WHERE StudentID = @studentId)
		SET @action = (CASE WHEN (@rowCountUpdate = 0) THEN 'INSERT' ELSE 'UPDATE' END)		
					 
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
 					INSERT INTO MUStudent..SPictureLookup
 					(
						StudentID,
						FileName,
						FolderName
					)
					VALUES
					(
						@studentId,
						(CASE WHEN (@fileName IS NOT NULL AND LEN(@filename) > 0 AND CHARINDEX(@filename, @strBlank) = 0) THEN @filename ELSE NULL END),
						(CASE WHEN (@folderName IS NOT NULL AND LEN(@folderName) > 0 AND CHARINDEX(@folderName, @strBlank) = 0) THEN @folderName ELSE NULL END)
					)		
					
					SET @rowCount = @rowCount + 1
				END					 
				
				IF (@action = 'UPDATE')
				BEGIN
					UPDATE MUStudent..SPictureLookup SET
						FileName	= (CASE WHEN (@fileName IS NOT NULL AND LEN(@filename) > 0 AND CHARINDEX(@filename, @strBlank) = 0) THEN @filename ELSE FileName END),
						FolderName	= (CASE WHEN (@folderName IS NOT NULL AND LEN(@folderName) > 0 AND CHARINDEX(@folderName, @strBlank) = 0) THEN @folderName ELSE FolderName END)
					WHERE StudentID = @studentId
					
					SET @rowCount = @rowCount + 1							
				END																			
			COMMIT TRAN									
		END TRY
		BEGIN CATCH		
			ROLLBACK TRAN
		END CATCH					
	END		
	
	SELECT @rowCount, @action
END