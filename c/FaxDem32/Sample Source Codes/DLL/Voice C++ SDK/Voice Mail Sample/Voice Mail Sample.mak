# Microsoft Developer Studio Generated NMAKE File, Based on Voice Mail Sample.dsp
!IF "$(CFG)" == ""
CFG=Voice Mail Sample - Win32 Debug
!MESSAGE No configuration specified. Defaulting to Voice Mail Sample - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "Voice Mail Sample - Win32 Release" && "$(CFG)" != "Voice Mail Sample - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "Voice Mail Sample.mak" CFG="Voice Mail Sample - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "Voice Mail Sample - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "Voice Mail Sample - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "Voice Mail Sample - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\Voice Mail Sample.exe" "$(OUTDIR)\Voice Mail Sample.pch"


CLEAN :
	-@erase "$(INTDIR)\BrookOpen.obj"
	-@erase "$(INTDIR)\ChildFrm.obj"
	-@erase "$(INTDIR)\DialogicOpen.obj"
	-@erase "$(INTDIR)\DIBPAL.OBJ"
	-@erase "$(INTDIR)\DlgAutoAnswerCfg.obj"
	-@erase "$(INTDIR)\DLGHELP.OBJ"
	-@erase "$(INTDIR)\FaxDoc.obj"
	-@erase "$(INTDIR)\FaxDocvw.obj"
	-@erase "$(INTDIR)\HOLMES.OBJ"
	-@erase "$(INTDIR)\MainFrm.obj"
	-@erase "$(INTDIR)\NMSOPEN.OBJ"
	-@erase "$(INTDIR)\OpenComPort.obj"
	-@erase "$(INTDIR)\SPLASH.OBJ"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\Voice Mail Sample.obj"
	-@erase "$(INTDIR)\Voice Mail Sample.pch"
	-@erase "$(INTDIR)\Voice Mail Sample.res"
	-@erase "$(INTDIR)\Voice Mail SampleDoc.obj"
	-@erase "$(INTDIR)\Voice Mail SampleView.obj"
	-@erase "$(OUTDIR)\Voice Mail Sample.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /Zp1 /MD /W3 /GX /Od /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /Fp"$(INTDIR)\Voice Mail Sample.pch" /YX"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
MTL_PROJ=/nologo /D "NDEBUG" /mktyplib203 /o /win32 "NUL" 
RSC=rc.exe
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\Voice Mail Sample.res" /d "NDEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\Voice Mail Sample.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=faxcpp32.lib voice.lib codec.lib bitiff.lib bidib.lib bidisp.lib /nologo /subsystem:windows /incremental:no /pdb:"$(OUTDIR)\Voice Mail Sample.pdb" /machine:I386 /out:"$(OUTDIR)\Voice Mail Sample.exe" /libpath:"..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\BrookOpen.obj" \
	"$(INTDIR)\ChildFrm.obj" \
	"$(INTDIR)\DialogicOpen.obj" \
	"$(INTDIR)\DIBPAL.OBJ" \
	"$(INTDIR)\DlgAutoAnswerCfg.obj" \
	"$(INTDIR)\DLGHELP.OBJ" \
	"$(INTDIR)\FaxDoc.obj" \
	"$(INTDIR)\FaxDocvw.obj" \
	"$(INTDIR)\HOLMES.OBJ" \
	"$(INTDIR)\MainFrm.obj" \
	"$(INTDIR)\NMSOPEN.OBJ" \
	"$(INTDIR)\OpenComPort.obj" \
	"$(INTDIR)\SPLASH.OBJ" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\Voice Mail Sample.obj" \
	"$(INTDIR)\Voice Mail SampleDoc.obj" \
	"$(INTDIR)\Voice Mail SampleView.obj" \
	"$(INTDIR)\Voice Mail Sample.res"

"$(OUTDIR)\Voice Mail Sample.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "Voice Mail Sample - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\Voice Mail Sample.exe" "$(OUTDIR)\Voice Mail Sample.pch" "$(OUTDIR)\Voice Mail Sample.bsc"


