package com.barbie.model;

import java.util.Date;

public class Wardrobe {
    private int id;
    private int userId;
    private String sourceType;
    private Integer orderItemId;
    private String name;
    private String images;
    private String category;
    private String color;
    private String season;
    private String style;
    private String brand;
    private String note;
    private int wearCount;
    private int isFrequent;
    private Date createdAt;
    private Date updatedAt;
    private Date deletedAt;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getSourceType() { return sourceType; }
    public void setSourceType(String sourceType) { this.sourceType = sourceType; }
    public Integer getOrderItemId() { return orderItemId; }
    public void setOrderItemId(Integer orderItemId) { this.orderItemId = orderItemId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getImages() { return images; }
    public void setImages(String images) { this.images = images; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }
    public String getSeason() { return season; }
    public void setSeason(String season) { this.season = season; }
    public String getStyle() { return style; }
    public void setStyle(String style) { this.style = style; }
    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public int getWearCount() { return wearCount; }
    public void setWearCount(int wearCount) { this.wearCount = wearCount; }
    public int getIsFrequent() { return isFrequent; }
    public void setIsFrequent(int isFrequent) { this.isFrequent = isFrequent; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
    public Date getDeletedAt() { return deletedAt; }
    public void setDeletedAt(Date deletedAt) { this.deletedAt = deletedAt; }
}