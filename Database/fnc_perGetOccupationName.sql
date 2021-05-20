SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<�ط����� ��ѹ��>
-- Create date: <��/��/����>
-- Description:	<����Ѻ�ʴ����ͧ͢�Ҫվ�������>
-- =============================================
CREATE FUNCTION fnc_perGetOccupationName
(
	@id VARCHAR(2) = NULL,
	@lang VARCHAR(2) = NULL
)
RETURNS VARCHAR(255)
AS
BEGIN
	DECLARE @occupationName VARCHAR(255) = NULL

	IF (@lang = 'TH')
	BEGIN
		SET @occupationName = (
								CASE @id
									WHEN '01' THEN '�Ѻ�Ҫ���'
									WHEN '02' THEN '��ѡ�ҹ / �١��ҧ ��ǹ�Ҫ���'
									WHEN '03' THEN '��ѡ�ҹ / �١��ҧ�͡��'
									WHEN '04' THEN '��ѡ�ҹ�Ѱ����ˡԨ'
									WHEN '05' THEN '��áԨ��ǹ��� / ��Ң�� / �Ҫվ����� / ����ҹ'
									WHEN '06' THEN '�ɵá� / ��ǻ����'				
									WHEN '07' THEN 'ͧ������Ҫ�'
									WHEN '08' THEN '�Ѻ��ҧ'
									ELSE NULL
								END				
							  )
	END

	IF (@lang = 'EN')
	BEGIN
		SET @occupationName = (
								CASE @id
									WHEN '01' THEN 'Public Servant'
									WHEN '02' THEN 'Staff / Employee Government'
									WHEN '03' THEN 'Staff / Employee in Private Company'
									WHEN '04' THEN 'State Enterprise Employees'
									WHEN '05' THEN 'Independent Business / Family Business / Freelance / Housewife'
									WHEN '06' THEN 'Farmer / Fisherman'				
									WHEN '07' THEN 'Public Organization'
									WHEN '08' THEN 'Hired Hands'
									ELSE NULL
								END				
							  )
	END

	RETURN @occupationName
END