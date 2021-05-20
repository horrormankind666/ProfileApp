USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpSetUpdatesendbreakcontract]    Script Date: 26/1/2559 12:33:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Anussara Wanwang>
-- Create date: <19-03-2015>
-- Description:	<UPDATE sendbreakcontract>
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpSetUpdatesendbreakcontract]
	@id int
AS
BEGIN
	UPDATE ecpTransBreakContract SET
	StatusSend = '2'
	,DateTimeSend = GETDATE()
	WHERE ID = @id
END
