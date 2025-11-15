<%--
  Created by IntelliJ IDEA.
  User: asus
  Date: 2025/11/15
  Time: 下午2:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>待审批的借阅申请</title>
    <style>
        /* (您可以复用您项目中的 list.css 或 show_book.jsp 的样式) */
        body { font-family: Arial, sans-serif; }
        h2 { margin-top: 20px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
        tr:hover { background-color: #ddd; }
        td a { color: #4CAF50; text-decoration: none; margin-right: 10px; }
        td a:hover { color: #2196F3; }
        .empty-list { color: #888; font-style: italic; }
    </style>
</head>
<body>
<h2>待审批的借阅申请 (按申请时间排序)</h2>

<table>
    <tr>
        <th>申请学生</th>
        <th>学生学号</th>
        <th>申请书籍</th>
        <th>申请时间</th>
        <th>操作</th>
    </tr>

    <c:choose>
        <%-- (功能1) 遍历 BorrowAdminServlet 传来的 pendingList --%>
        <c:when test="${not empty pendingList}">
            <c:forEach items="${pendingList}" var="borrow">
                <tr>
                        <%-- (BorrowDAO中已帮我们获取了关联的 Student 和 Book 对象) --%>
                    <td>${borrow.student.name}</td>
                    <td>${borrow.student.user}</td>
                    <td>${borrow.book.name}</td>

                        <%-- 格式化日期 --%>
                    <td><fmt:formatDate value="${borrow.request_date}" pattern="yyyy-MM-dd HH:mm:ss"/></td>

                    <td>
                            <%-- (功能1) 批准和拒绝链接 --%>
                        <a href="${pageContext.request.contextPath}/borrowAdminServlet.do?action=approve&borrow_id=${borrow.id}"
                           onclick="return confirm('确定批准该申请吗？');">批准</a>

                        <a href="${pageContext.request.contextPath}/borrowAdminServlet.do?action=deny&borrow_id=${borrow.id}"
                           style="color: #E63946;"
                           onclick="return confirm('确定拒绝该申请吗？');">拒绝</a>
                    </td>
                </tr>
            </c:forEach>
        </c:when>
        <%-- 如果列表为空 --%>
        <c:otherwise>
            <tr>
                <td colspan="5" class="empty-list">当前没有待审批的借阅申请。</td>
            </tr>
        </c:otherwise>
    </c:choose>

</table>
</body>
</html>
