# Microsoft Developer Studio Generated NMAKE File, Based on Fax2.dsp
!IF "$(CFG)" == ""
CFG=Fax2 - Win32 Debug
!MESSAGE No configuration specified. Defaulting to Fax2 - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "Fax2 - Win32 Release" && "$(CFG)" != "Fax2 - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "Fax2.mak" CFG="Fax2 - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "Fax2 - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "Fax2 - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "Fax2 - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\Fax2.exe" "$(OUTDIR)\Fax2.bsc"


CLEAN :
	-@erase "$(INTDIR)\FAX2.OBJ"
	-@erase "$(INTDIR)\FAX2.res"
	-@erase "$(INTDIR)\FAX2.SBR"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\Fax2.bsc"
	-@erase "$(OUTDIR)\Fax2.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /Zp1 /ML /W3 /Ox /I "..\..\..\..\inc" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /FR"$(INTDIR)\\" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\FAX2.res" /d "NDEBUG" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\Fax2.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\FAX2.SBR"

"$(OUTDIR)\Fax2.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=oldnames.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib faxcpp32.lib bitiff.lib bidib.lib /nologo /stack:0x1400 /subsystem:windows /incremental:no /pdb:"$(OUTDIR)\Fax2.pdb" /machine:IX86 /def:".\FAX2.DEF" /out:"$(OUTDIR)\Fax2.exe" /libpath:"..\..\..\..\Lib" 
DEF_FILE= \
	".\FAX2.DEF"
LINK32_OBJS= \
	"$(INTDIR)\FAX2.OBJ" \
	"$(INTDIR)\FAX2.res"

"$(OUTDIR)\Fax2.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "Fax2 - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\Fax2.exe" "$(OUTDIR)\Fax2.bsc"


CLEAN :
	-@erase "$(INTDIR)\FAX2.OBJ"
	-@erase "$(INTDIR)\FAX2.res"
	-@erase "$(INTDIR)\FAX2.SBR"
	-@erase "$(OUTDIR)\Fax2.bsc"
	-@erase "$(OUTDIR)\Fax2.exe"
	-@erase "$(OUTDIR)\Fax2.ilk"
	-@erase "$(OUTDIR)\Fax2.pdb"
	-@erase ".\GENERIC.IDB"
	-@erase ".\GENERIC.PDB"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /Zp1 /MLd /W3 /Gm /GX /ZI /Od /I "..\..\..\..\inc" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /FR"$(INTDIR)\\" /Fo"$(INTDIR)\\" /Fd"GENERIC.PDB" /FD /c 

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
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\FAX2.res" /d "_DEBUG" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\Fax2.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\FAX2.SBR"

"$(OUTDIR)\Fax2.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=oldnames.lib faxcpp32.lib bidib.lib bitiff.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /stack:0x1400 /subsystem:windows /incremental:yes /pdb:"$(OUTDIR)\Fax2.pdb" /debug /machine:IX86 /def:".\FAX2.DEF" /out:"$(OUTDIR)\Fax2.exe" /pdbtype:sept /libpath:"..\..\..\..\Lib" 
DEF_FILE= \
	".\FAX2.DEF"
LINK32_OBJS= \
	"$(INTDIR)\FAX2.OBJ" \
	"$(INTDIR)\FAX2.res"

"$(OUTDIR)\Fax2.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("Fax2.dep")
!INCLUDE "Fax2.dep"
!ELSE 
!MESSAGE Warning: cannot find "Fax2.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "Fax2 - Win32 Release" || "$(CFG)" == "Fax2 - Win32 Debug"
SOURCE=.\FAX2.CPP

"$(INTDIR)\FAX2.OBJ"	"$(INTDIR)\FAX2.SBR" : $(SOURCE) "$(INTDIR)"


SOURCE=.\FAX2.RC

"$(INTDIR)\FAX2.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)



!ENDIF 

