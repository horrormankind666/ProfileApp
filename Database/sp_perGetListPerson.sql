USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perGetListPerson]    Script Date: 05/20/2015 13:53:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๔/๐๕/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลส่วนตัวของบุคคล>
--  1. personId	เป็น VARCHAR รับค่ารหัสบุคคล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perGetListPerson] 
(
	@personId VARCHAR(MAX) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	SET @personId = LTRIM(RTRIM(@personId))

	SELECT * FROM fnc_perGetListPerson(@personId, '', '')
END