<%--
  Created by IntelliJ IDEA.
  User: asus
  Date: 2025/11/15
  Time: 下午10:08
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>管理员账号管理</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
    <style>
        body { padding: 20px; background-color: #f8f9fa; }
        .profile-container { max-width: 800px; margin: auto; }
        .card-header { background: linear-gradient(90deg, #2c3e50 0%, #3498db 100%); color: white; }
    </style>
</head>
<body>
<div class="container profile-container">
    <div class="card">
        <div class="card-header">
            <h4><i class="bi bi-person-badge"></i> 我的账户信息</h4>
        </div>
        <div class="card-body">
            <table class="table table-bordered">
                <tr>
                    <th width="30%">用户名 (admin)</th>
                    <td>${admin.admin} (此字段不可修改)</td>
                </tr>
                <tr>
                    <th>密码 (password)</th>
                    <td>****** (出于安全考虑，密码不在此显示)</td>
                </tr>
                <tr>
                    <th>真实姓名 (realname)</th>
                    <td>${admin.realname}</td>
                </tr>
                <tr>
                    <th>电话 (phone)</th>
                    <td>${admin.phone}</td>
                </tr>
                <tr>
                    <th>邮箱 (email)</th>
                    <td>${admin.email}</td>
                </tr>
                <tr>
                    <th>地址 (address)</th>
                    <td>${admin.address}</td>
                </tr>
            </table>

            <hr>

            <a href="${pageContext.request.contextPath}/adminManageServlet.do?action=showUpdateForm" class="btn btn-primary">
                <i class="bi bi-pencil-square"></i> 更改我的信息
            </a>

            <a href="${pageContext.request.contextPath}/adminManageServlet.do?action=showAddForm" class="btn btn-success">
                <i class="bi bi-person-plus"></i> 添加新管理员
            </a>

            <a href="${pageContext.request.contextPath}/adminManageServlet.do?action=showDeleteList" class="btn btn-danger">
                <i class="bi bi-trash"></i> 删除其他管理员
            </a>
        </div>
    </div>
</div>
</body>
</html>
