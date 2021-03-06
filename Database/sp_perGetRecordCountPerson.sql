USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perGetRecordCountPerson]    Script Date: 11/16/2015 16:13:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๔/๐๕/๒๕๕๘>
-- Description	: <สำหรับเรียกดูข้อมูลจำนวนรายการของนักศึกษา>
-- Parameter
--  1. personId		เป็น VARCHAR	รับค่ารหัสบุคคล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perGetRecordCountPerson]
(
	@personId VARCHAR(10) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @personId = LTRIM(RTRIM(@personId))
	
	SELECT * FROM dbo.fnc_perGetRecordCountPerson(@personId)
END