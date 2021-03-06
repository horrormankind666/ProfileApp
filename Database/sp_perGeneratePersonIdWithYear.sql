USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perGeneratePersonIdWithYear]    Script Date: 03/23/2015 13:48:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๑/๑๑/๒๕๕๖>
-- Description	: <สำหรับสร้างรหัสให้กับตาราง perPerson>
-- Parameter
--	1. year		เป็น VARCHAR	ส่งค่าปี
--  2. personId	เป็น VARCHAR	ส่งค่ารหัสบุคคล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perGeneratePersonIdWithYear]
(
	@year VARCHAR(4),
	@personId VARCHAR(MAX) OUTPUT	
)
AS
BEGIN
	SET NOCOUNT ON
	
	DECLARE @seq INT = NULL

	SET @seq = (SELECT MAX(seqPerson) AS seq FROM perPersonIdLog GROUP BY yearPerson HAVING yearPerson = @year)

	IF (@seq IS NULL) SET @seq = 0

	INSERT INTO perPersonIdLog (yearPerson, seqPerson) VALUES (@year, @seq + 1)	
	
	SET @personId = (SELECT CONVERT(VARCHAR(4), @year) + RIGHT('000000' + CONVERT(VARCHAR, (@seq + 1)), 6))
END