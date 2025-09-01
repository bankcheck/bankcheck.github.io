<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="org.springframework.util.StringUtils"%>
<%!
	public String[] getImage() {
		String[] imageName = null;
		try {
			File directory = new File(ConstantsServerSide.UPLOAD_WEB_FOLDER + "/Photo Gallery");
			String[] children = directory.list();
			if (children.length > 0) {
				imageName = new String[children.length];
				for (int i = 0; i < children.length; i++) {
					if (children[i] != null && (children[i].toUpperCase().indexOf(".JPG") > 0 || children[i].toUpperCase().indexOf(".GIF") > 0)) {
						imageName[i] = children[i];
					}
				}
			}
		} catch (Exception e) {
		}
		return imageName;
	}

	private static Properties readProperties(String fileName) {
		try {
			Properties properties = new Properties();
			properties.load(new FileInputStream(new File(fileName)));
			return properties; 
		} catch (Exception e) {
			return null;
		}		
	}

	public static String getValue(Properties properties, String key) {
		String value = null;
		try {
			value = properties.getProperty(key);
		} catch (Exception e) {
		}

		if (value == null) {
			value = ConstantsVariable.EMPTY_VALUE;
		}
		return value;
	}
	
	public static LinkedHashMap<String, String> getOrderedPropertiesMap(File file, String keySuffix) {
		if (file == null) {
			return null;
		}
		
		LinkedHashMap<String, String> map = new LinkedHashMap<String, String>();
		BufferedReader br = null;
		try {
			br = new BufferedReader(new FileReader(file));
			
		    String strLine;
		    String[] keyValuePair;
		    String key = null;
		    String value = null;
		    while ((strLine = br.readLine()) != null)   {
		      
		      keyValuePair = strLine.split("=", 2);
		      if (keyValuePair != null && keyValuePair.length == 2) {
		    	  key = keyValuePair[0];
		    	  value = keyValuePair[1];
		    	  if (key != null && StringUtils.endsWithIgnoreCase(key.trim(), keySuffix)) {
		    	  	map.put(key.trim().replace(keySuffix, "").toLowerCase(), value);
		    	  }
		      }
		    }

		} catch (Exception e) {
		} finally {
			if (br != null) {
				try {
			    	br.close();
				} catch (Exception e) {
				}
			}
		}
		return map;
	}
%><?xml version="1.0" encoding="utf-8"?>
<photo_player>
    <photo_delay>5</photo_delay>
<%
	// ---------------
	// display image by the order of the item in description text file
	// ---------------
	LinkedHashMap<String, String> orderedHeadlineMap = new LinkedHashMap<String, String>();
	LinkedHashMap<String, String> orderedCaptionMap = new LinkedHashMap<String, String>();
	String headlineSuffix = ".headline";
	String captionSuffix = ".caption";
	
	// read the description file
	String descriptionFilePath = null;
	if (ConstantsServerSide.SITE_CODE_HKAH.equalsIgnoreCase(ConstantsServerSide.SITE_CODE)) {
		descriptionFilePath = ConstantsServerSide.UPLOAD_WEB_FOLDER + "/Photo Gallery/description.txt";
	} else if (ConstantsServerSide.SITE_CODE_TWAH.equalsIgnoreCase(ConstantsServerSide.SITE_CODE)) {
		descriptionFilePath = "\\\\192.168.0.20\\document\\Upload\\Photo Gallery\\description.txt";
	} else {
		// default
		descriptionFilePath = ConstantsServerSide.UPLOAD_WEB_FOLDER + "/Photo Gallery/description.txt";
	}
	
	File file = new File(descriptionFilePath);
	System.out.println("DEBUG: descriptionFilePath = " + descriptionFilePath);
	System.out.println("DEBUG: file = " + file);
	if (file != null) {
		System.out.println("DEBUG: file.getName = " + file.getName());
	}
	
	orderedHeadlineMap = getOrderedPropertiesMap(file, headlineSuffix);
	orderedCaptionMap = getOrderedPropertiesMap(file, captionSuffix);
	
	String[] galleryImage = getImage();
	
	Set<String> keys = null;
	Iterator<String> itr = null;
	String imageName = null;
	
	// create a set that contains names of existing images
	Set<String> galleryNameSet = new HashSet<String>();
	if (galleryImage != null) {
		for (String name : galleryImage) {
			if (name != null) {
				galleryNameSet.add(name.toLowerCase());
			}
		}
	}
	
	Set<String> displayGallerySet = new LinkedHashSet<String>();
	
	// get an ordered gallery name set from properties file
	keys = orderedHeadlineMap.keySet();
	itr = keys.iterator();
	while (itr.hasNext()) {
		imageName = itr.next();
		if (imageName != null && galleryNameSet.contains(imageName)) {
			displayGallerySet.add(imageName);
		}
	}	
	// append gallery does not included in properties file
	itr = galleryNameSet.iterator();
	while (itr.hasNext()) {
		imageName = itr.next();
		if (imageName != null && !displayGallerySet.contains(imageName)) {
			displayGallerySet.add(imageName.toLowerCase());
		}
	}	
	
	// add images to player
	int i = 1;
	if (displayGallerySet != null) {
		int digit = 0;
		try {
			digit = Integer.toString(orderedHeadlineMap.size()).length();
		} catch (Exception e) {
		}
		String seqNum = null;
		
		itr = displayGallerySet.iterator();
		String galleryImageName = null;
		while (itr.hasNext()) {
			galleryImageName = (String) itr.next();
			
			// caution: the order of photo seq number start from left, i.e. order of 2 is less than 10 !!
			seqNum = org.apache.commons.lang.StringUtils.leftPad(String.valueOf(i), digit, "0");	
			
			%>
			   <photo>
			       <photo_seq_number><%=seqNum %></photo_seq_number>
			       <photo_filename>/Photo%20Gallery/<%=galleryImageName %></photo_filename>
			       <photo_path>/upload</photo_path>
			       <photo_source><![CDATA[<%=galleryImageName %>]]></photo_source>
			       <photo_headline><![CDATA[<%=orderedHeadlineMap.get(galleryImageName) == null ? "" : orderedHeadlineMap.get(galleryImageName) %>]]></photo_headline>
			       <photo_caption><![CDATA[<%=orderedCaptionMap.get(galleryImageName) == null ? "" : orderedCaptionMap.get(galleryImageName) %>]]></photo_caption>
			       <article_id></article_id>
			       <photo_article_url></photo_article_url>
			       <photo_url>/upload/Photo%20Gallery/<%=galleryImageName %></photo_url>
			       <photo_large_pic_url>/upload/Photo%20Gallery/<%=galleryImageName %></photo_large_pic_url>
			       <photo_new_win>0</photo_new_win>
			   </photo>
			<%	
			i++;
		}
	}
		
%>
</photo_player>