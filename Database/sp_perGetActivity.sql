USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perGetActivity]    Script Date: 11/16/2015 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๘/๐๖/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลความสามารถพิเศษของบุคคล>
--  1. personId	เป็น VARCHAR รับค่ารหัสบุคคล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perGetActivity]
(
	@personId VARCHAR(10) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SET @personId = LTRIM(RTRIM(@personId))

	SELECT * FROM fnc_perGetActivity(@personId)
END