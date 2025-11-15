package com.demo.servlet;

import com.demo.dao.BookDAO;
import com.demo.dao.BorrowDAO;
import com.demo.javabean.Students;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

public class BorrowServlet extends HttpServlet {

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

		PrintWriter out = response.getWriter();

		// 从 Session 获取学生ID，这比从 request 获取更安全
		Students student = (Students) session.getAttribute("student");
		int s_id = student.getId();
		int b_id = Integer.parseInt(request.getParameter("b_id"));

		BookDAO b_dao = new BookDAO();
		BorrowDAO bo_dao = new BorrowDAO();

		try {
			// 1. 检查图书状态是否为 "在库"
			String bookStatus = b_dao.getBookStatus(b_id);
			if (!"在库".equals(bookStatus)) {
				out.println("<script>alert('提交失败：此书当前为[" + bookStatus + "]状态，不可申请！');" +
						"window.history.back();" + // 返回上一页
						"</script>");
				return;
			}

			// 2. 检查学生是否已经申请或借阅了此书
			if (bo_dao.hasPendingOrActiveRequest(s_id, b_id)) {
				out.println("<script>alert('提交失败：您已借阅或已申请此书，请勿重复操作！');" +
						"window.history.back();" +
						"</script>");
				return;
			}

			// 3. (旧逻辑检查) 检查学生借阅上限
			if(student.getAmount() >= 10){
				out.println("<script>alert('您的借阅图书已达上限(10本)，暂无法申请!');" +
						"window.history.back();" +
						"</script>");
				return;
			}

			// 4. 创建借阅申请
			if (bo_dao.createBorrowRequest(s_id, b_id)) {
				out.println("<script>" +
						"alert('借阅申请已提交，请等待管理员审批！');" +
						"window.location.href = 'userChoiceServlet.do?signal=1';" + // 刷新图书列表
						"</script>");
			} else {
				throw new Exception("创建借阅申请失败");
			}

		} catch (Exception e) {
			e.printStackTrace();
			out.println("<script>alert('操作异常，请联系管理员！');" +
					"window.history.back();" +
					"</script>");
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
}