CLEAN :
	-@erase "$(INTDIR)\BrookOpen.obj"
	-@erase "$(INTDIR)\BrookOpen.sbr"
	-@erase "$(INTDIR)\ChildFrm.obj"
	-@erase "$(INTDIR)\ChildFrm.sbr"
	-@erase "$(INTDIR)\DialogicOpen.obj"
	-@erase "$(INTDIR)\DialogicOpen.sbr"
	-@erase "$(INTDIR)\DIBPAL.OBJ"
	-@erase "$(INTDIR)\DIBPAL.SBR"
	-@erase "$(INTDIR)\DlgAutoAnswerCfg.obj"
	-@erase "$(INTDIR)\DlgAutoAnswerCfg.sbr"
	-@erase "$(INTDIR)\DLGHELP.OBJ"
	-@erase "$(INTDIR)\DLGHELP.SBR"
	-@erase "$(INTDIR)\FaxDoc.obj"
	-@erase "$(INTDIR)\FaxDoc.sbr"
	-@erase "$(INTDIR)\FaxDocvw.obj"
	-@erase "$(INTDIR)\FaxDocvw.sbr"
	-@erase "$(INTDIR)\HOLMES.OBJ"
	-@erase "$(INTDIR)\HOLMES.SBR"
	-@erase "$(INTDIR)\MainFrm.obj"
	-@erase "$(INTDIR)\MainFrm.sbr"
	-@erase "$(INTDIR)\NMSOPEN.OBJ"
	-@erase "$(INTDIR)\NMSOPEN.SBR"
	-@erase "$(INTDIR)\OpenComPort.obj"
	-@erase "$(INTDIR)\OpenComPort.sbr"
	-@erase "$(INTDIR)\SPLASH.OBJ"
	-@erase "$(INTDIR)\SPLASH.SBR"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\StdAfx.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(INTDIR)\Voice Mail Sample.obj"
	-@erase "$(INTDIR)\Voice Mail Sample.pch"
	-@erase "$(INTDIR)\Voice Mail Sample.res"
	-@erase "$(INTDIR)\Voice Mail Sample.sbr"
	-@erase "$(INTDIR)\Voice Mail SampleDoc.obj"
	-@erase "$(INTDIR)\Voice Mail SampleDoc.sbr"
	-@erase "$(INTDIR)\Voice Mail SampleView.obj"
	-@erase "$(INTDIR)\Voice Mail SampleView.sbr"
	-@erase "$(OUTDIR)\Voice Mail Sample.bsc"
	-@erase "$(OUTDIR)\Voice Mail Sample.exe"
	-@erase "$(OUTDIR)\Voice Mail Sample.ilk"
	-@erase "$(OUTDIR)\Voice Mail Sample.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /Zp1 /MDd /W3 /Gi /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\Voice Mail Sample.pch" /YX"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
MTL_PROJ=/nologo /D "_DEBUG" /mktyplib203 /o /win32 "NUL" 
RSC=rc.exe
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\Voice Mail Sample.res" /d "_DEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\Voice Mail Sample.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\BrookOpen.sbr" \
	"$(INTDIR)\ChildFrm.sbr" \
	"$(INTDIR)\DialogicOpen.sbr" \
	"$(INTDIR)\DIBPAL.SBR" \
	"$(INTDIR)\DlgAutoAnswerCfg.sbr" \
	"$(INTDIR)\DLGHELP.SBR" \
	"$(INTDIR)\FaxDoc.sbr" \
	"$(INTDIR)\FaxDocvw.sbr" \
	"$(INTDIR)\HOLMES.SBR" \
	"$(INTDIR)\MainFrm.sbr" \
	"$(INTDIR)\NMSOPEN.SBR" \
	"$(INTDIR)\OpenComPort.sbr" \
	"$(INTDIR)\SPLASH.SBR" \
	"$(INTDIR)\StdAfx.sbr" \
	"$(INTDIR)\Voice Mail Sample.sbr" \
	"$(INTDIR)\Voice Mail SampleDoc.sbr" \
	"$(INTDIR)\Voice Mail SampleView.sbr"

