// Print HATS report in pdf format in client pc silently 
//
// (1) Put this script js file under adobe reader install path javascript path (for folder level)
// e.g, C:\Program Files (x86)\Adobe\Reader 11.0\Reader\Javascripts
//
// (2) Embed javascript method call trustedSilentPrint() in pdf. 
// It will use default printer for empty sPrinter.
//
// (3) Install Adobe Acrobat extension in Chrome 9version 58 or above), switch on "Open PDF in Acrobat"
//
// by Ricky 5 May 2017
trustedSilentPrint = app.trustedFunction (
    function(sPrinter, sCopies) {
		try{
			//======
			// get printer names
			//======
			var pName = '';
			var printerOK = false;
			if (sPrinter == '' || sPrinter == null) {
				printerOK = true;
			}

			for (i = 0; i < app.printerNames.length; i++) {
				pName = pName + app.printerNames[i] + ',';
				if (app.printerNames[i] == sPrinter) {
					printerOK = true;
				}
			}
			
			if (printerOK == false) {	// use default printer if no printer name match
				sPrinter = '';
			}
			
			//app.alert('[Local Printers: ' + pName + ']\nPrinter: ' + sPrinter + ', select: ' + printerOK);

			app.beginPriv();
			// raise privilege
			
			//======
			// get printer setting from ini
			//======
			var nhsini = util.readFileIntoStream("c:/hat/NHS.ini");
			var nhsinistr = util.stringFromStream(nhsini);
			//app.alert(nhsinistr);
			var cPRINTERNAME = 'PRINTER.NAME.SET1';

			var inivalue = nhsinistr.split("\n");
			//app.alert('inivalue='+inivalue);
			
			//======
			// get printer parameters
			//======
			var pp = this.getPrintParams();
			// set interaction level to silent
			pp.interactive = pp.constants.interactionLevel.silent;	// [automatic, full, silent]
			pp.pageHandling = pp.constants.handling.none;	// [none, fit, shrink, tileAll, tileLarge, nUp, booklet]
			// use printer name if provided
			
			// DEBUG
			// sPrinter = 'HATS_A5';
						
			if (sPrinter != '')
				pp.printerName = sPrinter;
			// use num of copies if provided
			if (sCopies != '')
				pp.NumCopies = parseInt(sCopies);
			
			// print using the print parameters
			var result = this.print(pp);

			//======
			// show result dialog
			//======
			var printMsg = "Printed successfully";
			if (sPrinter != '' && typeof sPrinter != 'undefined')
				printMsg = printMsg + " in printer:\n" + sPrinter;
			
			var oDlg = { 
				description: { name: "Printing", height: 80, width: 200, elements: [
					{ type: "ok", alignment: "align_right"},
					{ name: printMsg, type: "static_text", height: 50, width: 180}
				] } 
			}; 

			// Dialog Activation 
			app.execDialog(oDlg);	
			
			// close document after print, mininize adobe reader
			this.closeDoc(true);
			app.execMenuItem("MinimizeAll");
		}catch(e){
			var errMsg = e.name+" on line " +e.lineNumber+ ": " +e.message;
			app.alert("Failed to print. Please contact IT.\n\n["+errMsg+"]");
			//console.println(errMsg);
		}
		
		app.endPriv();
    // end raised privilege
    } 
// end app.trustedFunciton
)
// end trusted Silent Print definition// end folder level JS code