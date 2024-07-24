# Microsoft Developer Studio Generated NMAKE File, Based on TempFileInfo.dsp
!IF "$(CFG)" == ""
CFG=TempFileInfo - Win32 Debug
!MESSAGE No configuration specified. Defaulting to TempFileInfo - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "TempFileInfo - Win32 Release" && "$(CFG)" != "TempFileInfo - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "TempFileInfo.mak" CFG="TempFileInfo - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "TempFileInfo - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "TempFileInfo - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "TempFileInfo - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\TempFileInfo.exe"


CLEAN :
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\TempFileInfo.obj"
	-@erase "$(INTDIR)\TempFileInfo.pch"
	-@erase "$(INTDIR)\TempFileInfo.res"
	-@erase "$(INTDIR)\TempFileInfoDlg.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\TempFileInfo.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\inc" /I "..\demo32" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)\TempFileInfo.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

MTL=midl.exe
MTL_PROJ=/nologo /D "NDEBUG" /mktyplib203 /win32 
RSC=rc.exe
RSC_PROJ=/l 0x40e /fo"$(INTDIR)\TempFileInfo.res" /d "NDEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\TempFileInfo.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=faxcpp32.lib BiTiff.lib /nologo /subsystem:windows /incremental:no /pdb:"$(OUTDIR)\TempFileInfo.pdb" /machine:I386 /out:"$(OUTDIR)\TempFileInfo.exe" /libpath:"..\..\..\..\lib" 
LINK32_OBJS= \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\TempFileInfo.obj" \
	"$(INTDIR)\TempFileInfoDlg.obj" \
	"$(INTDIR)\TempFileInfo.res"

"$(OUTDIR)\TempFileInfo.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "TempFileInfo - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\TempFileInfo.exe" "$(OUTDIR)\TempFileInfo.bsc"


CLEAN :
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\StdAfx.sbr"
	-@erase "$(INTDIR)\TempFileInfo.obj"
	-@erase "$(INTDIR)\TempFileInfo.pch"
	-@erase "$(INTDIR)\TempFileInfo.res"
	-@erase "$(INTDIR)\TempFileInfo.sbr"
	-@erase "$(INTDIR)\TempFileInfoDlg.obj"
	-@erase "$(INTDIR)\TempFileInfoDlg.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\TempFileInfo.bsc"
	-@erase "$(OUTDIR)\TempFileInfo.exe"
	-@erase "$(OUTDIR)\TempFileInfo.ilk"
	-@erase "$(OUTDIR)\TempFileInfo.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\TempFileInfo.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

MTL=midl.exe
MTL_PROJ=/nologo /D "_DEBUG" /mktyplib203 /win32 
RSC=rc.exe
RSC_PROJ=/l 0x40e /fo"$(INTDIR)\TempFileInfo.res" /d "_DEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\TempFileInfo.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\StdAfx.sbr" \
	"$(INTDIR)\TempFileInfo.sbr" \
	"$(INTDIR)\TempFileInfoDlg.sbr"

"$(OUTDIR)\TempFileInfo.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=faxcpp32.lib BiTiff.lib /nologo /subsystem:windows /incremental:yes /pdb:"$(OUTDIR)\TempFileInfo.pdb" /debug /machine:I386 /out:"$(OUTDIR)\TempFileInfo.exe" /pdbtype:sept /libpath:"..\..\..\..\lib" 
LINK32_OBJS= \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\TempFileInfo.obj" \
	"$(INTDIR)\TempFileInfoDlg.obj" \
	"$(INTDIR)\TempFileInfo.res"

"$(OUTDIR)\TempFileInfo.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("TempFileInfo.dep")
!INCLUDE "TempFileInfo.dep"
!ELSE 
!MESSAGE Warning: cannot find "TempFileInfo.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "TempFileInfo - Win32 Release" || "$(CFG)" == "TempFileInfo - Win32 Debug"
SOURCE=.\StdAfx.cpp

!IF  "$(CFG)" == "TempFileInfo - Win32 Release"

CPP_SWITCHES=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\inc" /I "..\demo32" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)\TempFileInfo.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\TempFileInfo.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ELSEIF  "$(CFG)" == "TempFileInfo - Win32 Debug"

CPP_SWITCHES=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\TempFileInfo.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\StdAfx.sbr"	"$(INTDIR)\TempFileInfo.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ENDIF 

SOURCE=.\TempFileInfo.cpp

!IF  "$(CFG)" == "TempFileInfo - Win32 Release"


"$(INTDIR)\TempFileInfo.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\TempFileInfo.pch"


!ELSEIF  "$(CFG)" == "TempFileInfo - Win32 Debug"


"$(INTDIR)\TempFileInfo.obj"	"$(INTDIR)\TempFileInfo.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\TempFileInfo.pch"


!ENDIF 

SOURCE=.\TempFileInfo.rc

"$(INTDIR)\TempFileInfo.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)


SOURCE=.\TempFileInfoDlg.cpp

!IF  "$(CFG)" == "TempFileInfo - Win32 Release"


"$(INTDIR)\TempFileInfoDlg.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\TempFileInfo.pch"


!ELSEIF  "$(CFG)" == "TempFileInfo - Win32 Debug"


"$(INTDIR)\TempFileInfoDlg.obj"	"$(INTDIR)\TempFileInfoDlg.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\TempFileInfo.pch"


!ENDIF 


!ENDIF 

