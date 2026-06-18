package com.barbie.model;

import java.util.Date;
import java.util.List;

public class Look {
    private int id;
    private int userId;
    private String name;
    private String wardrobeIds;
    private String pendingIds;
    private String scene;
    private String season;
    private Date wearDate;
    private int isFavorite;
    private Date createdAt;
    private Date updatedAt;
    private List<Wardrobe> items;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getWardrobeIds() {
        return wardrobeIds;
    }

    public void setWardrobeIds(String wardrobeIds) {
        this.wardrobeIds = wardrobeIds;
    }

    public String getPendingIds() {
        return pendingIds;
    }

    public void setPendingIds(String pendingIds) {
        this.pendingIds = pendingIds;
    }

    public String getScene() {
        return scene;
    }

    public void setScene(String scene) {
        this.scene = scene;
    }

    public String getSeason() {
        return season;
    }

    public void setSeason(String season) {
        this.season = season;
    }

    public Date getWearDate() {
        return wearDate;
    }

    public void setWearDate(Date wearDate) {
        this.wearDate = wearDate;
    }

    public int getIsFavorite() {
        return isFavorite;
    }

    public void setIsFavorite(int isFavorite) {
        this.isFavorite = isFavorite;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public List<Wardrobe> getItems() {
        return items;
    }

    public void setItems(List<Wardrobe> items) {
        this.items = items;
    }
}