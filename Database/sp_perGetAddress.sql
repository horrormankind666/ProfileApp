USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perGetAddress]    Script Date: 11/16/2015 15:41:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๘/๐๖/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลที่อยู่ของบุคคล>
--  1. personId	เป็น VARCHAR รับค่ารหัสบุคคล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perGetAddress] 
(
	@personId VARCHAR(10) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @personId = LTRIM(RTRIM(@personId))
	
	SELECT * FROM fnc_perGetAddress(@personId)
END