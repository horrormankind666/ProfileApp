USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpGetInterestDefaulted]    Script Date: 12/1/2559 14:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๒/๐๑/๒๕๕๙>
-- Description	: <สำหรับแสดงข้อมูลดอกเบี้ยจากการผิดนัดชำระ>
--  1. id	เป็น VARCHAR	รับค่ารหัสดอกเบี้ยจากการผิดนัดชำระ
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpGetInterestDefaulted]
(
	@id VARCHAR(2) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	SET @id = LTRIM(RTRIM(@id))		

	SELECT	ecpitr.id,
			ecpitr.interestInContract,
			ecpitr.interestNotInContract,
			ecpitr.cancelledStatus
	FROM	Infinity..ecpInterestDefaulted AS ecpitr
	WHERE	(ecpitr.id = @id)
END