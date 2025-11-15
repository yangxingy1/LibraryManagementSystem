package com.demo.dao;

import com.demo.javabean.*;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class BorrowDAO {

    DBAccess db;
    private Borrows borrow = null;

    /**
     * 组装 Borrows 对象 (已更新以匹配新表)
     */
    public Borrows assemble(ResultSet rs) throws Exception{
        borrow = new Borrows();
        borrow.setId(rs.getInt("id"));
        borrow.setS_id(rs.getInt("s_id"));
        borrow.setB_id(rs.getInt("b_id"));
        borrow.setStatus(rs.getString("status"));
        borrow.setRequest_date(rs.getTimestamp("request_date"));
        borrow.setApproval_date(rs.getTimestamp("approval_date"));
        borrow.setReturn_date(rs.getTimestamp("return_date"));
        return borrow;
    }

    /**
     * (功能3) 创建一个新的借阅申请
     */
    public boolean createBorrowRequest(int s_id, int b_id) throws Exception{
        boolean flag = false;
        db = new DBAccess();
        String sql = "INSERT INTO borrows (s_id, b_id, status) VALUES (?, ?, 'pending')";
        if(db.createConn()){
            db.pre = db.getConn().prepareStatement(sql);
            db.pre.setInt(1, s_id);
            db.pre.setInt(2, b_id);
            if(db.pre.executeUpdate() > 0)  flag = true;
        }
        if(db.pre != null) db.pre.close();
        db.closeConn();
        return flag;
    }

    /**
     * (功能3) 检查用户是否已申请或已借阅此书
     */
    public boolean hasPendingOrActiveRequest(int s_id, int b_id) throws Exception {
        boolean hasRequest = false;
        db = new DBAccess();
        String sql = "SELECT COUNT(*) AS count FROM borrows WHERE s_id = ? AND b_id = ? AND (status = 'pending' OR status = 'approved')";
        if(db.createConn()) {
            db.pre = db.getConn().prepareStatement(sql);
            db.pre.setInt(1, s_id);
            db.pre.setInt(2, b_id);
            db.setRs(db.pre.executeQuery());
            if(db.getRs().next()){
                if (db.getRs().getInt("count") > 0) {
                    hasRequest = true;
                }
            }
        }
        db.closeRs();
        if(db.pre != null) db.pre.close();
        db.closeConn();
        return hasRequest;
    }

    /**
     * (功能1) 获取所有待审批的借阅申请 (按申请顺序)
     */
    public ArrayList<Borrows> getPendingRequests() throws Exception{
        ArrayList<Borrows> borrowsList = new ArrayList<Borrows>();
        db = new DBAccess();
        // 按申请日期升序排序
        String sql = "SELECT * FROM borrows WHERE status = 'pending' ORDER BY request_date ASC";
        if(db.createConn()){
            db.pre = db.getConn().prepareStatement(sql);
            db.setRs(db.pre.executeQuery());
            while(db.getRs().next()) {
                // (性能提示: 此处 N+1 查询)
                // 为了在 admin/pending_borrows.jsp 上显示学生和书籍名称，我们在这里立即查询
                Borrows b = this.assemble(db.getRs());

                // 临时创建DAO实例来获取关联对象
                StudentDAO s_dao = new StudentDAO();
                BookDAO b_dao = new BookDAO();
                b.setStudent(s_dao.getStudentById(b.getS_id()));
                b.setBook(b_dao.getBookById(b.getB_id()));

                borrowsList.add(b);
            }
        }
        db.closeRs();
        if(db.pre != null) db.pre.close();
        db.closeConn();
        return borrowsList;
    }

    /**
     * (功能1) 批准借阅申请
     */
    public boolean approveRequest(int borrow_id) throws Exception {
        boolean flag = false;
        db = new DBAccess();
        String sqlUpdateBorrow = "UPDATE borrows SET status = 'approved', approval_date = NOW() WHERE id = ?";
        // 注意：我们必须获取 s_id 才能更新 students 表
        String sqlUpdateStudent = "UPDATE students SET amount = amount + 1 WHERE id = (SELECT s_id FROM borrows WHERE id = ?)";

        // 理想情况下，这应该是一个数据库事务
        if(db.createConn()) {
            // 1. 更新 borrows 表
            db.pre = db.getConn().prepareStatement(sqlUpdateBorrow);
            db.pre.setInt(1, borrow_id);
            int rowsAffected = db.pre.executeUpdate();
            db.pre.close(); // 关闭第一个 PreparedStatement

            if (rowsAffected > 0) {
                // 2. 更新 students 表
                db.pre = db.getConn().prepareStatement(sqlUpdateStudent);
                db.pre.setInt(1, borrow_id); // 再次使用 borrow_id
                db.pre.executeUpdate();
                flag = true;
            }
        }
        if(db.pre != null) db.pre.close();
        db.closeConn();
        return flag;
    }

    /**
     * (功能1) 拒绝借阅申请
     */
    public boolean denyRequest(int borrow_id) throws Exception {
        boolean flag = false;
        db = new DBAccess();
        String sql = "UPDATE borrows SET status = 'denied', approval_date = NOW() WHERE id = ?";
        if(db.createConn()) {
            db.pre = db.getConn().prepareStatement(sql);
            db.pre.setInt(1, borrow_id);
            if(db.pre.executeUpdate() > 0) flag = true;
        }
        if(db.pre != null) db.pre.close();
        db.closeConn();
        return flag;
    }

    /**
     * (已修改) 获取学生 *已批准* 的借阅
     */
    public ArrayList<Borrows> getActiveBorrowsBySId(int s_id) throws Exception{
        ArrayList<Borrows> borrowsList = new ArrayList<Borrows>();
        db = new DBAccess();
        String sql = "SELECT * FROM borrows WHERE s_id = ? AND status = 'approved'";
        if(db.createConn()){
            db.pre = db.getConn().prepareStatement(sql);
            db.pre.setInt(1, s_id);
            db.setRs(db.pre.executeQuery());
            while (db.getRs().next()){
                borrow = this.assemble(db.getRs());
                borrowsList.add(borrow);
            }
        }
        db.closeRs();
        if(db.pre != null) db.pre.close();
        db.closeConn();
        return borrowsList;
    }

    /**
     * (已修改) 归还图书
     */
    public boolean returnBook(int borrow_id) throws Exception {
        boolean flag = false;
        db = new DBAccess();
        String sqlUpdateBorrow = "UPDATE borrows SET status = 'returned', return_date = NOW() WHERE id = ?";
        String sqlUpdateStudent = "UPDATE students SET amount = amount - 1 WHERE id = (SELECT s_id FROM borrows WHERE id = ?)";

        // 理想情况下，这应该是一个数据库事务
        if(db.createConn()) {
            // 1. 更新 borrows 表
            db.pre = db.getConn().prepareStatement(sqlUpdateBorrow);
            db.pre.setInt(1, borrow_id);
            int rowsAffected = db.pre.executeUpdate();
            db.pre.close();

            if (rowsAffected > 0) {
                // 2. 更新 students 表
                db.pre = db.getConn().prepareStatement(sqlUpdateStudent);
                db.pre.setInt(1, borrow_id);
                db.pre.executeUpdate();
                flag = true;
            }
        }
        if(db.pre != null) db.pre.close();
        db.closeConn();
        return flag;
    }
    /**
     * 获取一个学生所有的借阅申请记录 (按申请日期倒序)
     */
    public ArrayList<Borrows> getAllBorrowsBySId(int s_id) throws Exception{
        ArrayList<Borrows> borrowsList = new ArrayList<Borrows>();
        db = new DBAccess();
        // 按申请日期倒序排序，最新的在最前面
        String sql = "SELECT * FROM borrows WHERE s_id = ? ORDER BY request_date DESC";

        if(db.createConn()){
            db.pre = db.getConn().prepareStatement(sql);
            db.pre.setInt(1, s_id);
            db.setRs(db.pre.executeQuery());

            // (性能提示: 此处 N+1 查询)
            // 为了在JSP中显示书名，我们在这里立即查询
            BookDAO b_dao = new BookDAO();

            while (db.getRs().next()){
                borrow = this.assemble(db.getRs());

                // 附加书籍信息
                borrow.setBook(b_dao.getBookById(borrow.getB_id()));

                borrowsList.add(borrow);
            }
        }
        db.closeRs();
        if(db.pre != null) db.pre.close();
        db.closeConn();
        return borrowsList;
    }
}