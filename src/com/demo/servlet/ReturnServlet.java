package com.demo.servlet;

import com.demo.dao.BorrowDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(urlPatterns = "/returnServlet")
public class ReturnServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		// --- 【重要】安全检查：确保学生已登录 ---
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("s_user") == null) {
			response.getWriter().println("<script>alert('您尚未登录，请先登录！');" +
					"window.location.href='" + request.getContextPath() + "/login.jsp';" +
					"</script>");
			return;
		}
		// --- 安全检查结束 ---

		// 新逻辑：我们只需要借阅记录的ID (borrow_id)
		int borrow_id = Integer.parseInt(request.getParameter("borrow_id"));
		BorrowDAO bo_dao = new BorrowDAO();

		try {
			if (bo_dao.returnBook(borrow_id)) {
				response.getWriter().println("<script>" +
						"alert('归还图书成功!!!');" +
						"window.location.href='user/my_borrow.jsp';" +
						"</script>");
			} else {
				throw new Exception("还书失败");
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.getWriter().println("<script>" +
					"alert('归还图书失败!!! 异常：" + e.getMessage() + "');" +
					"window.location.href='user/my_borrow.jsp';" +
					"</script>");
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
}