USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpSetDeleteecpTabProgram]    Script Date: 26/1/2559 12:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Anussara Wanwang>
-- Create date: <19-03-2015>
-- Description:	<DELETE ecpTabProgram>
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpSetDeleteecpTabProgram]
	@id int
AS
BEGIN
		DELETE FROM ecpTabProgram WHERE ID = @id
END
