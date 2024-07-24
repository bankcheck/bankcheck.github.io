# Microsoft Developer Studio Generated NMAKE File, Based on RetrySample.dsp
!IF "$(CFG)" == ""
CFG=RetrySample - Win32 Debug
!MESSAGE No configuration specified. Defaulting to RetrySample - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "RetrySample - Win32 Release" && "$(CFG)" != "RetrySample - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "RetrySample.mak" CFG="RetrySample - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "RetrySample - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "RetrySample - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "RetrySample - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\RetrySample.exe" "$(OUTDIR)\RetrySample.bsc"


CLEAN :
	-@erase "$(INTDIR)\dlgFaxClose.obj"
	-@erase "$(INTDIR)\dlgFaxClose.sbr"
	-@erase "$(INTDIR)\dlgFaxPortSetup.obj"
	-@erase "$(INTDIR)\dlgFaxPortSetup.sbr"
	-@erase "$(INTDIR)\dlgSendFax.obj"
	-@erase "$(INTDIR)\dlgSendFax.sbr"
	-@erase "$(INTDIR)\RetrySample.obj"
	-@erase "$(INTDIR)\RetrySample.pch"
	-@erase "$(INTDIR)\RetrySample.res"
	-@erase "$(INTDIR)\RetrySample.sbr"
	-@erase "$(INTDIR)\RetrySampleDlg.obj"
	-@erase "$(INTDIR)\RetrySampleDlg.sbr"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\StdAfx.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\RetrySample.bsc"
	-@erase "$(OUTDIR)\RetrySample.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\RetrySample.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\RetrySample.res" /d "NDEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\RetrySample.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\dlgFaxClose.sbr" \
	"$(INTDIR)\dlgFaxPortSetup.sbr" \
	"$(INTDIR)\dlgSendFax.sbr" \
	"$(INTDIR)\RetrySample.sbr" \
	"$(INTDIR)\RetrySampleDlg.sbr" \
	"$(INTDIR)\StdAfx.sbr"

"$(OUTDIR)\RetrySample.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=faxcpp32.lib bitiff.lib /nologo /subsystem:windows /incremental:no /pdb:"$(OUTDIR)\RetrySample.pdb" /machine:I386 /out:"$(OUTDIR)\RetrySample.exe" /libpath:"..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\dlgFaxClose.obj" \
	"$(INTDIR)\dlgFaxPortSetup.obj" \
	"$(INTDIR)\dlgSendFax.obj" \
	"$(INTDIR)\RetrySample.obj" \
	"$(INTDIR)\RetrySampleDlg.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\RetrySample.res"

"$(OUTDIR)\RetrySample.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "RetrySample - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\RetrySample.exe" "$(OUTDIR)\RetrySample.bsc"


CLEAN :
	-@erase "$(INTDIR)\dlgFaxClose.obj"
	-@erase "$(INTDIR)\dlgFaxClose.sbr"
	-@erase "$(INTDIR)\dlgFaxPortSetup.obj"
	-@erase "$(INTDIR)\dlgFaxPortSetup.sbr"
	-@erase "$(INTDIR)\dlgSendFax.obj"
	-@erase "$(INTDIR)\dlgSendFax.sbr"
	-@erase "$(INTDIR)\RetrySample.obj"
	-@erase "$(INTDIR)\RetrySample.pch"
	-@erase "$(INTDIR)\RetrySample.res"
	-@erase "$(INTDIR)\RetrySample.sbr"
	-@erase "$(INTDIR)\RetrySampleDlg.obj"
	-@erase "$(INTDIR)\RetrySampleDlg.sbr"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\StdAfx.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\RetrySample.bsc"
	-@erase "$(OUTDIR)\RetrySample.exe"
	-@erase "$(OUTDIR)\RetrySample.ilk"
	-@erase "$(OUTDIR)\RetrySample.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\RetrySample.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\RetrySample.res" /d "_DEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\RetrySample.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\dlgFaxClose.sbr" \
	"$(INTDIR)\dlgFaxPortSetup.sbr" \
	"$(INTDIR)\dlgSendFax.sbr" \
	"$(INTDIR)\RetrySample.sbr" \
	"$(INTDIR)\RetrySampleDlg.sbr" \
	"$(INTDIR)\StdAfx.sbr"

"$(OUTDIR)\RetrySample.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=faxcpp32.lib bitiff.lib /nologo /subsystem:windows /incremental:yes /pdb:"$(OUTDIR)\RetrySample.pdb" /debug /machine:I386 /out:"$(OUTDIR)\RetrySample.exe" /pdbtype:sept /libpath:"..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\dlgFaxClose.obj" \
	"$(INTDIR)\dlgFaxPortSetup.obj" \
	"$(INTDIR)\dlgSendFax.obj" \
	"$(INTDIR)\RetrySample.obj" \
	"$(INTDIR)\RetrySampleDlg.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\RetrySample.res"

"$(OUTDIR)\RetrySample.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("RetrySample.dep")
!INCLUDE "RetrySample.dep"
!ELSE 
!MESSAGE Warning: cannot find "RetrySample.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "RetrySample - Win32 Release" || "$(CFG)" == "RetrySample - Win32 Debug"
SOURCE=.\dlgFaxClose.cpp

"$(INTDIR)\dlgFaxClose.obj"	"$(INTDIR)\dlgFaxClose.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\RetrySample.pch"


SOURCE=.\dlgFaxPortSetup.cpp

"$(INTDIR)\dlgFaxPortSetup.obj"	"$(INTDIR)\dlgFaxPortSetup.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\RetrySample.pch"


SOURCE=.\dlgSendFax.cpp

"$(INTDIR)\dlgSendFax.obj"	"$(INTDIR)\dlgSendFax.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\RetrySample.pch"


SOURCE=.\RetrySample.cpp

"$(INTDIR)\RetrySample.obj"	"$(INTDIR)\RetrySample.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\RetrySample.pch"


SOURCE=.\RetrySample.rc

"$(INTDIR)\RetrySample.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)


SOURCE=.\RetrySampleDlg.cpp

"$(INTDIR)\RetrySampleDlg.obj"	"$(INTDIR)\RetrySampleDlg.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\RetrySample.pch"


SOURCE=.\StdAfx.cpp

!IF  "$(CFG)" == "RetrySample - Win32 Release"

CPP_SWITCHES=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\RetrySample.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\StdAfx.sbr"	"$(INTDIR)\RetrySample.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ELSEIF  "$(CFG)" == "RetrySample - Win32 Debug"

CPP_SWITCHES=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\RetrySample.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\StdAfx.sbr"	"$(INTDIR)\RetrySample.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ENDIF 


!ENDIF 

