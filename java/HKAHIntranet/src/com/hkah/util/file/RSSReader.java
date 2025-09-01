package com.hkah.util.file;

import java.net.URL;
import java.util.ArrayList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class RSSReader {
	private static ArrayList<String[]> getRSSitems() {

		ArrayList<String[]> rssItems = new ArrayList<String[]>();
		DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory
				.newInstance();

		try {
			DocumentBuilder docBuilder = docBuilderFactory.newDocumentBuilder();

			// remote rss xml
			URL url = new URL(
					"http://newsrss.bbc.co.uk/rss/sportonline_world_edition/front_page/rss.xml");
			Document doc = docBuilder.parse(url.openStream());

			/*
			 * //local rss xml File f = new File("[localPath]/rss.xml");
			 * Document doc = docBuilder.parse(f);
			 */

			doc.getDocumentElement().normalize();

			// list xml by tags (this is not a generic solution
			// so we must know exact rss xml structure)
			NodeList nlItems = doc.getElementsByTagName("item");
			int totalItems = nlItems.getLength();

			for (int i = 0; i < totalItems; i++) {
				Node tableNode = nlItems.item(i);
				if (tableNode.getNodeType() == Node.ELEMENT_NODE) {
					String[] rssItem = new String[9];
					Element tableElement = (Element) tableNode;

					NodeList nodeList = tableElement
							.getElementsByTagName("title");
					Element element = (Element) nodeList.item(0);
					NodeList textList = element.getChildNodes();
					rssItem[0] = ((Node) textList.item(0)).getNodeValue()
							.trim();

					nodeList = tableElement.getElementsByTagName("description");
					element = (Element) nodeList.item(0);
					textList = element.getChildNodes();
					rssItem[1] = ((Node) textList.item(0)).getNodeValue()
							.trim();

					nodeList = tableElement.getElementsByTagName("link");
					element = (Element) nodeList.item(0);
					textList = element.getChildNodes();
					rssItem[2] = ((Node) textList.item(0)).getNodeValue()
							.trim();

					nodeList = tableElement.getElementsByTagName("guid");
					element = (Element) nodeList.item(0);
					textList = element.getChildNodes();
					rssItem[3] = ((Node) textList.item(0)).getNodeValue()
							.trim();

					nodeList = tableElement.getElementsByTagName("pubDate");
					element = (Element) nodeList.item(0);
					textList = element.getChildNodes();
					rssItem[4] = ((Node) textList.item(0)).getNodeValue()
							.trim();

					nodeList = tableElement.getElementsByTagName("category");
					element = (Element) nodeList.item(0);
					textList = element.getChildNodes();
					rssItem[5] = ((Node) textList.item(0)).getNodeValue()
							.trim();

					nodeList = tableElement
							.getElementsByTagName("media:thumbnail");
					element = (Element) nodeList.item(0);
					rssItem[6] = element.getAttribute("width");
					rssItem[7] = element.getAttribute("height");
					rssItem[8] = element.getAttribute("url");

					rssItems.add(rssItem);
				}

			}
		} catch (Exception e) {
			e.printStackTrace(System.out);
		}
		return rssItems;
	}

	public static void main(String[] args) {

		ArrayList<String[]> rssItems = getRSSitems();
		for (int i = 0; i < rssItems.size(); i++) {
			String[] rssItem = rssItems.get(i);
			System.out.println("title: " + rssItem[0]);
			System.out.println("description: " + rssItem[1]);
			System.out.println("link: " + rssItem[2]);
			System.out.println("guid: " + rssItem[3]);
			System.out.println("pubDate: " + rssItem[4]);
			System.out.println("category: " + rssItem[5]);
			System.out.println("IMG attrubutes: width=" + rssItem[6]
					+ ", height=" + rssItem[7] + ", url=" + rssItem[8] + "\n");
		}
	}
}