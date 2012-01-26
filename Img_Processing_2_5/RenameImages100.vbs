Dim sCurPath
sCurPath = CreateObject("Scripting.FileSystemObject").GetAbsolutePathName(".")
sCurPath = sCurPath & "\"
imgNum = 100

For count = 0 to 999
	imageDir = sCurPath & Cstr(imgNum)
	imageText = imageDir & ".txt"
	imageJPG = imageDir & ".jpg"
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	If objFSO.FileExists(imageText) Then
		objFSO.MoveFile imageText, imageJPG
	End If
	imgNum = imgNum + 1
NEXT
		Wscript.Echo "All Done!"
		wScript.Quit