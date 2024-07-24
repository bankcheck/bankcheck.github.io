# Microsoft Developer Studio Generated NMAKE File, Based on QueueFaxSample.dsp
!IF "$(CFG)" == ""
CFG=QueueFaxSample - Win32 Debug
!MESSAGE No configuration specified. Defaulting to QueueFaxSample - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "QueueFaxSample - Win32 Release" && "$(CFG)" != "QueueFaxSample - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "QueueFaxSample.mak" CFG="QueueFaxSample - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "QueueFaxSample - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "QueueFaxSample - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "QueueFaxSample - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\QueuePrioritySample.exe" "$(OUTDIR)\QueueFaxSample.bsc"


CLEAN :
	-@erase "$(INTDIR)\BOpen.obj"
	-@erase "$(INTDIR)\BOpen.sbr"
	-@erase "$(INTDIR)\DlgFaxClose.obj"
	-@erase "$(INTDIR)\DlgFaxClose.sbr"
	-@erase "$(INTDIR)\dlgFaxPortSetup.obj"
	-@erase "$(INTDIR)\dlgFaxPortSetup.sbr"
	-@erase "$(INTDIR)\DlgSendFax.obj"
	-@erase "$(INTDIR)\DlgSendFax.sbr"
	-@erase "$(INTDIR)\QueueFaxSample.obj"
	-@erase "$(INTDIR)\QueueFaxSample.pch"
	-@erase "$(INTDIR)\QueueFaxSample.res"
	-@erase "$(INTDIR)\QueueFaxSample.sbr"
	-@erase "$(INTDIR)\QueueFaxSampleDlg.obj"
	-@erase "$(INTDIR)\QueueFaxSampleDlg.sbr"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\StdAfx.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\QueueFaxSample.bsc"
	-@erase "$(OUTDIR)\QueuePrioritySample.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_THREAD" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\QueueFaxSample.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\QueueFaxSample.res" /d "NDEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\QueueFaxSample.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\BOpen.sbr" \
	"$(INTDIR)\DlgFaxClose.sbr" \
	"$(INTDIR)\dlgFaxPortSetup.sbr" \
	"$(INTDIR)\DlgSendFax.sbr" \
	"$(INTDIR)\QueueFaxSample.sbr" \
	"$(INTDIR)\QueueFaxSampleDlg.sbr" \
	"$(INTDIR)\StdAfx.sbr"

"$(OUTDIR)\QueueFaxSample.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=faxcpp32.lib bidib.lib bitiff.lib /nologo /subsystem:windows /incremental:no /pdb:"$(OUTDIR)\QueuePrioritySample.pdb" /machine:I386 /out:"$(OUTDIR)\QueuePrioritySample.exe" /libpath:"..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\BOpen.obj" \
	"$(INTDIR)\DlgFaxClose.obj" \
	"$(INTDIR)\dlgFaxPortSetup.obj" \
	"$(INTDIR)\DlgSendFax.obj" \
	"$(INTDIR)\QueueFaxSample.obj" \
	"$(INTDIR)\QueueFaxSampleDlg.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\QueueFaxSample.res"

"$(OUTDIR)\QueuePrioritySample.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "QueueFaxSample - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\QueuePrioritySample.exe" "$(OUTDIR)\QueueFaxSample.bsc"


CLEAN :
	-@erase "$(INTDIR)\BOpen.obj"
	-@erase "$(INTDIR)\BOpen.sbr"
	-@erase "$(INTDIR)\DlgFaxClose.obj"
	-@erase "$(INTDIR)\DlgFaxClose.sbr"
	-@erase "$(INTDIR)\dlgFaxPortSetup.obj"
	-@erase "$(INTDIR)\dlgFaxPortSetup.sbr"
	-@erase "$(INTDIR)\DlgSendFax.obj"
	-@erase "$(INTDIR)\DlgSendFax.sbr"
	-@erase "$(INTDIR)\QueueFaxSample.obj"
	-@erase "$(INTDIR)\QueueFaxSample.pch"
	-@erase "$(INTDIR)\QueueFaxSample.res"
	-@erase "$(INTDIR)\QueueFaxSample.sbr"
	-@erase "$(INTDIR)\QueueFaxSampleDlg.obj"
	-@erase "$(INTDIR)\QueueFaxSampleDlg.sbr"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\StdAfx.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\QueueFaxSample.bsc"
	-@erase "$(OUTDIR)\QueuePrioritySample.exe"
	-@erase "$(OUTDIR)\QueuePrioritySample.ilk"
	-@erase "$(OUTDIR)\QueuePrioritySample.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_THREAD" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\QueueFaxSample.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\QueueFaxSample.res" /d "_DEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\QueueFaxSample.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\BOpen.sbr" \
	"$(INTDIR)\DlgFaxClose.sbr" \
	"$(INTDIR)\dlgFaxPortSetup.sbr" \
	"$(INTDIR)\DlgSendFax.sbr" \
	"$(INTDIR)\QueueFaxSample.sbr" \
	"$(INTDIR)\QueueFaxSampleDlg.sbr" \
	"$(INTDIR)\StdAfx.sbr"

