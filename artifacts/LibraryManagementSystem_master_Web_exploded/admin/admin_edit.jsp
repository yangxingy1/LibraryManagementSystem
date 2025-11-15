<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
    <title>编辑管理员</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 600px; margin: 20px auto; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input[type="text"], input[type="password"], input[type="email"] {
            width: 100%; padding: 8px; box-sizing: border-box;
        }
        .btn { padding: 10px 20px; background: #4CAF50; color: white; border: none; cursor: pointer; }
        .btn.cancel { background: #999; }
    </style>
</head>
<body>
<h2>编辑管理员</h2>
<form method="post" action="manageAdmin">
    <input type="hidden" name="action" value="edit">
    <input type="hidden" name="id" value="${admin.id}">

    <div class="form-group">
        <label>用户名 *</label>
        <input type="text" name="admin" value="${admin.admin}" required>
    </div>
    <div class="form-group">
        <label>新密码（留空不修改）</label>
        <input type="password" name="password">
    </div>
    <div class="form-group">
        <label>真实姓名</label>
        <input type="text" name="realname" value="${admin.realname}">
    </div>
    <div class="form-group">
        <label>电话</label>
        <input type="text" name="phone" value="${admin.phone}">
    </div>
    <div class="form-group">
        <label>邮箱</label>
        <input type="email" name="email" value="${admin.email}">
    </div>
    <div class="form-group">
        <label>地址</label>
        <input type="text" name="address" value="${admin.address}">
    </div>
    <div class="form-group">
        <label>
            <input type="checkbox" name="isLocked" value="on"
            ${admin.isLocked == 1 ? 'checked' : ''}> 锁定账号
        </label>
    </div>

    <button type="submit" class="btn">保存</button>
    <a href="manageAdmin?action=list" class="btn cancel">取消</a>
</form>
</body>
</html>