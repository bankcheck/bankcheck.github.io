# Microsoft Developer Studio Project File - Name="Demo32" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Application" 0x0101

CFG=Demo32 - Win32 Release
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "Demo32.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "Demo32.mak" CFG="Demo32 - Win32 Release"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "Demo32 - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "Demo32 - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
MTL=midl.exe
RSC=rc.exe

!IF  "$(CFG)" == "Demo32 - Win32 Release"

# PROP BASE Use_MFC 1
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir ".\Win32_Re"
# PROP BASE Intermediate_Dir ".\Win32_Re"
# PROP Use_MFC 1
# PROP Use_Debug_Libraries 0
# PROP Output_Dir ".\Winrel_b"
# PROP Intermediate_Dir ".\Winrel_b"
# PROP Ignore_Export_Lib 0
# ADD BASE CPP /nologo /Zp1 /MT /W4 /GX /I "..\inc" /D "NDEBUG" /D "WIN32" /D "_WINDOWS" /D "_MBCS" /D "_THREAD" /FR /YX /J /c
# ADD CPP /nologo /Zp1 /MT /W3 /GX /Od /I "..\..\..\..\inc" /D "NDEBUG" /D "WIN32" /D "_WINDOWS" /D "_THREAD" /D "_MBCS" /Fr /YX /J /FD /c
# ADD BASE MTL /nologo /D "NDEBUG" /win32
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x409 /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG" /d "WIN32"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 /nologo /stack:0x10240 /subsystem:windows /machine:IX86
# SUBTRACT BASE LINK32 /incremental:yes
# ADD LINK32 faxcpp32.lib bidib.lib bijpeg.lib pbook32.lib biprint.lib bitiff.lib bidisp.lib /nologo /subsystem:windows /machine:IX86 /libpath:"..\..\..\..\Lib"
# SUBTRACT LINK32 /verbose /incremental:yes

!ELSEIF  "$(CFG)" == "Demo32 - Win32 Debug"

# PROP BASE Use_MFC 1
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir ".\Win32_De"
# PROP BASE Intermediate_Dir ".\Win32_De"
# PROP Use_MFC 1
# PROP Use_Debug_Libraries 1
# PROP Output_Dir ".\Windeb_b"
# PROP Intermediate_Dir ".\Windeb_b"
# PROP Ignore_Export_Lib 0
# ADD BASE CPP /nologo /Zp1 /MT /W4 /GX /Zi /Od /I "..\inc" /D "WIN32" /D "_WINDOWS" /D "_MBCS" /D "_THREAD" /FR /YX /Fd"IMG.PDB" /J /c
# ADD CPP /nologo /Zp1 /MTd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_WINDOWS" /D "_THREAD" /D "_MBCS" /Fr /YX /Fd".\IMG.PDB" /J /FD /c
# ADD BASE MTL /nologo /D "_DEBUG" /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x409 /d "_DEBUG"
# ADD RSC /l 0x409 /d "_DEBUG" /d "WIN32"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 /nologo /stack:0x10240 /subsystem:windows /incremental:no /debug /machine:IX86
# ADD LINK32 faxcpp32.lib bidib.lib bijpeg.lib pbook32.lib biprint.lib bitiff.lib bidisp.lib /nologo /subsystem:windows /incremental:no /debug /machine:IX86 /libpath:"..\..\..\..\Lib"
# SUBTRACT LINK32 /pdb:none

!ENDIF 

# Begin Target

# Name "Demo32 - Win32 Release"
# Name "Demo32 - Win32 Debug"
# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;hpj;bat;for;f90"
# Begin Source File

SOURCE=.\ASCII.CPP
# End Source File
# Begin Source File

SOURCE=.\BLOCKDOC.CPP
# End Source File
# Begin Source File

SOURCE=.\CFUNC.C
# End Source File
# Begin Source File

SOURCE=.\DEMO.CPP
# End Source File
# Begin Source File

SOURCE=.\DEMO.RC
# End Source File
# Begin Source File

SOURCE=.\DEMO32.DEF
# End Source File
# Begin Source File

SOURCE=.\DIALOGS.CPP
# End Source File
# Begin Source File

SOURCE=.\DIBPAL.CPP
# End Source File
# Begin Source File

SOURCE=.\DISP.CPP
# End Source File
# Begin Source File

SOURCE=.\DLGBC.CPP
# End Source File
# Begin Source File

SOURCE=.\DLGC.CPP
# End Source File
# Begin Source File

SOURCE=.\DlgNms.cpp
# End Source File
# Begin Source File

SOURCE=.\FAXDLG.CPP
# End Source File
# Begin Source File

SOURCE=.\IMGDOC.CPP
# End Source File
# Begin Source File

SOURCE=.\IMGVW.CPP
# End Source File
# Begin Source File

SOURCE=.\INPUTVW.CPP
# End Source File
# Begin Source File

SOURCE=.\LOGS.CPP
# End Source File
# Begin Source File

SOURCE=.\LOGSFRAM.CPP
# End Source File
# Begin Source File

SOURCE=.\LOGSVIEW.CPP
# End Source File
# Begin Source File

SOURCE=.\LWLBOX.CPP
# End Source File
# Begin Source File

SOURCE=.\MAGNIFYW.CPP
# End Source File
# Begin Source File

SOURCE=.\MAINFRM.CPP
# End Source File
# Begin Source File

SOURCE=.\MDIChildFrame.cpp
# End Source File
# Begin Source File

SOURCE=.\Opencmtx.cpp
# End Source File
# Begin Source File