"$(OUTDIR)\Voice Mail Sample.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=faxcpp32.lib voice.lib codec.lib bidib.lib bidisp.lib bitiff.lib /nologo /subsystem:windows /incremental:yes /pdb:"$(OUTDIR)\Voice Mail Sample.pdb" /debug /machine:I386 /out:"$(OUTDIR)\Voice Mail Sample.exe" /pdbtype:sept /libpath:"..\..\..\..\Lib" 
LINK32_OBJS= \
	"$(INTDIR)\BrookOpen.obj" \
	"$(INTDIR)\ChildFrm.obj" \
	"$(INTDIR)\DialogicOpen.obj" \
	"$(INTDIR)\DIBPAL.OBJ" \
	"$(INTDIR)\DlgAutoAnswerCfg.obj" \
	"$(INTDIR)\DLGHELP.OBJ" \
	"$(INTDIR)\FaxDoc.obj" \
	"$(INTDIR)\FaxDocvw.obj" \
	"$(INTDIR)\HOLMES.OBJ" \
	"$(INTDIR)\MainFrm.obj" \
	"$(INTDIR)\NMSOPEN.OBJ" \
	"$(INTDIR)\OpenComPort.obj" \
	"$(INTDIR)\SPLASH.OBJ" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\Voice Mail Sample.obj" \
	"$(INTDIR)\Voice Mail SampleDoc.obj" \
	"$(INTDIR)\Voice Mail SampleView.obj" \
	"$(INTDIR)\Voice Mail Sample.res"

"$(OUTDIR)\Voice Mail Sample.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

SOURCE="$(InputPath)"
DS_POSTBUILD_DEP=$(INTDIR)\postbld.dep

ALL : $(DS_POSTBUILD_DEP)

# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

$(DS_POSTBUILD_DEP) : "$(OUTDIR)\Voice Mail Sample.exe" "$(OUTDIR)\Voice Mail Sample.pch" "$(OUTDIR)\Voice Mail Sample.bsc"
   copy /b "Debug\Voice Mail Sample.exe" "D:\Program Files\Black Ice Software Inc\FaxDem32\Bin\Voice Mail Sample.exe"
	echo Helper for Post-build step > "$(DS_POSTBUILD_DEP)"

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("Voice Mail Sample.dep")
!INCLUDE "Voice Mail Sample.dep"
!ELSE 
!MESSAGE Warning: cannot find "Voice Mail Sample.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "Voice Mail Sample - Win32 Release" || "$(CFG)" == "Voice Mail Sample - Win32 Debug"
SOURCE=.\BrookOpen.cpp

!IF  "$(CFG)" == "Voice Mail Sample - Win32 Release"


"$(INTDIR)\BrookOpen.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "Voice Mail Sample - Win32 Debug"


"$(INTDIR)\BrookOpen.obj"	"$(INTDIR)\BrookOpen.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\ChildFrm.cpp

!IF  "$(CFG)" == "Voice Mail Sample - Win32 Release"


"$(INTDIR)\ChildFrm.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "Voice Mail Sample - Win32 Debug"


"$(INTDIR)\ChildFrm.obj"	"$(INTDIR)\ChildFrm.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\DialogicOpen.cpp

!IF  "$(CFG)" == "Voice Mail Sample - Win32 Release"


"$(INTDIR)\DialogicOpen.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "Voice Mail Sample - Win32 Debug"


"$(INTDIR)\DialogicOpen.obj"	"$(INTDIR)\DialogicOpen.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\DIBPAL.CPP

!IF  "$(CFG)" == "Voice Mail Sample - Win32 Release"


"$(INTDIR)\DIBPAL.OBJ" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "Voice Mail Sample - Win32 Debug"


"$(INTDIR)\DIBPAL.OBJ"	"$(INTDIR)\DIBPAL.SBR" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\DlgAutoAnswerCfg.CPP

!IF  "$(CFG)" == "Voice Mail Sample - Win32 Release"


"$(INTDIR)\DlgAutoAnswerCfg.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "Voice Mail Sample - Win32 Debug"


"$(INTDIR)\DlgAutoAnswerCfg.obj"	"$(INTDIR)\DlgAutoAnswerCfg.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\DLGHELP.CPP

!IF  "$(CFG)" == "Voice Mail Sample - Win32 Release"


"$(INTDIR)\DLGHELP.OBJ" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "Voice Mail Sample - Win32 Debug"


