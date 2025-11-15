<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.demo.javabean.Students" %>
<%@ page import="com.demo.dao.BorrowDAO" %>
<%@ page import="com.demo.javabean.Borrows" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.demo.dao.BookDAO" %>
<%-- 【重要】引入JSTL --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Borrow Books</title>
    <style>
        /* (您可以复用您项目中的 list.css 或 my_borrow.jsp 的样式) */
        body { font-family: Arial, sans-serif; }
        h2 { margin-top: 20px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
        tr:hover { background-color: #ddd; }
        td a { color: #E63946; text-decoration: none; }
        td a:hover { color: #2196F3; }
        .empty-list { color: #888; font-style: italic; }
    </style>
</head>
<body>
<%--
    重构：我们不再在JSP中编写复杂的Java逻辑。
    我们只在JSP中获取数据和显示。
--%>

<%-- 1. 获取 Session 中的学生对象 --%>
<c:set var="student" value="${sessionScope.student}" />

<%-- 2. 创建DAO实例 --%>
<jsp:useBean id="borrowDAO" class="com.demo.dao.BorrowDAO" scope="page" />
<jsp:useBean id="bookDAO" class="com.demo.dao.BookDAO" scope="page" />

<%-- 3. 调用DAO (新的 getActiveBorrowsBySId) --%>
<c:set var="borrows" value="${borrowDAO.getActiveBorrowsBySId(student.id)}" />

<div id="my_borrow" name="my_borrow" style="height: 80%;overflow-y: auto;">
    <h2>我的已借书籍 (仅显示已批准)</h2>
    <table>
        <tr>
            <td width="250px">图书名称</td>
            <td width="200px">图书作者</td>
            <td width="150px">图书类型</td>
            <td width="50px">操作</td>
        </tr>

        <c:choose>
            <c:when test="${not empty borrows}">
                <c:forEach items="${borrows}" var="borrow">
                    <%--
                       (性能提示: 此处 N+1 查询)
                       为每条借阅记录查询一次书籍详情
                    --%>
                    <c:set var="book" value="${bookDAO.getBookById(borrow.b_id)}" />
                    <tr>
                        <td>${book.name}</td>
                        <td>${book.author}</td>
                        <td>${book.category}</td>
                        <td>
                                <%-- 【修改点 3】: 链接到 ReturnServlet 并传递 borrow_id --%>
                            <a href="../returnServlet?borrow_id=${borrow.id}"
                               onclick="return confirm('确定要归还《${book.name}》吗？');">还书</a>
                        </td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="4" class="empty-list">您当前没有已借阅的书籍。</td>
                </tr>
            </c:otherwise>
        </c:choose>
    </table>
</div>
</body>
</html>