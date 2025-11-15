package com.demo.servlet;

import com.demo.dao.BorrowDAO;
import com.demo.javabean.Borrows;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

public class BorrowAdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 管理员的 Servlet 不需要我们手动检查 "a_user"，因为 web.xml 中的 LoginFilter 已经完成了

        String action = request.getParameter("action");
        if (action == null) {
            action = "listPending"; // 默认操作
        }

        BorrowDAO borrowDAO = new BorrowDAO();
        PrintWriter out = response.getWriter();

        try {
            switch (action) {
                case "listPending":
                    // (功能1) 审批列表
                    ArrayList<Borrows> pendingList = borrowDAO.getPendingRequests();
                    request.setAttribute("pendingList", pendingList);
                    request.getRequestDispatcher("admin/pending_borrows.jsp").forward(request, response);
                    break;

                case "approve":
                    // (功能1) 批准申请
                    int approveId = Integer.parseInt(request.getParameter("borrow_id"));
                    borrowDAO.approveRequest(approveId);
                    // 批准后重定向回列表
                    response.sendRedirect("borrowAdminServlet.do?action=listPending");
                    break;

                case "deny":
                    // (功能1) 拒绝申请
                    int denyId = Integer.parseInt(request.getParameter("borrow_id"));
                    borrowDAO.denyRequest(denyId);
                    // 拒绝后重定向回列表
                    response.sendRedirect("borrowAdminServlet.do?action=listPending");
                    break;

                // (功能1) 的查询功能 "查阅某图书借出情况" 和 "查询借书用户信息" 可以后续在此处添加

                default:
                    out.println("无效的操作请求！");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            // 抛出错误到页面
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}