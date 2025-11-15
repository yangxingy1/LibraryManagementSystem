package com.demo.servlet;
//importcom.demo.dao.BookDAO;

import com.demo.dao.BookDAO;
import com.demo.javabean.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;

public class UserChoiceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("Find UserChoiceServlet doGet");
        HttpSession session1 = request.getSession(false); // false表示不创建新session
        if (session1 == null || session1.getAttribute("s_user") == null) {
            // 如果未登录 (session不存在 或 s_user不存在)
            response.getWriter().println("<script>alert('您尚未登录，请先登录！');" +
                    "window.location.href='" + request.getContextPath() + "/login.jsp';" +
                    "</script>");
            return; // 必须 return，停止后续代码执行
        }
        HttpSession session = request.getSession();
        //if(session!=null&&session.getAttribute("a_user")!=null){
        String signal = request.getParameter("signal");
        String name = request.getParameter("name");
        //Students student = (Students)session.getAttribute("student");
        int currpage = 1;
        if (request.getParameter("page") != null) {
            currpage = Integer.parseInt(request.getParameter("page"));
        }
        BookDAO b_dao = new BookDAO();
        ArrayList<Books> books;
        System.out.println("111");
        try {
            switch (signal) {
                case "1":
                    //books = null;
                    books = b_dao.findAll(currpage, name);
                    if (books.isEmpty()) {
                        System.out.println("error");
                        return;
                    } else {
                        session.setAttribute("books", books);
                    }

                    break;
                default:
                    books = b_dao.getBooksByCategory(signal, currpage);
                    session.setAttribute("books", books);
                    break;
            }
            //session.setAttribute("books",books);
            int pages;
            int count = b_dao.countPage(signal);
            //System.out.println(count);
            if (count % Students.PAGE_SIZE == 0) {
                pages = count / Students.PAGE_SIZE;
            } else {
                pages = count / Students.PAGE_SIZE + 1;
            }
            StringBuffer sb = new StringBuffer();
            for (int i = 1; i <= pages; i++) {
                if (i == currpage) {
                    sb.append('[' + "" + i + "" + ']');
                } else {
                    System.out.println("222");
                    sb.append("<a href='userChoiceServlet.do?signal=" + signal + "&page=" + i + "'>" + i + "</a>");

                }
                sb.append(" ");
            }
            request.setAttribute("bar", sb.toString());
            //response.sendRedirect("user/showBook.jsp");
            request.getRequestDispatcher("user/showBook.jsp").forward(request, response);
            return;
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}
