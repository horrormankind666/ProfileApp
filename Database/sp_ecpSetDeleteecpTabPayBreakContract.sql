USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpSetDeleteecpTabPayBreakContract]    Script Date: 26/1/2559 12:26:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Anussara Wanwang>
-- Create date: <19-03-2015>
-- Description:	<DELETE ecpTabPayBreakContract>
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpSetDeleteecpTabPayBreakContract]
	@id int
AS
BEGIN
	DELETE FROM CPTabPayBreakContract WHERE ID = @id
END
