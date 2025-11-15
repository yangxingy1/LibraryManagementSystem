package com.demo.servlet;

import com.demo.dao.BorrowDAO;
import com.demo.javabean.Borrows;
import com.demo.javabean.Students;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;

public class MyBorrowsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // --- 【重要】安全检查：确保学生已登录 ---
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("s_user") == null || session.getAttribute("student") == null) {
            response.getWriter().println("<script>alert('您尚未登录，请先登录！');" +
                    "window.location.href='" + request.getContextPath() + "/login.jsp';" +
                    "</script>");
            return;
        }
        // --- 安全检查结束 ---

        Students student = (Students) session.getAttribute("student");
        BorrowDAO borrowDAO = new BorrowDAO();

        try {
            // (新功能) 调用我们刚创建的DAO方法
            ArrayList<Borrows> allMyBorrows = borrowDAO.getAllBorrowsBySId(student.getId());

            request.setAttribute("allMyBorrows", allMyBorrows);
            request.getRequestDispatcher("user/my_applications.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("查询借阅申请时出错", e);
        }
    }
}