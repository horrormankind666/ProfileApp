USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perGetListAddress]    Script Date: 05/15/2015 12:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๔/๐๕/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลที่อยู่ของบุคคล>
--  1. personId	เป็น VARCHAR รับค่ารหัสบุคคล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perGetListAddress] 
(
	@personId VARCHAR(MAX) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @personId = LTRIM(RTRIM(@personId))
	
	SELECT * FROM fnc_perGetListAddress(@personId, '', '')
END