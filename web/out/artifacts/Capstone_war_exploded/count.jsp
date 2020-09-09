<%@page import="st.*"%>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.Statement" %>
<%@ page import = "java.sql.ResultSet" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="EUC-KR"%>
<%--<%@ page contentType="text/html;charset=MS949" errorPage="error.jsp"%>--%>
<!DOCTYPE html>
<%
    String stid = request.getParameter("stid");

    stDAO cnt = new stDAO();
    session.setAttribute("count", cnt.detect(stid));
%>
<script type="text/javascript">
    alert("");
    location.href= "<%= request.getContextPath()%>/index.jsp";
</script>
