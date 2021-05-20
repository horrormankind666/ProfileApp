USE [MUStudent]
GO
/****** Object:  StoredProcedure [dbo].[sp_perGeneratePersonId]    Script Date: 03/31/2014 11:40:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๑/๑๑/๒๕๕๖>
-- Description	: <สำหรับสร้างรหัสให้กับตาราง perPerson>
-- Parameter
--  1. personId				เป็น VARCHAR	ส่งค่ารหัสบุคคล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perGeneratePersonId]
(
	@personId VARCHAR(MAX) OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON
	
	DECLARE @year INT = NULL
	DECLARE @seq INT = NULL

	BEGIN TRAN
		SET @year = YEAR(GETDATE()) + 543
		SET @seq = (SELECT MAX(seqPerson) AS seq FROM perPersonIdLog GROUP BY yearPerson HAVING yearPerson = @year)

		IF (@seq IS NULL) SET @seq = 0

		INSERT INTO perPersonIdLog (yearPerson, seqPerson) VALUES (@year, @seq + 1)	
	
		SET @personId = (SELECT CONVERT(VARCHAR(4), @year) + RIGHT('000000' + CONVERT(VARCHAR, (@seq + 1)), 6))
	COMMIT TRAN		
END
