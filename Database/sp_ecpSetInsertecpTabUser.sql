USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpSetInsertecpTabUser]    Script Date: 26/1/2559 12:25:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Anussara Wanwang>
-- Create date: <19-03-2015>
-- Description:	<AddUpdateData INSERT ecpTabUser>
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpSetInsertecpTabUser]
	@Username	varchar(50)	
	,@Password	varchar(50)	
	,@Name	varchar(100)	
	,@UserSection	char(1)	

AS
BEGIN
	DECLARE @UserLevel	varchar(50)
	SET @UserLevel = 'User'
	INSERT INTO ecpTabUser (Username, Password, Name, UserSection, UserLevel)
                        VALUES 
                        (
                       	@Username	
						,@Password	
						,@Name		
						,@UserSection
						,@UserLevel	
                        )
END
