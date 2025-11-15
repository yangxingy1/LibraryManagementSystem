<%--
  Created by IntelliJ IDEA.
  User: asus
  Date: 2025/11/15
  Time: 下午10:09
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>更改我的信息</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { padding: 20px; background-color: #f8f9fa; }
        .form-container { max-width: 600px; margin: auto; background: white; padding: 20px; border-radius: 10px; }
    </style>
</head>
<body>
<div class="form-container">
    <h4>更改我的信息</h4>
    <p>注意：用户名 (${admin.admin}) 不可更改。</p>
    <form action="${pageContext.request.contextPath}/adminManageServlet.do?action=doUpdate" method="post">

        <div class="mb-3">
            <label class="form-label">新密码 (如果不想修改，请保持原密码)</label>
            <input type="password" name="password" value="${admin.password}" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">真实姓名</label>
            <input type="text" name="realname" value="${admin.realname}" class="form-control">
        </div>
        <div class="mb-3">
            <label class="form-label">电话</label>
            <input type="text" name="phone" value="${admin.phone}" class="form-control">
        </div>
        <div class="mb-3">
            <label class="form-label">邮箱</label>
            <input type="email" name="email" value="${admin.email}" class="form-control">
        </div>
        <div class="mb-3">
            <label class="form-label">地址</label>
            <input type="text" name="address" value="${admin.address}" class="form-control">
        </div>

        <button type="submit" class="btn btn-primary">确认更新</button>
        <a href="${pageContext.request.contextPath}/adminManageServlet.do?action=myProfile" class="btn btn-secondary">取消</a>
    </form>
</div>
</body>
</html>