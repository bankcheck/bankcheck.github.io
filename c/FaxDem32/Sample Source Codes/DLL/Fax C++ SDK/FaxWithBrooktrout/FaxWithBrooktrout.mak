# Microsoft Developer Studio Generated NMAKE File, Based on FaxWithBrooktrout.dsp
!IF "$(CFG)" == ""
CFG=FaxWithBrooktrout - Win32 Debug
!MESSAGE No configuration specified. Defaulting to FaxWithBrooktrout - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "FaxWithBrooktrout - Win32 Release" && "$(CFG)" != "FaxWithBrooktrout - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "FaxWithBrooktrout.mak" CFG="FaxWithBrooktrout - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "FaxWithBrooktrout - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "FaxWithBrooktrout - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "FaxWithBrooktrout - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\FaxWithBrooktrout.exe" "$(OUTDIR)\FaxWithBrooktrout.bsc"


CLEAN :
	-@erase "$(INTDIR)\BOpen.obj"
	-@erase "$(INTDIR)\BOpen.sbr"
	-@erase "$(INTDIR)\DlgFaxClose.obj"
	-@erase "$(INTDIR)\DlgFaxClose.sbr"
	-@erase "$(INTDIR)\dlgSendFax.obj"
	-@erase "$(INTDIR)\dlgSendFax.sbr"
	-@erase "$(INTDIR)\FaxWithBrooktrout.obj"
	-@erase "$(INTDIR)\FaxWithBrooktrout.pch"
	-@erase "$(INTDIR)\FaxWithBrooktrout.res"
	-@erase "$(INTDIR)\FaxWithBrooktrout.sbr"
	-@erase "$(INTDIR)\FaxWithBrooktroutDlg.obj"
	-@erase "$(INTDIR)\FaxWithBrooktroutDlg.sbr"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\StdAfx.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\FaxWithBrooktrout.bsc"
	-@erase "$(OUTDIR)\FaxWithBrooktrout.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /Zp1 /MD /W3 /GX /O2 /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\FaxWithBrooktrout.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\FaxWithBrooktrout.res" /d "NDEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\FaxWithBrooktrout.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\BOpen.sbr" \
	"$(INTDIR)\DlgFaxClose.sbr" \
	"$(INTDIR)\dlgSendFax.sbr" \
	"$(INTDIR)\FaxWithBrooktrout.sbr" \
	"$(INTDIR)\FaxWithBrooktroutDlg.sbr" \
	"$(INTDIR)\StdAfx.sbr"

"$(OUTDIR)\FaxWithBrooktrout.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=faxcpp32.lib bitiff.lib /nologo /subsystem:windows /incremental:no /pdb:"$(OUTDIR)\FaxWithBrooktrout.pdb" /machine:I386 /out:"$(OUTDIR)\FaxWithBrooktrout.exe" /libpath:"..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\BOpen.obj" \
	"$(INTDIR)\DlgFaxClose.obj" \
	"$(INTDIR)\dlgSendFax.obj" \
	"$(INTDIR)\FaxWithBrooktrout.obj" \
	"$(INTDIR)\FaxWithBrooktroutDlg.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\FaxWithBrooktrout.res"

"$(OUTDIR)\FaxWithBrooktrout.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "FaxWithBrooktrout - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\FaxWithBrooktrout.exe" "$(OUTDIR)\FaxWithBrooktrout.bsc"


CLEAN :
	-@erase "$(INTDIR)\BOpen.obj"
	-@erase "$(INTDIR)\BOpen.sbr"
	-@erase "$(INTDIR)\DlgFaxClose.obj"
	-@erase "$(INTDIR)\DlgFaxClose.sbr"
	-@erase "$(INTDIR)\dlgSendFax.obj"
	-@erase "$(INTDIR)\dlgSendFax.sbr"
	-@erase "$(INTDIR)\FaxWithBrooktrout.obj"
	-@erase "$(INTDIR)\FaxWithBrooktrout.pch"
	-@erase "$(INTDIR)\FaxWithBrooktrout.res"
	-@erase "$(INTDIR)\FaxWithBrooktrout.sbr"
	-@erase "$(INTDIR)\FaxWithBrooktroutDlg.obj"
	-@erase "$(INTDIR)\FaxWithBrooktroutDlg.sbr"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\StdAfx.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\FaxWithBrooktrout.bsc"
	-@erase "$(OUTDIR)\FaxWithBrooktrout.exe"
	-@erase "$(OUTDIR)\FaxWithBrooktrout.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\FaxWithBrooktrout.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\FaxWithBrooktrout.res" /d "_DEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\FaxWithBrooktrout.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\BOpen.sbr" \
	"$(INTDIR)\DlgFaxClose.sbr" \
	"$(INTDIR)\dlgSendFax.sbr" \
	"$(INTDIR)\FaxWithBrooktrout.sbr" \
	"$(INTDIR)\FaxWithBrooktroutDlg.sbr" \
	"$(INTDIR)\StdAfx.sbr"

