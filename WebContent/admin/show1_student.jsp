<%@ page import="com.demo.javabean.Students"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.demo.dao.StudentDAO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
    <title>All Student</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        h2 {
            margin-top: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #ddd;
        }
        td a {
            color: #4CAF50;
            text-decoration: none;
        }
        td a:hover {
            color: #2196F3;
        }
        td.pagination {
            text-align: center;
            padding: 10px;
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            font-weight: bold;
        }
        .locked { color: red; }
        .normal { color: green; }
    </style>
</head>
<body>
<h2>所有学生账户信息</h2>
<form action="PageServlet.do" method="get">
    <input type="text" name="user" placeholder="请输入学生学号">
    <input type="text" name="name" placeholder="请输入学生姓名">
    <input type="text" name="method" value="showStudent" hidden>
    <input type="submit" value="查询">
</form>

<table>
    <tr>
        <td width="150px">学生学号</td>
        <td width="150px">学生姓名</td>
        <td width="150px">学生年级</td>
        <td width="150px">学生班级</td>
        <td width="100px">账号状态</td>
        <td width="150px">操作</td>
    </tr>
    <c:forEach items="${list}" var="s">
        <tr>
            <td>${s.user}</td>
            <td>${s.name}</td>
            <td>${s.grade}</td>
            <td>${s.classes}</td>
            <td class="${s.isLocked == 1 ? 'locked' : 'normal'}">
                <c:choose>
                    <c:when test="${s.isLocked == 1}">🔒 已锁定</c:when>
                    <c:otherwise>✅ 正常</c:otherwise>
                </c:choose>
            </td>
            <!-- ✅ 修正路径：使用 manageStudent（与 @WebServlet 一致） -->
            <td>
                <a href="manageStudent?action=showstudent&user=${s.user}">详情</a>
            </td>
        </tr>
    </c:forEach>
    <tr>
        <td align="center" colspan="6" class="pagination">
            ${bar}/页
        </td>
    </tr>
</table>
</body>
</html>