"$(OUTDIR)\QueueFaxSample.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=faxcpp32.lib bidib.lib bitiff.lib /nologo /subsystem:windows /incremental:yes /pdb:"$(OUTDIR)\QueuePrioritySample.pdb" /debug /machine:I386 /out:"$(OUTDIR)\QueuePrioritySample.exe" /pdbtype:sept /libpath:"..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\BOpen.obj" \
	"$(INTDIR)\DlgFaxClose.obj" \
	"$(INTDIR)\dlgFaxPortSetup.obj" \
	"$(INTDIR)\DlgSendFax.obj" \
	"$(INTDIR)\QueueFaxSample.obj" \
	"$(INTDIR)\QueueFaxSampleDlg.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\QueueFaxSample.res"

"$(OUTDIR)\QueuePrioritySample.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

SOURCE="$(InputPath)"
DS_POSTBUILD_DEP=$(INTDIR)\postbld.dep

ALL : $(DS_POSTBUILD_DEP)

# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

$(DS_POSTBUILD_DEP) : "$(OUTDIR)\QueuePrioritySample.exe" "$(OUTDIR)\QueueFaxSample.bsc"
   copy /b "Debug\QueuePrioritySample.exe" "D:\Program Files\Black Ice Software Inc\FaxDem32\Bin\QueuePrioritySample.exe"
	echo Helper for Post-build step > "$(DS_POSTBUILD_DEP)"

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("QueueFaxSample.dep")
!INCLUDE "QueueFaxSample.dep"
!ELSE 
!MESSAGE Warning: cannot find "QueueFaxSample.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "QueueFaxSample - Win32 Release" || "$(CFG)" == "QueueFaxSample - Win32 Debug"
SOURCE=.\BOpen.cpp

"$(INTDIR)\BOpen.obj"	"$(INTDIR)\BOpen.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\QueueFaxSample.pch"


SOURCE=.\DlgFaxClose.cpp

"$(INTDIR)\DlgFaxClose.obj"	"$(INTDIR)\DlgFaxClose.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\QueueFaxSample.pch"


SOURCE=.\dlgFaxPortSetup.cpp

"$(INTDIR)\dlgFaxPortSetup.obj"	"$(INTDIR)\dlgFaxPortSetup.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\QueueFaxSample.pch"


SOURCE=.\DlgSendFax.cpp

"$(INTDIR)\DlgSendFax.obj"	"$(INTDIR)\DlgSendFax.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\QueueFaxSample.pch"


SOURCE=.\QueueFaxSample.cpp

"$(INTDIR)\QueueFaxSample.obj"	"$(INTDIR)\QueueFaxSample.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\QueueFaxSample.pch"


SOURCE=.\QueueFaxSample.rc

"$(INTDIR)\QueueFaxSample.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)


SOURCE=.\QueueFaxSampleDlg.cpp

"$(INTDIR)\QueueFaxSampleDlg.obj"	"$(INTDIR)\QueueFaxSampleDlg.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\QueueFaxSample.pch"


SOURCE=.\StdAfx.cpp

!IF  "$(CFG)" == "QueueFaxSample - Win32 Release"

CPP_SWITCHES=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_THREAD" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\QueueFaxSample.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\StdAfx.sbr"	"$(INTDIR)\QueueFaxSample.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ELSEIF  "$(CFG)" == "QueueFaxSample - Win32 Debug"

CPP_SWITCHES=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_THREAD" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\QueueFaxSample.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\StdAfx.sbr"	"$(INTDIR)\QueueFaxSample.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ENDIF 


!ENDIF 

