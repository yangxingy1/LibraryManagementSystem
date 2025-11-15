package com.demo.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import com.demo.javabean.*;

public class StudentDAO {
    DBAccess db;

    public boolean valid(String username, String password) {
        boolean isValid = false;
        db = new DBAccess();
        if (db.createConn()) {
            String sql = "SELECT * FROM students WHERE user = ? AND password = ?";
            try {
                db.pre = db.getConn().prepareStatement(sql);
                db.pre.setString(1, username);
                db.pre.setString(2, password);
                db.setRs(db.pre.executeQuery());
                if (db.getRs().next()) {
                    isValid = true;
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                db.closeRs();
                if (db.pre != null)
                    try {
                        db.pre.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                db.closeConn();
            }
        }
        return isValid;
    }

    public boolean isExist(String username) {
        boolean isExist = false;
        db = new DBAccess();
        if (db.createConn()) {
            String sql = "SELECT * FROM students WHERE user = ?";
            try {
                db.pre = db.getConn().prepareStatement(sql);
                db.pre.setString(1, username);
                db.setRs(db.pre.executeQuery());
                if (db.getRs().next()) {
                    isExist = true;
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                db.closeRs();
                if (db.pre != null) {
                    try {
                        db.pre.close();
                    } catch (Exception e2) {
                    }
                }
                db.closeConn();
            }
        }
        return isExist;
    }

    public boolean add(Students student) throws Exception {
        boolean flag = false;
        db = new DBAccess();
        String sql = "INSERT INTO students(id, user, password, name, grade, classes, email, amount, is_locked) VALUES(?,?,?,?,?,?,?,?,?)";
        if (db.createConn()) {
            db.pre = db.getConn().prepareStatement(sql);
            db.pre.setInt(1, student.getId());
            db.pre.setString(2, student.getUser());
            db.pre.setString(3, student.getPassword());
            db.pre.setString(4, student.getName());
            db.pre.setString(5, student.getGrade());
            db.pre.setString(6, student.getClasses());
            db.pre.setString(7, student.getEmail());
            db.pre.setInt(8, student.getAmount());
            db.pre.setInt(9, student.getIsLocked()); // ✅ 新增 is_locked
            if (db.pre.executeUpdate() > 0)
                flag = true;
        }
        db.closeRs();
        db.closeStm();
        db.pre.close();
        db.closeConn();
        return flag;
    }

    public void del(String usename) {
        DBAccess db = new DBAccess();
        if (db.createConn()) {
            String sql = "DELETE FROM students WHERE user = '" + usename + "'";
            db.update(sql);
            db.closeStm();
            db.closeConn();
        }
    }

    private Students student = null;

    public ArrayList<Students> getAllStudents() throws Exception {
        DBAccess db = new DBAccess();
        ArrayList<Students> students = new ArrayList<Students>();
        String sql = "SELECT * FROM students";
        if (db.createConn()) {
            db.query(sql);
            while (db.getRs().next()) {
                student = this.assemble(db.getRs());
                students.add(student);
            }
            db.closeStm();
            db.closeRs();
            db.closeConn();
        }
        return students;
    }

    public Students assemble(ResultSet rs) throws Exception {
        student = new Students();
        student.setId(rs.getInt("id"));
        student.setUser(rs.getString("user"));
        student.setPassword(rs.getString("password"));
        student.setName(rs.getString("name"));
        student.setGrade(rs.getString("grade"));
        student.setClasses(rs.getString("classes"));
        student.setEmail(rs.getString("email"));
        student.setAmount(rs.getInt("amount"));
        student.setIsLocked(rs.getInt("is_locked")); // ✅ 确保读取 is_locked
        return student;
    }

    public boolean delStudentByName(String user) throws Exception {
        DBAccess db = new DBAccess();
        boolean flag = false;
        String sql = "DELETE FROM students WHERE user = ?";
        if (db.createConn()) {
            db.pre = db.getConn().prepareStatement(sql);
            db.pre.setString(1, user);
            if (db.pre.executeUpdate() > 0)
                flag = true;
        }
        db.closeConn();
        db.closeStm();
        db.pre.close();
        db.closeRs();
        return flag;
    }

    public Students getStudentById(int id) throws Exception {
        DBAccess db = new DBAccess();
        String sql = "SELECT * FROM students WHERE id = ?";
        java.sql.PreparedStatement pre = null;
        if (db.createConn()) {
            pre = db.getConn().prepareStatement(sql);
            pre.setInt(1, id);
            db.setRs(pre.executeQuery());
            if (db.getRs().next())
                student = this.assemble(db.getRs());
        }
        db.closeRs();
        db.closeStm();
        pre.close();
        db.closeConn();
        return student;
    }

    public boolean updateStudent(Students student) throws Exception {
        boolean flag = false;
        DBAccess db = new DBAccess();
        String sql = "UPDATE students SET amount = ? WHERE id = ?";
        java.sql.PreparedStatement pre = null;
        if (db.createConn()) {
            pre = db.getConn().prepareStatement(sql);
            pre.setInt(1, student.getAmount());
            pre.setInt(2, student.getId());

            if (pre.executeUpdate() > 0)
                flag = true;
        }
        db.closeRs();
        pre.close();
        db.closeStm();
        db.closeConn();
        return flag;
    }

    public Students getStudentByName(String name) throws Exception {
        DBAccess db = new DBAccess();
        String sql = "SELECT * FROM students WHERE user = ?";
        java.sql.PreparedStatement pre = null;
        if (db.createConn()) {
            pre = db.getConn().prepareStatement(sql);
            pre.setString(1, name);
            db.setRs(pre.executeQuery());
            if (db.getRs().next())
                student = this.assemble(db.getRs());
        }
        db.closeRs();
        db.closeStm();
        pre.close();
        db.closeConn();
        return student;
    }

    // ✅ 修复后的 findAll 方法（关键！）
    public ArrayList<Students> findAll(Integer page, String user, String name) {
        DBAccess db = new DBAccess();
        ArrayList<Students> list = new ArrayList<Students>();

        try {
            if (db.createConn()) {
                // ✅ 使用 SELECT * 确保包含 is_locked 字段
                StringBuilder sql = new StringBuilder("SELECT * FROM students WHERE 1=1");
                if (user != null && !user.isEmpty()) {
                    sql.append(" AND user = ?");
                }
                if (name != null && !name.isEmpty()) {
                    sql.append(" AND name LIKE ?");
                }
                sql.append(" LIMIT ?,?");

                db.pre = db.getConn().prepareStatement(sql.toString());
                int index = 1;
                if (user != null && !user.isEmpty()) {
                    db.pre.setString(index++, user);
                }
                if (name != null && !name.isEmpty()) {
                    db.pre.setString(index++, "%" + name + "%");
                }
                db.pre.setInt(index++, (page - 1) * Students.PAGE_SIZE);
                db.pre.setInt(index, Students.PAGE_SIZE);

                db.setRs(db.pre.executeQuery());
                while (db.getRs().next()) {
                    // ✅ 复用 assemble 方法，自动包含 is_locked
                    Students stu = this.assemble(db.getRs());
                    list.add(stu);
                }
                db.closeRs();
                db.pre.close();
                db.closeConn();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public int countPage() {
        DBAccess db = new DBAccess();
        int count = 0;
        try {
            if (db.createConn()) {
                String sql = "SELECT COUNT(*) FROM students";
                db.pre = db.getConn().prepareStatement(sql);
                db.setRs(db.pre.executeQuery());
                if (db.getRs().next()) {
                    count = db.getRs().getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.closeRs();
            try {
                if (db.pre != null) {
                    db.pre.close();
                }
            } catch (Exception e2) {
                // TODO: handle exception
            }
            db.closeConn();
        }
        return count;
    }

    /**
     * 锁定或解锁学生账号
     */
    public boolean updateLockStatus(int id, int isLocked) {
        DBAccess db = new DBAccess();
        boolean flag = false;
        String sql = "UPDATE students SET is_locked = ? WHERE id = ?";
        if (db.createConn()) {
            try {
                db.pre = db.getConn().prepareStatement(sql);
                db.pre.setInt(1, isLocked);
                db.pre.setInt(2, id);
                if (db.pre.executeUpdate() > 0) {
                    flag = true;
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                try {
                    if (db.pre != null)
                        db.pre.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                db.closeConn();
            }
        }
        return flag;
    }

    /**
     * 重置学生密码
     */
    public boolean resetPassword(int id, String newPassword) {
        DBAccess db = new DBAccess();
        boolean flag = false;
        String sql = "UPDATE students SET password = ? WHERE id = ?";
        if (db.createConn()) {
            try {
                db.pre = db.getConn().prepareStatement(sql);
                db.pre.setString(1, newPassword);
                db.pre.setInt(2, id);
                if (db.pre.executeUpdate() > 0) {
                    flag = true;
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                try {
                    if (db.pre != null)
                        db.pre.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                db.closeConn();
            }
        }
        return flag;
    }
}