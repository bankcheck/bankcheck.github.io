using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace RecDTMF_FaxOrVoiceCSharp
{
    public partial class Help : Form
    {
        public Help()
        {
            InitializeComponent();

            helpList.Items.Add("The sample shows how you can receive DTMF digits, receive faxes and record voices.");
            helpList.Items.Add("");
            helpList.Items.Add("You can open a COM port or a channel of three different card type with the \"Open\" buttons");
            helpList.Items.Add("");
            helpList.Items.Add("After open a port or a channel the sample answers automatically to a remote dialing and then you can choose one of the following:");
            helpList.Items.Add("  Click on \"Receive Fax\" button to switch to fax mode, and then create a fax port and wait for a fax receiving on this port.");
            helpList.Items.Add("  After a fax sent to this port this feature can automatically receive the fax object and then save it automatically to the");
            helpList.Items.Add("  directory appears in a Message Box after end receiving. At the end of the receiving mode turns back to voice mode.");
            helpList.Items.Add("");
            helpList.Items.Add("  Click on \"Wait for DTMF\" button to set how many DTMF digits you like to get and the delimiter digit.");
            helpList.Items.Add("  After this settings the sample waits for DTMF digits until those arrive.");
            helpList.Items.Add("  When receive, digits behind the delimiter will be left.");
            helpList.Items.Add("");
            helpList.Items.Add("  Click on \"Record message\" button to record a voice message.");
            helpList.Items.Add("  After the click it waits for some time for a voice format message. In both case (voice received or not received)");
            helpList.Items.Add("  it creates a .wav file. If no voice format message received this file will contain nothing worthy, only some noise.");
            helpList.Items.Add("  In the other case it will contain the voice sent to this port.");
            helpList.Items.Add("");
            helpList.Items.Add("  Click on the \"Close port/channel\" to automatically close the opened port or channel");
        }

        private void OKButton_Click(object sender, EventArgs e)
        {
            Close();
        }

    }
}