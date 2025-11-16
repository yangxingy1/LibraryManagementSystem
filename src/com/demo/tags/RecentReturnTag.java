package com.demo.tags;

import com.demo.dao.BorrowDAO;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.SimpleTagSupport;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 标签 2: 显示用户最近的还书日期
 */
public class RecentReturnTag extends SimpleTagSupport {

    // (新功能) 接收来自 JSP 的 "userId" 属性
    private int userId;

    public void setUserId(int userId) {
        this.userId = userId;
    }

    @Override
    public void doTag() throws JspException, IOException {
        BorrowDAO dao = new BorrowDAO();
        JspWriter out = getJspContext().getOut();
        try {
            Date recentDate = dao.getMostRecentReturnDate(this.userId);

            if (recentDate != null) {
                // 如果找到了日期，格式化它
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                out.print(sdf.format(recentDate));
            } else {
                // 如果该用户从未还过书
                out.print("暂无还书记录");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("Error");
        }
    }
}