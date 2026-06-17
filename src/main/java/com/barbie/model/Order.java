package com.barbie.model;

import java.util.Date;
import java.util.List;

public class Order {
    private int id;
    private int userId;
    private String orderNo;
    private double totalAmount;
    private String status;
    private String address;
    private String receiver;
    private String phone;
    private String remark;
    private Date createdAt;
    private Date updatedAt;
    private List<OrderItem> items;

    // 全部 getter 和 setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getOrderNo() { return orderNo; }
    public void setOrderNo(String orderNo) { this.orderNo = orderNo; }
    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getReceiver() { return receiver; }
    public void setReceiver(String receiver) { this.receiver = receiver; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
    public List<OrderItem> getItems() { return items; }
    public void setItems(List<OrderItem> items) { this.items = items; }
}