<!DOCTYPE html>
<%@ page import="com.hkah.constant.ConstantsServerSide"%>
<img src="../images/star.gif"/>Welcome to Hospital Intranet Portal
<% if (ConstantsServerSide.SECURE_SERVER) { %>
<svg width="90" height="20">
  <rect x="0" y="0" rx="5" ry="5" width="90" height="30"
  	style="fill:rgb(55,200,55);opacity:0.5" />
  <text x="5" y="20" fill="white" style="font-size:16px;">Off-Campus</text>
</svg>
 (Some functions are limited)
<% } %>