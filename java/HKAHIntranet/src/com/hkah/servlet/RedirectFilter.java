package com.hkah.servlet;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RedirectFilter implements Filter {

	@Override
	public void destroy() {
	}

	@Override
	public void doFilter(ServletRequest req, ServletResponse res,
			FilterChain chain) throws IOException, ServletException {
		HttpServletRequest httpReq = (HttpServletRequest) req;
	    HttpServletResponse httpRes = (HttpServletResponse) res;
	    String url = httpReq.getRequestURI();
	    
	    if (url != null) {
	    	if (url.contains("marketing/HKAH_CNY2014.gif")) {
		    	httpRes.sendRedirect("../ChineseNewYearEcard2014/HKAH");
		    	return;
	    	} else if (url.contains("marketing/TWAH_CNY2014.gif")) {
		    	httpRes.sendRedirect("../ChineseNewYearEcard2014/TWAH");
		    	return;
	    	}
	    }
	    chain.doFilter(req, res);
	}

	@Override
	public void init(FilterConfig arg0) throws ServletException {
	}
}
