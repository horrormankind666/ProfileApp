USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpSetDeleteecpTabScholarship]    Script Date: 26/1/2559 12:29:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Anussara Wanwang>
-- Create date: <19-03-2015>
-- Description:	<DELETE ecpTabScholarship>
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpSetDeleteecpTabScholarship]
	@id int
AS
BEGIN
	DELETE FROM ecpTabScholarship WHERE ID = @id
END
