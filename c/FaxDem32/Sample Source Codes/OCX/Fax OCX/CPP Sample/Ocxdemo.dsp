# Microsoft Developer Studio Project File - Name="OCXDEMO" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Application" 0x0101

CFG=OCXDEMO - Win32 Release
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "Ocxdemo.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "Ocxdemo.mak" CFG="OCXDEMO - Win32 Release"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "OCXDEMO - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "OCXDEMO - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
MTL=midl.exe
RSC=rc.exe

!IF  "$(CFG)" == "OCXDEMO - Win32 Release"

# PROP BASE Use_MFC 6
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir ".\Release"
# PROP BASE Intermediate_Dir ".\Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 6
# PROP Use_Debug_Libraries 0
# PROP Output_Dir ".\Release"
# PROP Intermediate_Dir ".\Release"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MD /W3 /GX /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Yu"stdafx.h" /c
# ADD CPP /nologo /Zp1 /MD /W3 /GX /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR /Yu"stdafx.h" /FD /c
# ADD BASE MTL /nologo /D "NDEBUG" /win32
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x409 /d "NDEBUG" /d "_AFXDLL"
# ADD RSC /l 0x409 /d "NDEBUG" /d "_AFXDLL"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 /nologo /subsystem:windows /machine:I386
# ADD LINK32 faxcpp32.lib /nologo /subsystem:windows /machine:I386 /libpath:"..\..\..\..\inc"

!ELSEIF  "$(CFG)" == "OCXDEMO - Win32 Debug"

# PROP BASE Use_MFC 6
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir ".\Debug"
# PROP BASE Intermediate_Dir ".\Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 6
# PROP Use_Debug_Libraries 1
# PROP Output_Dir ".\Debug"
# PROP Intermediate_Dir ".\Debug"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MDd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Yu"stdafx.h" /c
# ADD CPP /nologo /Zp1 /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR /Yu"stdafx.h" /FD /c
# ADD BASE MTL /nologo /D "_DEBUG" /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x409 /d "_DEBUG" /d "_AFXDLL"
# ADD RSC /l 0x409 /d "_DEBUG" /d "_AFXDLL"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 /nologo /subsystem:windows /debug /machine:I386
# ADD LINK32 faxcpp32.lib /nologo /subsystem:windows /debug /machine:I386 /libpath:"..\..\..\..\inc"

!ENDIF 

# Begin Target

# Name "OCXDEMO - Win32 Release"
# Name "OCXDEMO - Win32 Debug"
# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;hpj;bat;for;f90"
# Begin Source File

SOURCE=.\Dialogic.cpp
# End Source File
# Begin Source File

SOURCE=.\fax.cpp
# End Source File
# Begin Source File

SOURCE=.\FaxConfig.cpp
# End Source File
# Begin Source File

SOURCE=.\MainFrm.cpp
# End Source File
# Begin Source File

SOURCE=.\NMSOpen.cpp
# End Source File
# Begin Source File

SOURCE=.\OCXDEMO.cpp
# End Source File
# Begin Source File

SOURCE=.\OCXDEMO.rc
# End Source File
# Begin Source File

SOURCE=.\OcxdemoD.cpp
# End Source File
# Begin Source File

SOURCE=.\OcxdemoV.cpp
# End Source File
# Begin Source File

SOURCE=.\Options.cpp
# End Source File
# Begin Source File

SOURCE=.\ReadMe.txt
# End Source File
# Begin Source File

SOURCE=.\StdAfx.cpp
# ADD CPP /Yc"stdafx.h"
# End Source File
# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl;fi;fd"
# Begin Source File

SOURCE=.\DEFINES.H
# End Source File
# Begin Source File

SOURCE=.\Dialogic.h
# End Source File
# Begin Source File

SOURCE=.\FAX.H
# End Source File
# Begin Source File

SOURCE=.\FaxConfig.h
# End Source File
# Begin Source File

SOURCE=.\MAINFRM.H
# End Source File
# Begin Source File

SOURCE=.\NMSOpen.h
# End Source File
# Begin Source File

SOURCE=.\OCXDEMO.H
# End Source File
# Begin Source File

SOURCE=.\OCXDEMOD.H
# End Source File
# Begin Source File

SOURCE=.\OCXDEMOV.H
# End Source File
# Begin Source File

SOURCE=.\Options.h
# End Source File
# Begin Source File

SOURCE=.\STDAFX.H
# End Source File
# End Group
# Begin Group "Resource Files"

# PROP Default_Filter "ico;cur;bmp;dlg;rc2;rct;bin;cnt;rtf;gif;jpg;jpeg;jpe"
# Begin Source File

SOURCE=.\res\OCXDEMO.ico
# End Source File
# Begin Source File

SOURCE=.\res\OCXDEMO.rc2
# End Source File
# Begin Source File

SOURCE=.\res\OCXDEMOD.ico
# End Source File
# End Group
# End Target
# End Project
# Section OCXDEMO : {2E980303-C865-11CF-BA24-444553540000}
# 	0:7:FAX.cpp:C:\OCXDEMO\FAX.cpp
# 	0:5:FAX.h:C:\OCXDEMO\FAX.h
# 	2:21:DefaultSinkHeaderFile:fax.h
# 	2:16:DefaultSinkClass:CFAX
# End Section
# Section OLE Controls
# 	{2E980303-C865-11CF-BA24-444553540000}
# End Section
# Section OCXDEMO : {2E980301-C865-11CF-BA24-444553540000}
# 	2:5:Class:CFAX
# 	2:10:HeaderFile:fax.h
# 	2:8:ImplFile:fax.cpp
# End Section