"$(OUTDIR)\FaxWithBrooktrout.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=faxcpp32.lib bitiff.lib /nologo /subsystem:windows /incremental:no /pdb:"$(OUTDIR)\FaxWithBrooktrout.pdb" /debug /machine:I386 /out:"$(OUTDIR)\FaxWithBrooktrout.exe" /pdbtype:sept /libpath:"..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\BOpen.obj" \
	"$(INTDIR)\DlgFaxClose.obj" \
	"$(INTDIR)\dlgSendFax.obj" \
	"$(INTDIR)\FaxWithBrooktrout.obj" \
	"$(INTDIR)\FaxWithBrooktroutDlg.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\FaxWithBrooktrout.res"

"$(OUTDIR)\FaxWithBrooktrout.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

SOURCE="$(InputPath)"
DS_POSTBUILD_DEP=$(INTDIR)\postbld.dep

ALL : $(DS_POSTBUILD_DEP)

# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

$(DS_POSTBUILD_DEP) : "$(OUTDIR)\FaxWithBrooktrout.exe" "$(OUTDIR)\FaxWithBrooktrout.bsc"
   copy /b "Debug\FaxWithBrooktrout.exe" "D:\Program Files\Black Ice Software Inc\FaxDem32\Bin\FaxWithBrooktrout.exe"
	echo Helper for Post-build step > "$(DS_POSTBUILD_DEP)"

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("FaxWithBrooktrout.dep")
!INCLUDE "FaxWithBrooktrout.dep"
!ELSE 
!MESSAGE Warning: cannot find "FaxWithBrooktrout.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "FaxWithBrooktrout - Win32 Release" || "$(CFG)" == "FaxWithBrooktrout - Win32 Debug"
SOURCE=.\BOpen.cpp

"$(INTDIR)\BOpen.obj"	"$(INTDIR)\BOpen.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\FaxWithBrooktrout.pch"


SOURCE=.\DlgFaxClose.cpp

"$(INTDIR)\DlgFaxClose.obj"	"$(INTDIR)\DlgFaxClose.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\FaxWithBrooktrout.pch"


SOURCE=.\dlgSendFax.cpp

"$(INTDIR)\dlgSendFax.obj"	"$(INTDIR)\dlgSendFax.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\FaxWithBrooktrout.pch"


SOURCE=.\FaxWithBrooktrout.cpp

"$(INTDIR)\FaxWithBrooktrout.obj"	"$(INTDIR)\FaxWithBrooktrout.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\FaxWithBrooktrout.pch"


SOURCE=.\FaxWithBrooktrout.rc

"$(INTDIR)\FaxWithBrooktrout.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)


SOURCE=.\FaxWithBrooktroutDlg.cpp

"$(INTDIR)\FaxWithBrooktroutDlg.obj"	"$(INTDIR)\FaxWithBrooktroutDlg.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\FaxWithBrooktrout.pch"


SOURCE=.\StdAfx.cpp

!IF  "$(CFG)" == "FaxWithBrooktrout - Win32 Release"

CPP_SWITCHES=/nologo /Zp1 /MD /W3 /GX /O2 /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\FaxWithBrooktrout.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\StdAfx.sbr"	"$(INTDIR)\FaxWithBrooktrout.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ELSEIF  "$(CFG)" == "FaxWithBrooktrout - Win32 Debug"

CPP_SWITCHES=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\FaxWithBrooktrout.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\StdAfx.sbr"	"$(INTDIR)\FaxWithBrooktrout.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ENDIF 


!ENDIF 

