package com.demo.dao;

import com.demo.javabean.*;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class AdminDAO {
    DBAccess db;

    // 验证管理员登录
    public boolean valid(String username, String password) {
        boolean isValid = false;
        db = new DBAccess();
        if (db.createConn()) {
            try {
                String sql = "SELECT * FROM admins WHERE admin = ? AND password = ?";
                db.pre = db.getConn().prepareStatement(sql);
                db.pre.setString(1, username);
                db.pre.setString(2, password);
                db.setRs(db.pre.executeQuery());
                if (db.getRs().next()) {
                    isValid = true;
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                db.closeRs();
                if (db.pre != null) {
                    try {
                        db.pre.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
                db.closeConn();
            }
        }
        return isValid;
    }

    // 检查管理员用户名是否存在
    public boolean isExist(String username) {
        boolean isExist = false;
        db = new DBAccess();
        if (db.createConn()) {
            try {
                String sql = "SELECT * FROM admins WHERE admin = ?";
                db.pre = db.getConn().prepareStatement(sql);
                db.pre.setString(1, username);
                db.setRs(db.pre.executeQuery());
                if (db.getRs().next()) {
                    isExist = true;
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                db.closeRs();
                if (db.pre != null) {
                    try {
                        db.pre.close();
                    } catch (Exception e2) {
                        e2.printStackTrace();
                    }
                }
                db.closeConn();
            }
        }
        return isExist;
    }

    // 获取所有管理员
    public ArrayList<Admins> getAllAdmins() {
        ArrayList<Admins> list = new ArrayList<>();
        db = new DBAccess();
        String sql = "SELECT * FROM admins";
        if (db.createConn()) {
            try {
                db.pre = db.getConn().prepareStatement(sql);
                db.setRs(db.pre.executeQuery());
                while (db.getRs().next()) {
                    Admins admin = assemble(db.getRs());
                    list.add(admin);
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                db.closeRs();
                if (db.pre != null) {
                    try {
                        db.pre.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
                db.closeConn();
            }
        }
        return list;
    }

    // 根据ID获取管理员
    public Admins getAdminById(int id) {
        Admins admin = null;
        db = new DBAccess();
        String sql = "SELECT * FROM admins WHERE id = ?";
        if (db.createConn()) {
            try {
                db.pre = db.getConn().prepareStatement(sql);
                db.pre.setInt(1, id);
                db.setRs(db.pre.executeQuery());
                if (db.getRs().next()) {
                    admin = assemble(db.getRs());
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                db.closeRs();
                if (db.pre != null) {
                    try {
                        db.pre.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
                db.closeConn();
            }
        }
        return admin;
    }

    // 添加管理员
    public boolean addAdmin(Admins admin) {
        boolean flag = false;
        db = new DBAccess();
        // ✅ 确保字段与数据库一致（包含 is_locked）
        String sql = "INSERT INTO admins(admin, password, realname, phone, email, address, is_locked) VALUES(?,?,?,?,?,?,?)";
        if (db.createConn()) {
            try {
                db.pre = db.getConn().prepareStatement(sql);
                db.pre.setString(1, admin.getAdmin());
                db.pre.setString(2, admin.getPassword());
                db.pre.setString(3, admin.getRealname());
                db.pre.setString(4, admin.getPhone());
                db.pre.setString(5, admin.getEmail());
                db.pre.setString(6, admin.getAddress());
                db.pre.setInt(7, admin.getIsLocked());
                int rows = db.pre.executeUpdate();
                flag = (rows > 0);
            } catch (Exception e) {
                e.printStackTrace(); // 👈 确保异常可见
            } finally {
                db.closeRs();
                if (db.pre != null) {
                    try {
                        db.pre.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
                db.closeConn();
            }
        }
        return flag;
    }

    // 更新管理员
    public boolean updateAdmin(Admins admin) {
        boolean flag = false;
        db = new DBAccess();
        String sql = "UPDATE admins SET admin=?, password=?, realname=?, phone=?, email=?, address=?, is_locked=? WHERE id=?";
        if (db.createConn()) {
            try {
                db.pre = db.getConn().prepareStatement(sql);
                db.pre.setString(1, admin.getAdmin());
                db.pre.setString(2, admin.getPassword());
                db.pre.setString(3, admin.getRealname());
                db.pre.setString(4, admin.getPhone());
                db.pre.setString(5, admin.getEmail());
                db.pre.setString(6, admin.getAddress());
                db.pre.setInt(7, admin.getIsLocked());
                db.pre.setInt(8, admin.getId());
                int rows = db.pre.executeUpdate();
                flag = (rows > 0);
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                db.closeRs();
                if (db.pre != null) {
                    try {
                        db.pre.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
                db.closeConn();
            }
        }
        return flag;
    }

    // 删除管理员
    public boolean deleteAdmin(int id) {
        boolean flag = false;
        db = new DBAccess();
        String sql = "DELETE FROM admins WHERE id = ?";
        if (db.createConn()) {
            try {
                db.pre = db.getConn().prepareStatement(sql);
                db.pre.setInt(1, id);
                int rows = db.pre.executeUpdate();
                flag = (rows > 0);
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                db.closeRs();
                if (db.pre != null) {
                    try {
                        db.pre.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
                db.closeConn();
            }
        }
        return flag;
    }

    // 组装 Admins 对象
    private Admins assemble(ResultSet rs) throws Exception {
        Admins admin = new Admins();
        admin.setId(rs.getInt("id"));
        admin.setAdmin(rs.getString("admin"));
        admin.setPassword(rs.getString("password"));
        admin.setRealname(rs.getString("realname"));
        admin.setPhone(rs.getString("phone"));
        admin.setEmail(rs.getString("email"));
        admin.setAddress(rs.getString("address"));
        admin.setIsLocked(rs.getInt("is_locked")); // ✅ 确保读取 is_locked
        return admin;
    }
}