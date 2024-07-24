# Microsoft Developer Studio Generated NMAKE File, Based on Test32.dsp
!IF "$(CFG)" == ""
CFG=Test32 - Win32 Debug
!MESSAGE No configuration specified. Defaulting to Test32 - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "Test32 - Win32 Release" && "$(CFG)" != "Test32 - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "Test32.mak" CFG="Test32 - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "Test32 - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "Test32 - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "Test32 - Win32 Release"

OUTDIR=.\WinRel
INTDIR=.\WinRel
# Begin Custom Macros
OutDir=.\WinRel
# End Custom Macros

ALL : "$(OUTDIR)\Test32.exe"


CLEAN :
	-@erase "$(INTDIR)\TEST.OBJ"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\Test32.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /Zp1 /MT /W3 /GX /Od /I "..\..\..\..\inc" /D "NDEBUG" /D "WIN32" /D "_WINDOWS" /D "_MBCS" /Fp"$(INTDIR)\Test32.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\Test32.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=user32.lib faxcpp32.lib /nologo /stack:0x10240 /subsystem:windows /incremental:no /pdb:"$(OUTDIR)\Test32.pdb" /machine:IX86 /def:".\TEST.DEF" /out:"$(OUTDIR)\Test32.exe" /libpath:"..\..\..\..\Lib" 
DEF_FILE= \
	".\TEST.DEF"
LINK32_OBJS= \
	"$(INTDIR)\TEST.OBJ"

"$(OUTDIR)\Test32.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "Test32 - Win32 Debug"

OUTDIR=.\WinDebug
INTDIR=.\WinDebug
# Begin Custom Macros
OutDir=.\WinDebug
# End Custom Macros

ALL : "$(OUTDIR)\Test32.exe" "$(OUTDIR)\Test32.bsc"


CLEAN :
	-@erase "$(INTDIR)\TEST.OBJ"
	-@erase "$(INTDIR)\TEST.SBR"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\Test32.bsc"
	-@erase "$(OUTDIR)\Test32.exe"
	-@erase "$(OUTDIR)\Test32.ilk"
	-@erase "$(OUTDIR)\Test32.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /Zp1 /MTd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /D "_DEBUG" /D "WIN32" /D "_WINDOWS" /D "_MBCS" /Fr"$(INTDIR)\\" /Fp"$(INTDIR)\Test32.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\Test32.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\TEST.SBR"

"$(OUTDIR)\Test32.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=oldnames.lib kernel32.lib user32.lib faxcpp32.lib /nologo /stack:0x10240 /subsystem:windows /incremental:yes /pdb:"$(OUTDIR)\Test32.pdb" /debug /machine:IX86 /def:".\TEST.DEF" /out:"$(OUTDIR)\Test32.exe" /libpath:"..\..\..\..\Lib" 
DEF_FILE= \
	".\TEST.DEF"
LINK32_OBJS= \
	"$(INTDIR)\TEST.OBJ"

"$(OUTDIR)\Test32.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

SOURCE="$(InputPath)"
DS_POSTBUILD_DEP=$(INTDIR)\postbld.dep

ALL : $(DS_POSTBUILD_DEP)

# Begin Custom Macros
OutDir=.\WinDebug
# End Custom Macros

$(DS_POSTBUILD_DEP) : "$(OUTDIR)\Test32.exe" "$(OUTDIR)\Test32.bsc"
   copy /b "WinDebug\Test32.exe" "D:\Program Files\Black Ice Software Inc\FaxDem32\Bin\Test32.exe"
	echo Helper for Post-build step > "$(DS_POSTBUILD_DEP)"

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("Test32.dep")
!INCLUDE "Test32.dep"
!ELSE 
!MESSAGE Warning: cannot find "Test32.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "Test32 - Win32 Release" || "$(CFG)" == "Test32 - Win32 Debug"
SOURCE=.\TEST.CPP

!IF  "$(CFG)" == "Test32 - Win32 Release"


"$(INTDIR)\TEST.OBJ" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "Test32 - Win32 Debug"


"$(INTDIR)\TEST.OBJ"	"$(INTDIR)\TEST.SBR" : $(SOURCE) "$(INTDIR)"


!ENDIF 


!ENDIF 

