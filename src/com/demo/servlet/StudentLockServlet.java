package com.demo.servlet;

import com.demo.dao.StudentDAO;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class StudentLockServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // (LoginFilter 已保护此 Servlet，无需手动检查 "a_user")

        try {
            int s_id = Integer.parseInt(request.getParameter("s_id"));
            // "isLocked" 复选框如果被勾选, 会发送 "true" (或 "on")。如果未勾选, 不会发送, 导致 null。
            boolean isLocked = "true".equals(request.getParameter("isLocked"));

            StudentDAO studentDAO = new StudentDAO();
            studentDAO.setAccountLockStatus(s_id, isLocked);

            // 成功响应 (用于 AJAX)
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": true, \"newState\": " + isLocked + "}");

        } catch (Exception e) {
            e.printStackTrace();
            // 失败响应 (用于 AJAX)
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        }
    }
}