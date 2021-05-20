USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perGetWork]    Script Date: 11/16/2015 16:13:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๘/๐๖/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลการทำงานของบุคคล>
--  1. personId	เป็น VARCHAR รับค่ารหัสบุคคล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perGetWork] 
(
	@personId VARCHAR(10) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	SET @personId = LTRIM(RTRIM(@personId))

	SELECT * FROM fnc_perGetWork(@personId)
END