select	b.studentCode,
		b.yearEntry,
		b.facultyId,
		b.pictureName,
		a.*		
from	Infinity..udsUploadLog as a inner join
		Infinity..stdStudent as b on a.perPersonId = b.personId
where	(a.profilepictureApprovalStatus = 'Y') and
		(a.identitycardApprovalStatus = 'Y') and
		(b.yearEntry = 2564) and
		(b.pictureName is null)
order by b.yearEntry, b.studentCode

--IN 6405553|6408213

update Infinity..stdStudent set
	pictureName = '97/J9MsvAXhZSVSOOfYoHSilA==.jpg'
where	studentCode = '6408213'

/*
6405553 => 37/oXk9BjzaO9i2JNmZs2_g_w==.jpg
6408213 => 97/J9MsvAXhZSVSOOfYoHSilA==.jpg
*/