"$(INTDIR)\DLGHELP.OBJ"	"$(INTDIR)\DLGHELP.SBR" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\FaxDoc.cpp

!IF  "$(CFG)" == "Voice Mail Sample - Win32 Release"


"$(INTDIR)\FaxDoc.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "Voice Mail Sample - Win32 Debug"


"$(INTDIR)\FaxDoc.obj"	"$(INTDIR)\FaxDoc.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\FaxDocvw.cpp

!IF  "$(CFG)" == "Voice Mail Sample - Win32 Release"


"$(INTDIR)\FaxDocvw.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "Voice Mail Sample - Win32 Debug"


"$(INTDIR)\FaxDocvw.obj"	"$(INTDIR)\FaxDocvw.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\HOLMES.CPP

!IF  "$(CFG)" == "Voice Mail Sample - Win32 Release"


"$(INTDIR)\HOLMES.OBJ" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "Voice Mail Sample - Win32 Debug"


"$(INTDIR)\HOLMES.OBJ"	"$(INTDIR)\HOLMES.SBR" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\MainFrm.cpp

!IF  "$(CFG)" == "Voice Mail Sample - Win32 Release"


"$(INTDIR)\MainFrm.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "Voice Mail Sample - Win32 Debug"


"$(INTDIR)\MainFrm.obj"	"$(INTDIR)\MainFrm.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\NMSOPEN.CPP

!IF  "$(CFG)" == "Voice Mail Sample - Win32 Release"


"$(INTDIR)\NMSOPEN.OBJ" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "Voice Mail Sample - Win32 Debug"


"$(INTDIR)\NMSOPEN.OBJ"	"$(INTDIR)\NMSOPEN.SBR" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\OpenComPort.cpp

!IF  "$(CFG)" == "Voice Mail Sample - Win32 Release"


"$(INTDIR)\OpenComPort.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "Voice Mail Sample - Win32 Debug"


"$(INTDIR)\OpenComPort.obj"	"$(INTDIR)\OpenComPort.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\SPLASH.CPP

!IF  "$(CFG)" == "Voice Mail Sample - Win32 Release"


"$(INTDIR)\SPLASH.OBJ" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "Voice Mail Sample - Win32 Debug"


"$(INTDIR)\SPLASH.OBJ"	"$(INTDIR)\SPLASH.SBR" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\StdAfx.cpp

!IF  "$(CFG)" == "Voice Mail Sample - Win32 Release"

CPP_SWITCHES=/nologo /Zp1 /MD /W3 /GX /Od /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /Fp"$(INTDIR)\Voice Mail Sample.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\Voice Mail Sample.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ELSEIF  "$(CFG)" == "Voice Mail Sample - Win32 Debug"

CPP_SWITCHES=/nologo /Zp1 /MDd /W3 /Gi /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\Voice Mail Sample.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\StdAfx.sbr"	"$(INTDIR)\Voice Mail Sample.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ENDIF 

SOURCE=".\Voice Mail Sample.cpp"

!IF  "$(CFG)" == "Voice Mail Sample - Win32 Release"


"$(INTDIR)\Voice Mail Sample.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "Voice Mail Sample - Win32 Debug"


"$(INTDIR)\Voice Mail Sample.obj"	"$(INTDIR)\Voice Mail Sample.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=".\Voice Mail Sample.rc"

"$(INTDIR)\Voice Mail Sample.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)


SOURCE=".\Voice Mail SampleDoc.cpp"

!IF  "$(CFG)" == "Voice Mail Sample - Win32 Release"


"$(INTDIR)\Voice Mail SampleDoc.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "Voice Mail Sample - Win32 Debug"


"$(INTDIR)\Voice Mail SampleDoc.obj"	"$(INTDIR)\Voice Mail SampleDoc.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=".\Voice Mail SampleView.cpp"

!IF  "$(CFG)" == "Voice Mail Sample - Win32 Release"


"$(INTDIR)\Voice Mail SampleView.obj" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "Voice Mail Sample - Win32 Debug"


"$(INTDIR)\Voice Mail SampleView.obj"	"$(INTDIR)\Voice Mail SampleView.sbr" : $(SOURCE) "$(INTDIR)"


!ENDIF 


!ENDIF 

