USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpSetDeleteecpTabInterest]    Script Date: 26/1/2559 12:26:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Anussara Wanwang>
-- Create date: <19-03-2015>
-- Description:	<DELETE ecpTabInterest>
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpSetDeleteecpTabInterest]
	@id int
AS
BEGIN
DELETE FROM ecpTabInterest WHERE ID = @id
END
