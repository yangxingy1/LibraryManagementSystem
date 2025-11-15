<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.demo.javabean.Students" %>
<%@ page import="com.demo.dao.BookDAO" %>
<%@ page import="com.demo.javabean.Books" %>
<%@ page import="java.util.ArrayList" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Show Book</title>
    <style>
        /* (您可以复用您项目中的 list.css 或 show_book.jsp 的样式) */
        body { font-family: Arial, sans-serif; }
        h2 { margin-top: 20px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
        tr:hover { background-color: #ddd; }
        td a { color: #4CAF50; text-decoration: none; }
        td a:hover { color: #2196F3; }
        td.pagination { text-align: center; padding: 10px; background-color: #f8f9fa; border: 1px solid #dee2e6; font-weight: bold; }
        /* 图书状态的样式 */
        .status-instock { color: #28a745; font-weight: bold; }
        .status-pending { color: #ffc107; font-weight: bold; }
        .status-borrowed { color: #dc3545; }
        .link-disabled { color: #999; text-decoration: none; cursor: not-allowed; }
    </style>
</head>
<body>

<jsp:useBean id="bookDAO" class="com.demo.dao.BookDAO" scope="page" />

<%-- (功能2) 从 session 获取学生对象，用于传递 s_id --%>
<c:set var="student" value="${sessionScope.student}" />

<h2>
    <c:choose>
        <c:when test="${not empty books}">
            全部图书
        </c:when>
        <c:otherwise>
            暂无图书
        </c:otherwise>
    </c:choose>
</h2>

<form action="userChoiceServlet.do" method="get">
    <input type="text" name="name" placeholder="请输入图书名称">
    <input type="text" name="signal" value="1" hidden>
    <input type="submit" value="查询">
</form>

<table>
    <tr>
        <td width="250px">图书名称</td>
        <td width="200px">图书作者</td>
        <td width="150px">图书类型</td>
        <td width="100px">当前状态</td> <%-- 【修改点 2】: 新增状态列 --%>
        <td width="50px">操作</td>
    </tr>

    <c:forEach items="${sessionScope.books}" var="book">
        <%-- (功能2) 在循环中获取每本书的状态 --%>
        <%-- (性能提示: 此处为 N+1 查询，如需优化，需重构 UserChoiceServlet) --%>
        <c:set var="bookStatus" value="${bookDAO.getBookStatus(book.id)}" />

        <tr>
            <td>${book.name}</td>
            <td>${book.author}</td>
            <td>${book.category}</td>

                <%-- (功能2) 根据状态显示不同样式 --%>
            <td>
                <c:choose>
                    <c:when test="${bookStatus == '在库'}">
                        <span class="status-instock">在库</span>
                    </c:when>
                    <c:when test="${bookStatus == '待审批'}">
                        <span class="status-pending">待审批</span>
                    </c:when>
                    <c:otherwise>
                        <span class="status-borrowed">借出</span>
                    </c:otherwise>
                </c:choose>
            </td>

            <td>
                    <%-- (功能2 & 3) 仅在 "在库" 时显示 "申请借阅" 链接 --%>
                <c:choose>
                    <c:when test="${bookStatus == '在库'}">
                        <a href="${pageContext.request.contextPath}/borrowServlet.do?s_id=${student.id}&b_id=${book.id}"
                           onclick="return confirm('确定要申请借阅《${book.name}》吗？');">申请借阅</a>
                    </c:when>
                    <c:otherwise>
                        <span class="link-disabled">不可申请</span>
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
    </c:forEach>
</table>

<tr>
    <td align="center" colspan="6" class="pagination">
        <%-- EL表达式 ${bar} 会自动输出 request.getAttribute("bar") 的内容 --%>
        ${bar} /页
    </td>
</tr>
</body>
</html>