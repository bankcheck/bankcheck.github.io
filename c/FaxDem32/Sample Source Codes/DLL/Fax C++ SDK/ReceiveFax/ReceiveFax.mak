# Microsoft Developer Studio Generated NMAKE File, Based on ReceiveFax.dsp
!IF "$(CFG)" == ""
CFG=ReceiveFax - Win32 Debug
!MESSAGE No configuration specified. Defaulting to ReceiveFax - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "ReceiveFax - Win32 Release" && "$(CFG)" != "ReceiveFax - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "ReceiveFax.mak" CFG="ReceiveFax - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "ReceiveFax - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "ReceiveFax - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "ReceiveFax - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\ReceiveFax.exe" "$(OUTDIR)\ReceiveFax.bsc"


CLEAN :
	-@erase "$(INTDIR)\DlgFaxClose.obj"
	-@erase "$(INTDIR)\DlgFaxClose.sbr"
	-@erase "$(INTDIR)\dlgFaxPortSetup.obj"
	-@erase "$(INTDIR)\dlgFaxPortSetup.sbr"
	-@erase "$(INTDIR)\ReceiveFax.obj"
	-@erase "$(INTDIR)\ReceiveFax.pch"
	-@erase "$(INTDIR)\ReceiveFax.res"
	-@erase "$(INTDIR)\ReceiveFax.sbr"
	-@erase "$(INTDIR)\ReceiveFaxDlg.obj"
	-@erase "$(INTDIR)\ReceiveFaxDlg.sbr"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\StdAfx.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\ReceiveFax.bsc"
	-@erase "$(OUTDIR)\ReceiveFax.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\ReceiveFax.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\ReceiveFax.res" /d "NDEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\ReceiveFax.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\DlgFaxClose.sbr" \
	"$(INTDIR)\dlgFaxPortSetup.sbr" \
	"$(INTDIR)\ReceiveFax.sbr" \
	"$(INTDIR)\ReceiveFaxDlg.sbr" \
	"$(INTDIR)\StdAfx.sbr"

"$(OUTDIR)\ReceiveFax.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=faxcpp32.lib /nologo /subsystem:windows /incremental:no /pdb:"$(OUTDIR)\ReceiveFax.pdb" /machine:I386 /out:"$(OUTDIR)\ReceiveFax.exe" /libpath:"..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\DlgFaxClose.obj" \
	"$(INTDIR)\dlgFaxPortSetup.obj" \
	"$(INTDIR)\ReceiveFax.obj" \
	"$(INTDIR)\ReceiveFaxDlg.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\ReceiveFax.res"

"$(OUTDIR)\ReceiveFax.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "ReceiveFax - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\ReceiveFax.exe" "$(OUTDIR)\ReceiveFax.bsc"


CLEAN :
	-@erase "$(INTDIR)\DlgFaxClose.obj"
	-@erase "$(INTDIR)\DlgFaxClose.sbr"
	-@erase "$(INTDIR)\dlgFaxPortSetup.obj"
	-@erase "$(INTDIR)\dlgFaxPortSetup.sbr"
	-@erase "$(INTDIR)\ReceiveFax.obj"
	-@erase "$(INTDIR)\ReceiveFax.pch"
	-@erase "$(INTDIR)\ReceiveFax.res"
	-@erase "$(INTDIR)\ReceiveFax.sbr"
	-@erase "$(INTDIR)\ReceiveFaxDlg.obj"
	-@erase "$(INTDIR)\ReceiveFaxDlg.sbr"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\StdAfx.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\ReceiveFax.bsc"
	-@erase "$(OUTDIR)\ReceiveFax.exe"
	-@erase "$(OUTDIR)\ReceiveFax.ilk"
	-@erase "$(OUTDIR)\ReceiveFax.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\ReceiveFax.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\ReceiveFax.res" /d "_DEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\ReceiveFax.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\DlgFaxClose.sbr" \
	"$(INTDIR)\dlgFaxPortSetup.sbr" \
	"$(INTDIR)\ReceiveFax.sbr" \
	"$(INTDIR)\ReceiveFaxDlg.sbr" \
	"$(INTDIR)\StdAfx.sbr"

"$(OUTDIR)\ReceiveFax.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=faxcpp32.lib bitiff.lib /nologo /subsystem:windows /incremental:yes /pdb:"$(OUTDIR)\ReceiveFax.pdb" /debug /machine:I386 /out:"$(OUTDIR)\ReceiveFax.exe" /pdbtype:sept /libpath:"..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\DlgFaxClose.obj" \
	"$(INTDIR)\dlgFaxPortSetup.obj" \
	"$(INTDIR)\ReceiveFax.obj" \
	"$(INTDIR)\ReceiveFaxDlg.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\ReceiveFax.res"

"$(OUTDIR)\ReceiveFax.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("ReceiveFax.dep")
!INCLUDE "ReceiveFax.dep"
!ELSE 
!MESSAGE Warning: cannot find "ReceiveFax.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "ReceiveFax - Win32 Release" || "$(CFG)" == "ReceiveFax - Win32 Debug"
SOURCE=.\DlgFaxClose.cpp

"$(INTDIR)\DlgFaxClose.obj"	"$(INTDIR)\DlgFaxClose.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveFax.pch"


SOURCE=.\dlgFaxPortSetup.cpp

"$(INTDIR)\dlgFaxPortSetup.obj"	"$(INTDIR)\dlgFaxPortSetup.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveFax.pch"


SOURCE=.\ReceiveFax.cpp

"$(INTDIR)\ReceiveFax.obj"	"$(INTDIR)\ReceiveFax.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveFax.pch"


SOURCE=.\ReceiveFax.rc

"$(INTDIR)\ReceiveFax.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)


SOURCE=.\ReceiveFaxDlg.cpp

"$(INTDIR)\ReceiveFaxDlg.obj"	"$(INTDIR)\ReceiveFaxDlg.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\ReceiveFax.pch"


SOURCE=.\StdAfx.cpp

!IF  "$(CFG)" == "ReceiveFax - Win32 Release"

CPP_SWITCHES=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\ReceiveFax.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\StdAfx.sbr"	"$(INTDIR)\ReceiveFax.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ELSEIF  "$(CFG)" == "ReceiveFax - Win32 Debug"

CPP_SWITCHES=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\ReceiveFax.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\StdAfx.sbr"	"$(INTDIR)\ReceiveFax.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ENDIF 


!ENDIF 

