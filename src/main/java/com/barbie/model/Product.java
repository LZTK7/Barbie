package com.barbie.model;

import java.util.Date;

public class Product {
    private int id;
    private String name;
    private String images;
    private String category;
    private String style;
    private String color;
    private String season;
    private double price;
    private String description;
    private int sales;
    private int status;
    private Date createdAt;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getImages() { return images; }
    public void setImages(String images) { this.images = images; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getStyle() { return style; }
    public void setStyle(String style) { this.style = style; }
    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }
    public String getSeason() { return season; }
    public void setSeason(String season) { this.season = season; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public int getSales() { return sales; }
    public void setSales(int sales) { this.sales = sales; }
    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}