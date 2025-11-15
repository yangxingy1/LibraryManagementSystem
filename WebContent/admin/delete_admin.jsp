<%--
  Created by IntelliJ IDEA.
  User: asus
  Date: 2025/11/15
  Time: 下午10:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>删除管理员</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
    <style>
        body { padding: 20px; background-color: #f8f9fa; }
        .table-container { max-width: 900px; margin: auto; background: white; padding: 20px; border-radius: 10px; }
    </style>
</head>
<body>
<div class="table-container">
    <h4>删除其他管理员</h4>
    <p class="text-danger">注意：此操作不可逆。您自己的账号不会显示在此列表中。</p>
    <a href="${pageContext.request.contextPath}/adminManageServlet.do?action=myProfile" class="btn btn-secondary mb-3">
        <i class="bi bi-arrow-left"></i> 返回
    </a>

    <table class="table table-striped table-hover">
        <thead>
        <tr>
            <th>ID</th>
            <th>用户名</th>
            <th>真实姓名</th>
            <th>邮箱</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <c:choose>
            <c:when test="${not empty otherAdmins}">
                <c:forEach items="${otherAdmins}" var="adm">
                    <tr>
                        <td>${adm.id}</td>
                        <td>${adm.admin}</td>
                        <td>${adm.realname}</td>
                        <td>${adm.email}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/adminManageServlet.do?action=doDelete&id=${adm.id}"
                               class="btn btn-danger btn-sm"
                               onclick="return confirm('确定要删除管理员 [${adm.admin}] 吗？此操作不可逆！');">
                                <i class="bi bi-trash"></i> 删除
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="5" class="text-center">没有其他可删除的管理员账号。</td>
                </tr>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>
</div>
</body>
</html>