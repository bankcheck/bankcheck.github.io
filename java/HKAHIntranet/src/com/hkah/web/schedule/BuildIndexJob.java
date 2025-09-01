package com.hkah.web.schedule;

import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.search.Indexer;
import com.hkah.web.db.helper.FsModelHelper;

public class BuildIndexJob implements Job {

	//======================================================================
	private static Logger logger = Logger.getLogger(BuildIndexJob.class);

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		// -- Forward Scanning --
		FsModelHelper.clearAllTempImportFiles();
		FsModelHelper.clearAllPreviewImages();
		String[] policyFolders = new String[] {
				ConstantsServerSide.POLICY_FOLDER,
				"\\\\hkim\\im\\Intranet\\Dept\\Infection Control\\INFC\\Policy"
		};
		Indexer.optimize(true, ConstantsServerSide.INDEX_FOLDER, policyFolders);
		logger.info("Thread BuildIndexThread doAction finish");
	}
}