SOURCE=.\PBPOS.CPP
# End Source File
# Begin Source File

SOURCE=.\PHBDLG.CPP
# End Source File
# Begin Source File

SOURCE=.\SEARCHBX.CPP
# End Source File
# Begin Source File

SOURCE=.\SPLITTER.CPP
# End Source File
# Begin Source File

SOURCE=.\STDAFX.CPP
# End Source File
# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl;fi;fd"
# Begin Source File

SOURCE=.\Ascii.h
# End Source File
# Begin Source File

SOURCE=.\bitmani.h
# End Source File
# Begin Source File

SOURCE=.\Blicectr.h
# End Source File
# Begin Source File

SOURCE=.\Blockdoc.h
# End Source File
# Begin Source File

SOURCE=.\CFunc.h
# End Source File
# Begin Source File

SOURCE=.\Demo.h
# End Source File
# Begin Source File

SOURCE=.\Dialogs.h
# End Source File
# Begin Source File

SOURCE=.\Dibpal.h
# End Source File
# Begin Source File

SOURCE=.\Disp.h
# End Source File
# Begin Source File

SOURCE=.\DLGBC.H
# End Source File
# Begin Source File

SOURCE=.\DLGC.H
# End Source File
# Begin Source File

SOURCE=.\DlgFaxCloseExit.h
# End Source File
# Begin Source File

SOURCE=.\DlgNms.h
# End Source File
# Begin Source File

SOURCE=.\Faxdlg.h
# End Source File
# Begin Source File

SOURCE=.\Imgdoc.h
# End Source File
# Begin Source File

SOURCE=.\Imgvw.h
# End Source File
# Begin Source File

SOURCE=.\Inputvw.h
# End Source File
# Begin Source File

SOURCE=.\Logs.h
# End Source File
# Begin Source File

SOURCE=.\Logsfram.h
# End Source File
# Begin Source File

SOURCE=.\Logsview.h
# End Source File
# Begin Source File

SOURCE=.\Lwlbox.h
# End Source File
# Begin Source File

SOURCE=.\Magnify.h
# End Source File
# Begin Source File

SOURCE=.\Magnifyw.h
# End Source File
# Begin Source File

SOURCE=.\Mainfrm.h
# End Source File
# Begin Source File

SOURCE=.\MDIChildFrame.h
# End Source File
# Begin Source File

SOURCE=.\Opencmtx.h
# End Source File
# Begin Source File

SOURCE=.\Pbook.h
# End Source File
# Begin Source File

SOURCE=.\PBPOS.H
# End Source File
# Begin Source File

SOURCE=.\Phbdlg.h
# End Source File
# Begin Source File

SOURCE=.\resource.h
# End Source File
# Begin Source File

SOURCE=.\Searchbx.h
# End Source File
# Begin Source File

SOURCE=.\Splitter.h
# End Source File
# Begin Source File

SOURCE=.\STDAFX.H
# End Source File
# Begin Source File

SOURCE=.\TOOLBARX.H
# End Source File
# Begin Source File

SOURCE=.\tools.h
# End Source File
# Begin Source File

SOURCE=.\V_config.h
# End Source File
# End Group
# Begin Group "Resource Files"

# PROP Default_Filter "ico;cur;bmp;dlg;rc2;rct;bin;cnt;rtf;gif;jpg;jpeg;jpe"
# Begin Source File

SOURCE=.\BMP00001.BMP
# End Source File
# Begin Source File

SOURCE=.\BMP00002.BMP
# End Source File
# Begin Source File

SOURCE=.\BMP00003.BMP
# End Source File
# Begin Source File

SOURCE=.\BMP00004.BMP
# End Source File
# Begin Source File

SOURCE=.\BRIGHTNE.ICO
# End Source File
# Begin Source File

SOURCE=.\COLOR.ICO
# End Source File
# Begin Source File

SOURCE=.\CONTRAST.CUR
# End Source File
# Begin Source File

SOURCE=.\CONTRAST.ICO
# End Source File
# Begin Source File

SOURCE=.\CUR00001.CUR
# End Source File
# Begin Source File

SOURCE=.\CURSOR1.CUR
# End Source File
# Begin Source File

SOURCE=.\ERROR.ICO
# End Source File
# Begin Source File

SOURCE=.\ICO00001.ICO
# End Source File
# Begin Source File

SOURCE=.\ICON1.ICO
# End Source File
# Begin Source File

SOURCE=.\IDR_FAXB.ICO
# End Source File
# Begin Source File

SOURCE=.\IDR_OUTL.ICO
# End Source File
# Begin Source File

SOURCE=.\IDR_POLL.ICO
# End Source File
# Begin Source File

SOURCE=.\IDR_RECL.ICO
# End Source File
# Begin Source File

SOURCE=.\IDR_SEND.ICO
# End Source File
# Begin Source File

SOURCE=.\IMG.ICO
# End Source File
# Begin Source File

SOURCE=.\IMG.RC2
# End Source File
# Begin Source File

SOURCE=.\IMGDOC.ICO
# End Source File
# Begin Source File

SOURCE=.\MAGNIFY.CUR
# End Source File
# Begin Source File

SOURCE=.\TOOLBAR.BMP
# End Source File
# Begin Source File

SOURCE=.\TOOLBAR2.BMP
# End Source File
# Begin Source File

SOURCE=.\TOOLBAR_.BMP
# End Source File
# Begin Source File

SOURCE=.\ZOOM.CUR
# End Source File
# End Group
# End Target
# End Project
