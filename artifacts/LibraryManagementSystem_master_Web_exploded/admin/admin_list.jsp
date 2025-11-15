<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
    <title>管理员账户管理</title>
    <style>
        body { font-family: Arial, sans-serif; }
        h2 { margin-top: 20px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
        .locked { color: red; }
        .normal { color: green; }
        .btn { color: #2196F3; text-decoration: none; }
    </style>
</head>
<body>
<h2>所有管理员账户信息</h2>
<p><a href="manageAdmin?action=addForm" class="btn">➕ 添加新管理员</a></p>

<table>
    <tr>
        <th>ID</th>
        <th>用户名</th>
        <th>真实姓名</th>
        <th>电话</th>
        <th>邮箱</th>
        <th>状态</th>
        <th>操作</th>
    </tr>
    <c:forEach items="${admins}" var="a">
        <tr>
            <td>${a.id}</td>
            <td>${a.admin}</td>
            <td>${a.realname}</td>
            <td>${a.phone}</td>
            <td>${a.email}</td>
            <td class="${a.isLocked == 1 ? 'locked' : 'normal'}">
                    ${a.isLocked == 1 ? '🔒 已锁定' : '✅ 正常'}
            </td>
            <td>
                <a href="manageAdmin?action=editForm&id=${a.id}">编辑</a> |
                <a href="manageAdmin?action=delete&id=${a.id}"
                   onclick="return confirm('确定删除？')">删除</a>
            </td>
        </tr>
    </c:forEach>
    <c:if test="${empty admins}">
        <tr>
            <td colspan="7" style="text-align:center; color:red;">暂无管理员数据</td>
        </tr>
    </c:if>
</table>
</body>
</html>