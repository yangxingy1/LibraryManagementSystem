<%@ page import="com.demo.javabean.Students"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
    <title>学生账户详情</title>
    <link rel="stylesheet" href="../css/list.css">
    <style>
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }
        table {
            width: 80%;
            margin: 0 auto;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        th, td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f2f2f2;
            font-weight: bold;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
        .btn {
            display: inline-block;
            margin: 5px;
            padding: 6px 12px;
            background: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 4px;
        }
        .btn:hover {
            background: #0056b3;
        }
        .locked {
            color: red;
            font-weight: bold;
        }
        .normal {
            color: green;
        }
    </style>
</head>
<body>
<h2>学生账户详情</h2>
<table>
    <tr><td width="110px">学生学号：</td><td>${student.user}</td></tr>
    <tr><td width="110px">学生密码：</td><td>${student.password}</td></tr>
    <tr><td width="140px">学生姓名：</td><td>${student.name}</td></tr>
    <tr><td width="110px">学生年级：</td><td>${student.grade}</td></tr>
    <tr><td width="110px">学生班级：</td><td>${student.classes}</td></tr>
    <tr><td width="280px">电子邮箱：</td><td>${student.email}</td></tr>
    <tr><td width="80px">借书数量：</td><td>${student.amount}</td></tr>
    <tr>
        <td>账号状态：</td>
        <td class="${student.isLocked == 1 ? 'locked' : 'normal'}">
            ${student.isLocked == 1 ? '已锁定' : '正常'}
        </td>
    </tr>
</table>

<!-- ✅ 所有操作链接使用 manageStudent（正确路径） -->
<div style="text-align: center; margin-top: 20px;">
    <c:if test="${student.isLocked == 1}">
        <a class="btn" href="manageStudent?action=unlock&id=${student.id}"
           onclick="return confirm('确定解锁该账号？')">解锁账号</a>
    </c:if>
    <c:if test="${student.isLocked == 0}">
        <a class="btn" href="manageStudent?action=lock&id=${student.id}"
           onclick="return confirm('确定锁定该账号？')">锁定账号</a>
    </c:if>
    <a class="btn" href="#" onclick="resetPass(${student.id})">重置密码</a>
    <a class="btn" style="background:#6c757d;" href="PageServlet.do?method=showStudent">返回列表</a>
</div>

<script>
    function resetPass(id) {
        const newPass = prompt("请输入新密码（建议6位以上）：");
        if (newPass && newPass.trim() !== "") {
            // ✅ 修正路径：使用 manageStudent
            location.href = "manageStudent?action=resetPass&id=" + id + "&newPass=" + encodeURIComponent(newPass);
        } else if (newPass !== null) {
            alert("密码不能为空！");
        }
    }
</script>
</body>
</html>