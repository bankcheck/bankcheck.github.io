# Microsoft Developer Studio Generated NMAKE File, Based on SCFollowMe.dsp
!IF "$(CFG)" == ""
CFG=SCFollowMe - Win32 Debug
!MESSAGE No configuration specified. Defaulting to SCFollowMe - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "SCFollowMe - Win32 Release" && "$(CFG)" != "SCFollowMe - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "SCFollowMe.mak" CFG="SCFollowMe - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "SCFollowMe - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "SCFollowMe - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "SCFollowMe - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\SCFollowMe.exe"


CLEAN :
	-@erase "$(INTDIR)\DlgHelp.obj"
	-@erase "$(INTDIR)\SCFollowMe.obj"
	-@erase "$(INTDIR)\SCFollowMe.pch"
	-@erase "$(INTDIR)\SCFollowMe.res"
	-@erase "$(INTDIR)\SCFollowMeDlg.obj"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\SCFollowMe.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)\SCFollowMe.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\SCFollowMe.res" /d "NDEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\SCFollowMe.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=voice.lib faxcpp32.lib bitiff.lib /nologo /subsystem:windows /incremental:no /pdb:"$(OUTDIR)\SCFollowMe.pdb" /machine:I386 /out:"$(OUTDIR)\SCFollowMe.exe" /libpath:"..\..\..\..\..\lib" 
LINK32_OBJS= \
	"$(INTDIR)\DlgHelp.obj" \
	"$(INTDIR)\SCFollowMe.obj" \
	"$(INTDIR)\SCFollowMeDlg.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\SCFollowMe.res"

"$(OUTDIR)\SCFollowMe.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "SCFollowMe - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\SCFollowMe.exe" "$(OUTDIR)\SCFollowMe.bsc"


CLEAN :
	-@erase "$(INTDIR)\DlgHelp.obj"
	-@erase "$(INTDIR)\DlgHelp.sbr"
	-@erase "$(INTDIR)\SCFollowMe.obj"
	-@erase "$(INTDIR)\SCFollowMe.pch"
	-@erase "$(INTDIR)\SCFollowMe.res"
	-@erase "$(INTDIR)\SCFollowMe.sbr"
	-@erase "$(INTDIR)\SCFollowMeDlg.obj"
	-@erase "$(INTDIR)\SCFollowMeDlg.sbr"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\StdAfx.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\SCFollowMe.bsc"
	-@erase "$(OUTDIR)\SCFollowMe.exe"
	-@erase "$(OUTDIR)\SCFollowMe.ilk"
	-@erase "$(OUTDIR)\SCFollowMe.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /GX /ZI /Od /I "..\..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\SCFollowMe.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\SCFollowMe.res" /d "_DEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\SCFollowMe.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\DlgHelp.sbr" \
	"$(INTDIR)\SCFollowMe.sbr" \
	"$(INTDIR)\SCFollowMeDlg.sbr" \
	"$(INTDIR)\StdAfx.sbr"

"$(OUTDIR)\SCFollowMe.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=voice.lib faxcpp32.lib bitiff.lib /nologo /subsystem:windows /incremental:yes /pdb:"$(OUTDIR)\SCFollowMe.pdb" /debug /machine:I386 /out:"$(OUTDIR)\SCFollowMe.exe" /pdbtype:sept /libpath:"..\..\..\..\..\lib" 
LINK32_OBJS= \
	"$(INTDIR)\DlgHelp.obj" \
	"$(INTDIR)\SCFollowMe.obj" \
	"$(INTDIR)\SCFollowMeDlg.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\SCFollowMe.res"

"$(OUTDIR)\SCFollowMe.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("SCFollowMe.dep")
!INCLUDE "SCFollowMe.dep"
!ELSE 
!MESSAGE Warning: cannot find "SCFollowMe.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "SCFollowMe - Win32 Release" || "$(CFG)" == "SCFollowMe - Win32 Debug"
SOURCE=.\DlgHelp.cpp

!IF  "$(CFG)" == "SCFollowMe - Win32 Release"


"$(INTDIR)\DlgHelp.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SCFollowMe.pch"


!ELSEIF  "$(CFG)" == "SCFollowMe - Win32 Debug"


"$(INTDIR)\DlgHelp.obj"	"$(INTDIR)\DlgHelp.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SCFollowMe.pch"


!ENDIF 

SOURCE=.\SCFollowMe.cpp

!IF  "$(CFG)" == "SCFollowMe - Win32 Release"


"$(INTDIR)\SCFollowMe.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SCFollowMe.pch"


!ELSEIF  "$(CFG)" == "SCFollowMe - Win32 Debug"


"$(INTDIR)\SCFollowMe.obj"	"$(INTDIR)\SCFollowMe.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SCFollowMe.pch"


!ENDIF 

SOURCE=.\SCFollowMe.rc

"$(INTDIR)\SCFollowMe.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)


SOURCE=.\SCFollowMeDlg.cpp

!IF  "$(CFG)" == "SCFollowMe - Win32 Release"


"$(INTDIR)\SCFollowMeDlg.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SCFollowMe.pch"


!ELSEIF  "$(CFG)" == "SCFollowMe - Win32 Debug"


"$(INTDIR)\SCFollowMeDlg.obj"	"$(INTDIR)\SCFollowMeDlg.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\SCFollowMe.pch"


!ENDIF 

SOURCE=.\StdAfx.cpp

!IF  "$(CFG)" == "SCFollowMe - Win32 Release"

CPP_SWITCHES=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)\SCFollowMe.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\SCFollowMe.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ELSEIF  "$(CFG)" == "SCFollowMe - Win32 Debug"

CPP_SWITCHES=/nologo /MDd /W3 /GX /ZI /Od /I "..\..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\SCFollowMe.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\StdAfx.sbr"	"$(INTDIR)\SCFollowMe.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ENDIF 


!ENDIF 

