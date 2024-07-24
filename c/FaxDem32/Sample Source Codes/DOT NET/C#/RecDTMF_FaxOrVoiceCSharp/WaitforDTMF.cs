using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace RecDTMF_FaxOrVoiceCSharp
{
    public partial class WaitforDTMF : Form
    {
        private short nDTMFnum;
        private short nDelimiter;

        public WaitforDTMF()
        {
            InitializeComponent();
        }

        private void cancelButton_Click(object sender, EventArgs e)
        {
            Close();
        }

        private void OKButton_Click(object sender, EventArgs e)
        {
            if (numOfDigits.Text != "")
            {
                nDTMFnum = Convert.ToInt16(numOfDigits.Text);
                if (delimDigit.Text != "")
                {
                    nDelimiter = Convert.ToInt16(delimDigit.Text[0]);
                }
                else 
                {
                    nDelimiter = 0;
                }
                Close();
            }
        }

        public short GetNumberOfDigits()
        {
            return nDTMFnum;
        }

        public short GetDelimiter()
        {
            return nDelimiter;
        }
    }
}