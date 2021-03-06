USE [Infinity]
GO
/****** Object:  UserDefinedFunction [dbo].[fnc_perGetNationalityName]    Script Date: 26/5/2564 11:26:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๖/๐๕/๒๕๖๔>
-- Description	: <>
-- =============================================
ALTER function [dbo].[fnc_perGetNationalityName]
(
	@id varchar(3) = null,
	@lang varchar(2) = null
)
returns nvarchar(255)
as
begin
	set @id = ltrim(rtrim(isnull(@id, '')))
	set @lang = ltrim(rtrim(isnull(@lang, '')))
	
	declare @nationalityName nvarchar(255) = null

	select	@nationalityName = (
									case @lang 
										when 'TH' then thNationalityName
										when 'EN' then enNationalityName
									end
								)
	from	perNationality
	where	id = @id

    return @nationalityName
end