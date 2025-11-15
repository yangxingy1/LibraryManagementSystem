<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Calendar" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>AdminPage</title>
    <link rel="stylesheet" href="css/head02.css">
    <link rel="stylesheet" href="css/index.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="sidebar">
    <ul>
        <li><a href="admin.jsp">首页</a></li>
        <li><a href="admin/add_student.jsp" target="showBook">添加学生</a></li>
        <li><a href="PageServlet.do?method=showStudent" target="showBook">查看学生</a></li>
        <li><a href="PageServlet.do?method=delStudent" target="showBook">删除学生</a></li>
        <li><a href="admin/reg_book.jsp" target="showBook">添加书籍</a></li>
        <li><a href="PageServlet.do?method=showBook" target="showBook">查看书籍</a></li>
        <li><a href="borrowAdminServlet.do?action=listPending" target="showBook">借阅审批</a></li>
        <!-- ✅ 新增：管理管理员账号 -->
        <li><a href="manageAdmin?action=list" target="showBook">管理管理员账号</a></li>
        <li><a href="login.jsp">切换账号/退出</a></li>
    </ul>
</div>
<%
    Calendar cal = Calendar.getInstance();
    SimpleDateFormat format = new SimpleDateFormat("yyyy年-MM月-dd日");
%>
<div class="box">
    <div class="box-head"><h1>图 书 馆 管 理 系 统</h1></div>
    <p align="right">欢迎你，管理员 </p>
    <p align="right"><% out.println(format.format(cal.getTime()));%></p>
    <iframe name="showBook" src="" frameborder="0" width="100%" height="80%"></iframe>
</div>
</body>
</html>