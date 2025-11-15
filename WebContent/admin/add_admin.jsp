<%--
  Created by IntelliJ IDEA.
  User: asus
  Date: 2025/11/15
  Time: 下午10:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>添加新管理员</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { padding: 20px; background-color: #f8f9fa; }
        .form-container { max-width: 600px; margin: auto; background: white; padding: 20px; border-radius: 10px; }
    </style>
</head>
<body>
<div class="form-container">
    <h4>添加新管理员</h4>
    <form action="${pageContext.request.contextPath}/adminManageServlet.do?action=doAdd" method="post">

        <div class="mb-3">
            <label class="form-label">ID (临时方案，后续应改为自增)</label>
            <input type="number" name="id" class="form-control" placeholder="输入一个唯一的数字ID" required>
        </div>
        <div class="mb-3">
            <label class="form-label">用户名 (admin)</label>
            <input type="text" name="admin" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">密码 (password)</label>
            <input type="password" name="password" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">真实姓名</label>
            <input type="text" name="realname" class="form-control">
        </div>
        <div class="mb-3">
            <label class="form-label">电话</label>
            <input type="text" name="phone" class="form-control">
        </div>
        <div class="mb-3">
            <label class="form-label">邮箱</label>
            <input type="email" name="email" class="form-control">
        </div>
        <div class="mb-3">
            <label class="form-label">地址</label>
            <input type="text" name="address" class="form-control">
        </div>

        <button type="submit" class="btn btn-success">确认添加</button>
        <a href="${pageContext.request.contextPath}/adminManageServlet.do?action=myProfile" class="btn btn-secondary">取消</a>
    </form>
</div>
</body>
</html>
