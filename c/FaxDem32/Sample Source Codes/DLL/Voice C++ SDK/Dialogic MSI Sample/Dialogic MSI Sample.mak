# Microsoft Developer Studio Generated NMAKE File, Based on Dialogic MSI Sample.dsp
!IF "$(CFG)" == ""
CFG=Dialogic MSI Sample - Win32 Debug
!MESSAGE No configuration specified. Defaulting to Dialogic MSI Sample - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "Dialogic MSI Sample - Win32 Release" && "$(CFG)" != "Dialogic MSI Sample - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "Dialogic MSI Sample.mak" CFG="Dialogic MSI Sample - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "Dialogic MSI Sample - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "Dialogic MSI Sample - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "Dialogic MSI Sample - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\Dialogic MSI Sample.exe"


CLEAN :
	-@erase "$(INTDIR)\Dialogic MSI Sample.obj"
	-@erase "$(INTDIR)\Dialogic MSI Sample.pch"
	-@erase "$(INTDIR)\Dialogic MSI Sample.res"
	-@erase "$(INTDIR)\Dialogic MSI SampleDlg.obj"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\Dialogic MSI Sample.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)\Dialogic MSI Sample.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\Dialogic MSI Sample.res" /d "NDEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\Dialogic MSI Sample.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=voice.lib faxcpp32.lib /nologo /subsystem:windows /incremental:no /pdb:"$(OUTDIR)\Dialogic MSI Sample.pdb" /machine:I386 /out:"$(OUTDIR)\Dialogic MSI Sample.exe" /libpath:"..\..\..\..\lib" 
LINK32_OBJS= \
	"$(INTDIR)\Dialogic MSI Sample.obj" \
	"$(INTDIR)\Dialogic MSI SampleDlg.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\Dialogic MSI Sample.res"

"$(OUTDIR)\Dialogic MSI Sample.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "Dialogic MSI Sample - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\Dialogic MSI Sample.exe" "$(OUTDIR)\Dialogic MSI Sample.bsc"


CLEAN :
	-@erase "$(INTDIR)\Dialogic MSI Sample.obj"
	-@erase "$(INTDIR)\Dialogic MSI Sample.pch"
	-@erase "$(INTDIR)\Dialogic MSI Sample.res"
	-@erase "$(INTDIR)\Dialogic MSI Sample.sbr"
	-@erase "$(INTDIR)\Dialogic MSI SampleDlg.obj"
	-@erase "$(INTDIR)\Dialogic MSI SampleDlg.sbr"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\StdAfx.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\Dialogic MSI Sample.bsc"
	-@erase "$(OUTDIR)\Dialogic MSI Sample.exe"
	-@erase "$(OUTDIR)\Dialogic MSI Sample.ilk"
	-@erase "$(OUTDIR)\Dialogic MSI Sample.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\Dialogic MSI Sample.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\Dialogic MSI Sample.res" /d "_DEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\Dialogic MSI Sample.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\Dialogic MSI Sample.sbr" \
	"$(INTDIR)\Dialogic MSI SampleDlg.sbr" \
	"$(INTDIR)\StdAfx.sbr"

"$(OUTDIR)\Dialogic MSI Sample.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=voice.lib faxcpp32.lib /nologo /subsystem:windows /incremental:yes /pdb:"$(OUTDIR)\Dialogic MSI Sample.pdb" /debug /machine:I386 /out:"$(OUTDIR)\Dialogic MSI Sample.exe" /pdbtype:sept /libpath:"..\..\..\..\lib" 
LINK32_OBJS= \
	"$(INTDIR)\Dialogic MSI Sample.obj" \
	"$(INTDIR)\Dialogic MSI SampleDlg.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\Dialogic MSI Sample.res"

"$(OUTDIR)\Dialogic MSI Sample.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("Dialogic MSI Sample.dep")
!INCLUDE "Dialogic MSI Sample.dep"
!ELSE 
!MESSAGE Warning: cannot find "Dialogic MSI Sample.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "Dialogic MSI Sample - Win32 Release" || "$(CFG)" == "Dialogic MSI Sample - Win32 Debug"
SOURCE=".\Dialogic MSI Sample.cpp"

!IF  "$(CFG)" == "Dialogic MSI Sample - Win32 Release"


"$(INTDIR)\Dialogic MSI Sample.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\Dialogic MSI Sample.pch"


!ELSEIF  "$(CFG)" == "Dialogic MSI Sample - Win32 Debug"


"$(INTDIR)\Dialogic MSI Sample.obj"	"$(INTDIR)\Dialogic MSI Sample.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\Dialogic MSI Sample.pch"


!ENDIF 

SOURCE=".\Dialogic MSI Sample.rc"

"$(INTDIR)\Dialogic MSI Sample.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)


SOURCE=".\Dialogic MSI SampleDlg.cpp"

!IF  "$(CFG)" == "Dialogic MSI Sample - Win32 Release"


"$(INTDIR)\Dialogic MSI SampleDlg.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\Dialogic MSI Sample.pch"


!ELSEIF  "$(CFG)" == "Dialogic MSI Sample - Win32 Debug"


"$(INTDIR)\Dialogic MSI SampleDlg.obj"	"$(INTDIR)\Dialogic MSI SampleDlg.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\Dialogic MSI Sample.pch"


!ENDIF 

SOURCE=.\StdAfx.cpp

!IF  "$(CFG)" == "Dialogic MSI Sample - Win32 Release"

CPP_SWITCHES=/nologo /MD /W3 /GX /O2 /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Fp"$(INTDIR)\Dialogic MSI Sample.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\Dialogic MSI Sample.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ELSEIF  "$(CFG)" == "Dialogic MSI Sample - Win32 Debug"

CPP_SWITCHES=/nologo /MDd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\Dialogic MSI Sample.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\StdAfx.sbr"	"$(INTDIR)\Dialogic MSI Sample.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ENDIF 


!ENDIF 

