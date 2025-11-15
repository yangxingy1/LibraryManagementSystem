package com.demo.dao;

import com.demo.javabean.*;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class AdminDAO {
	DBAccess db;

	/**
	 * (保留) 登录验证
	 */
	public boolean valid(String username, String password) {
		boolean isValid = false;
		db = new DBAccess();
		if (db.createConn()) {
			try {
				String sql = "select * from admins where admin=? and password=?";
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
				try {
					if (db.pre != null) db.pre.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
				db.closeConn();
			}
		}
		return isValid;
	}

	/**
	 * (保留) 检查用户名是否存在
	 */
	public boolean isExist(String username) {
		boolean isExist = false;
		db = new DBAccess();
		if (db.createConn()) {
			try {
				String sql = "select * from admins where admin=?";
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
					}
				}
				db.closeConn();
			}
		}
		return isExist;
	}

	/**
	 * (新功能 - 查) 通过用户名获取管理员信息
	 */
	public Admins getAdminByUsername(String username) throws Exception {
		Admins admin = null;
		db = new DBAccess();
		if (db.createConn()) {
			try {
				String sql = "select * from admins where admin=?";
				db.pre = db.getConn().prepareStatement(sql);
				db.pre.setString(1, username);
				db.setRs(db.pre.executeQuery());
				if (db.getRs().next()) {
					admin = assemble(db.getRs());
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				db.closeRs();
				if (db.pre != null) db.pre.close();
				db.closeConn();
			}
		}
		return admin;
	}

	/**
	 * (新功能 - 增) 添加新管理员
	 */
	public boolean addAdmin(Admins admin) throws Exception {
		boolean flag = false;
		db = new DBAccess();
		// 注意：数据库 admins 表的 id 不是自增的，但其他表是。这是一个隐患。
		// 我们假设 id 也需要手动插入。
		String sql = "INSERT INTO admins (id, admin, password, realname, phone, email, address) VALUES (?, ?, ?, ?, ?, ?, ?)";
		if (db.createConn()) {
			db.pre = db.getConn().prepareStatement(sql);
			db.pre.setInt(1, admin.getId());
			db.pre.setString(2, admin.getAdmin());
			db.pre.setString(3, admin.getPassword());
			db.pre.setString(4, admin.getRealname());
			db.pre.setString(5, admin.getPhone());
			db.pre.setString(6, admin.getEmail());
			db.pre.setString(7, admin.getAddress());
			if (db.pre.executeUpdate() > 0) flag = true;
		}
		if (db.pre != null) db.pre.close();
		db.closeConn();
		return flag;
	}

	/**
	 * (新功能 - 改) 更新管理员信息 (只能改自己)
	 */
	public boolean updateAdmin(Admins admin) throws Exception {
		boolean flag = false;
		db = new DBAccess();
		String sql = "UPDATE admins SET password=?, realname=?, phone=?, email=?, address=? WHERE admin=?";
		if (db.createConn()) {
			db.pre = db.getConn().prepareStatement(sql);
			db.pre.setString(1, admin.getPassword());
			db.pre.setString(2, admin.getRealname());
			db.pre.setString(3, admin.getPhone());
			db.pre.setString(4, admin.getEmail());
			db.pre.setString(5, admin.getAddress());
			// 关键：通过 admin 用户名（或ID）来更新
			db.pre.setString(6, admin.getAdmin());
			if (db.pre.executeUpdate() > 0) flag = true;
		}
		if (db.pre != null) db.pre.close();
		db.closeConn();
		return flag;
	}

	/**
	 * (新功能 - 删) 获取除自己外的所有管理员
	 */
	public ArrayList<Admins> getAllAdminsExceptSelf(String selfUsername) throws Exception {
		ArrayList<Admins> list = new ArrayList<Admins>();
		db = new DBAccess();
		String sql = "SELECT * FROM admins WHERE admin != ?";
		if (db.createConn()) {
			db.pre = db.getConn().prepareStatement(sql);
			db.pre.setString(1, selfUsername);
			db.setRs(db.pre.executeQuery());
			while (db.getRs().next()) {
				list.add(assemble(db.getRs()));
			}
		}
		db.closeRs();
		if (db.pre != null) db.pre.close();
		db.closeConn();
		return list;
	}

	/**
	 * (新功能 - 删) 按ID删除管理员
	 */
	public boolean deleteAdmin(int adminId) throws Exception {
		boolean flag = false;
		db = new DBAccess();
		String sql = "DELETE FROM admins WHERE id = ?";
		if (db.createConn()) {
			db.pre = db.getConn().prepareStatement(sql);
			db.pre.setInt(1, adminId);
			if (db.pre.executeUpdate() > 0) flag = true;
		}
		if (db.pre != null) db.pre.close();
		db.closeConn();
		return flag;
	}

	/**
	 * (新功能) 组装 Admins 对象
	 */
	private Admins assemble(ResultSet rs) throws Exception {
		Admins admin = new Admins();
		admin.setId(rs.getInt("id"));
		admin.setAdmin(rs.getString("admin"));
		admin.setPassword(rs.getString("password"));
		admin.setRealname(rs.getString("realname"));
		admin.setPhone(rs.getString("phone"));
		admin.setEmail(rs.getString("email"));
		admin.setAddress(rs.getString("address"));
		return admin;
	}
}