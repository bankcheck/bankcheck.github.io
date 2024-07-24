# Microsoft Developer Studio Generated NMAKE File, Based on OpenComPorts.dsp
!IF "$(CFG)" == ""
CFG=OpenComPorts - Win32 Debug
!MESSAGE No configuration specified. Defaulting to OpenComPorts - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "OpenComPorts - Win32 Release" && "$(CFG)" != "OpenComPorts - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "OpenComPorts.mak" CFG="OpenComPorts - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "OpenComPorts - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "OpenComPorts - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "OpenComPorts - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\OpenComPorts.exe"


CLEAN :
	-@erase "$(INTDIR)\DlgFaxClose.obj"
	-@erase "$(INTDIR)\dlgFaxPortSetup.obj"
	-@erase "$(INTDIR)\OpenComPorts.obj"
	-@erase "$(INTDIR)\OpenComPorts.pch"
	-@erase "$(INTDIR)\OpenComPorts.res"
	-@erase "$(INTDIR)\OpenComPortsDlg.obj"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\OpenComPorts.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)\OpenComPorts.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\OpenComPorts.res" /d "NDEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\OpenComPorts.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=faxcpp32.lib /nologo /subsystem:windows /incremental:no /pdb:"$(OUTDIR)\OpenComPorts.pdb" /machine:I386 /out:"$(OUTDIR)\OpenComPorts.exe" /libpath:"..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\DlgFaxClose.obj" \
	"$(INTDIR)\dlgFaxPortSetup.obj" \
	"$(INTDIR)\OpenComPorts.obj" \
	"$(INTDIR)\OpenComPortsDlg.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\OpenComPorts.res"

"$(OUTDIR)\OpenComPorts.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "OpenComPorts - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\OpenComPorts.exe"


CLEAN :
	-@erase "$(INTDIR)\DlgFaxClose.obj"
	-@erase "$(INTDIR)\dlgFaxPortSetup.obj"
	-@erase "$(INTDIR)\OpenComPorts.obj"
	-@erase "$(INTDIR)\OpenComPorts.pch"
	-@erase "$(INTDIR)\OpenComPorts.res"
	-@erase "$(INTDIR)\OpenComPortsDlg.obj"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\OpenComPorts.exe"
	-@erase "$(OUTDIR)\OpenComPorts.ilk"
	-@erase "$(OUTDIR)\OpenComPorts.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)\OpenComPorts.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\OpenComPorts.res" /d "_DEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\OpenComPorts.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=faxcpp32.lib /nologo /subsystem:windows /incremental:yes /pdb:"$(OUTDIR)\OpenComPorts.pdb" /debug /machine:I386 /out:"$(OUTDIR)\OpenComPorts.exe" /pdbtype:sept /libpath:"..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\DlgFaxClose.obj" \
	"$(INTDIR)\dlgFaxPortSetup.obj" \
	"$(INTDIR)\OpenComPorts.obj" \
	"$(INTDIR)\OpenComPortsDlg.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\OpenComPorts.res"

"$(OUTDIR)\OpenComPorts.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

SOURCE="$(InputPath)"
DS_POSTBUILD_DEP=$(INTDIR)\postbld.dep

ALL : $(DS_POSTBUILD_DEP)

# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

$(DS_POSTBUILD_DEP) : "$(OUTDIR)\OpenComPorts.exe"
   copy /b "Debug\OpenComPorts.exe" "D:\Program Files\Black Ice Software Inc\FaxDem32\Bin\OpenComPorts.exe"
	echo Helper for Post-build step > "$(DS_POSTBUILD_DEP)"

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("OpenComPorts.dep")
!INCLUDE "OpenComPorts.dep"
!ELSE 
!MESSAGE Warning: cannot find "OpenComPorts.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "OpenComPorts - Win32 Release" || "$(CFG)" == "OpenComPorts - Win32 Debug"
SOURCE=.\DlgFaxClose.cpp

"$(INTDIR)\DlgFaxClose.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\OpenComPorts.pch"


SOURCE=.\dlgFaxPortSetup.cpp

"$(INTDIR)\dlgFaxPortSetup.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\OpenComPorts.pch"


SOURCE=.\OpenComPorts.cpp

"$(INTDIR)\OpenComPorts.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\OpenComPorts.pch"


SOURCE=.\OpenComPorts.rc

"$(INTDIR)\OpenComPorts.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)


SOURCE=.\OpenComPortsDlg.cpp

"$(INTDIR)\OpenComPortsDlg.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\OpenComPorts.pch"


SOURCE=.\StdAfx.cpp

!IF  "$(CFG)" == "OpenComPorts - Win32 Release"

CPP_SWITCHES=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)\OpenComPorts.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\OpenComPorts.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ELSEIF  "$(CFG)" == "OpenComPorts - Win32 Debug"

CPP_SWITCHES=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)\OpenComPorts.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\OpenComPorts.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ENDIF 


!ENDIF 

