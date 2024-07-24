namespace RecDTMF_FaxOrVoiceCSharp
{
    partial class WaitforDTMF
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(WaitforDTMF));
            this.label1 = new System.Windows.Forms.Label();
            this.numOfDigits = new System.Windows.Forms.TextBox();
            this.delimiter = new System.Windows.Forms.Label();
            this.delimDigit = new System.Windows.Forms.TextBox();
            this.OKButton = new System.Windows.Forms.Button();
            this.cancelButton = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(7, 13);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(119, 13);
            this.label1.TabIndex = 0;
            this.label1.Text = "Number of DTMF digits:";
            // 
            // numOfDigits
            // 
            this.numOfDigits.Location = new System.Drawing.Point(132, 10);
            this.numOfDigits.MaxLength = 3;
            this.numOfDigits.Name = "numOfDigits";
            this.numOfDigits.Size = new System.Drawing.Size(50, 20);
            this.numOfDigits.TabIndex = 1;
            // 
            // delimiter
            // 
            this.delimiter.AutoSize = true;
            this.delimiter.Location = new System.Drawing.Point(7, 38);
            this.delimiter.Name = "delimiter";
            this.delimiter.Size = new System.Drawing.Size(72, 13);
            this.delimiter.TabIndex = 2;
            this.delimiter.Text = "Delimiter digit:";
            // 
            // delimDigit
            // 
            this.delimDigit.Location = new System.Drawing.Point(132, 38);
            this.delimDigit.MaxLength = 1;
            this.delimDigit.Name = "delimDigit";
            this.delimDigit.Size = new System.Drawing.Size(50, 20);
            this.delimDigit.TabIndex = 3;
            // 
            // OKButton
            // 
            this.OKButton.Location = new System.Drawing.Point(10, 72);
            this.OKButton.Name = "OKButton";
            this.OKButton.Size = new System.Drawing.Size(75, 23);
            this.OKButton.TabIndex = 4;
            this.OKButton.Text = "OK";
            this.OKButton.UseVisualStyleBackColor = true;
            this.OKButton.Click += new System.EventHandler(this.OKButton_Click);
            // 
            // cancelButton
            // 
            this.cancelButton.Location = new System.Drawing.Point(107, 72);
            this.cancelButton.Name = "cancelButton";
            this.cancelButton.Size = new System.Drawing.Size(75, 23);
            this.cancelButton.TabIndex = 5;
            this.cancelButton.Text = "Cancel";
            this.cancelButton.UseVisualStyleBackColor = true;
            this.cancelButton.Click += new System.EventHandler(this.cancelButton_Click);
            // 
            // WaitforDTMF
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(189, 105);
            this.Controls.Add(this.cancelButton);
            this.Controls.Add(this.OKButton);
            this.Controls.Add(this.delimDigit);
            this.Controls.Add(this.delimiter);
            this.Controls.Add(this.numOfDigits);
            this.Controls.Add(this.label1);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "WaitforDTMF";
            this.Text = "Wait for DTMF";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox numOfDigits;
        private System.Windows.Forms.Label delimiter;
        private System.Windows.Forms.TextBox delimDigit;
        private System.Windows.Forms.Button OKButton;
        private System.Windows.Forms.Button cancelButton;
    }
}