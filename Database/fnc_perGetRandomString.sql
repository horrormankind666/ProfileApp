SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ÂØ·¸ÀÙÁÔ µÇÑ¹¹Ò>
-- Create date	: <ðù/ññ/òõõø>
-- Description	: <ÊÓËÃÑºÊØèÁµÑÇÍÑ¡ÉÃ>
-- =============================================
CREATE FUNCTION [dbo].[fnc_perGetRandomString]
(
	@length INT = NULL
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @randomString NVARCHAR(MAX) = ''
	DECLARE @allowedChar NVARCHAR(MAX) = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
	DECLARE @allowedCharLength INT =  LEN(@allowedChar)
	DECLARE @randomNumber FLOAT = NULL
	DECLARE @i INT = 0
	
	WHILE (@i < @length)
	BEGIN
		SET @randomNumber = (SELECT randomNumber FROM vw_perRandomNumber)
		SET @randomString = (@randomString + SUBSTRING(@allowedChar, CONVERT(INT, @randomNumber * @allowedCharLength), 1))
		SET @i = @i + 1
	END	
	
	RETURN @randomString
END