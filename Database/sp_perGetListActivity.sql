USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perGetListActivity]    Script Date: 05/15/2015 12:42:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๕/๐๕/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลความสามารถพิเศษของบุคคล>
--  1. personId	เป็น VARCHAR รับค่ารหัสบุคคล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perGetListActivity]
(
	@personId VARCHAR(MAX) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SET @personId = LTRIM(RTRIM(@personId))

	SELECT * FROM fnc_perGetListActivity(@personId, '', '')
END