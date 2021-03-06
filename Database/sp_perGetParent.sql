USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perGetParent]    Script Date: 11/16/2015 16:11:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๘/๐๖/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลครอบครัวของบุคคล>
--  1. personId	เป็น VARCHAR รับค่ารหัสบุคคล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perGetParent]
(
	@personId VARCHAR(10) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @personId = LTRIM(RTRIM(@personId))

	SELECT * FROM fnc_perGetPersonParent(@personId)
	SELECT * FROM fnc_perGetAddressParent(@personId)
	SELECT * FROM fnc_perGetWorkParent(@personId)
END