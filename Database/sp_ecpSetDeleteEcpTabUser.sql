USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpSetDeleteEcpTabUser]    Script Date: 26/1/2559 12:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Anussara Wanwang>
-- Create date: <19-03-2015>
-- Description:	<AddUpdateData DELETE ecpTabUser>
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpSetDeleteEcpTabUser] 
	@usernameOld varchar(50)
	,@passwordold varchar(50)
AS
BEGIN
	DELETE FROM ecpTabUser WHERE (Username = @usernameOld) AND (Password = @passwordold)
END
