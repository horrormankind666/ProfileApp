USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perGetListParent]    Script Date: 05/15/2015 12:45:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๕/๐๕/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลครอบครัวของบุคคล>
--  1. personId	เป็น VARCHAR รับค่ารหัสบุคคล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perGetListParent]
(
	@personId VARCHAR(MAX) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @personId = LTRIM(RTRIM(@personId))

	SELECT * FROM fnc_perGetListPersonParent(@personId, '', '')	
	SELECT * FROM fnc_perGetListAddressParent(@personId, '', '')
	SELECT * FROM fnc_perGetListWorkParent(@personId, '', '')
END