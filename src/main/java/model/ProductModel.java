package model;

/**
 * ProductModel
 * Maps to the 'products' table in the database.
 */
public class ProductModel {

    private String productId;
    private String productName;
    private String category;
    private String shade;
    private String brand;
    private String features;
    private String netWeight;
    private String shelfLife;
    private double price;
    private String image;

    // ── Getters ────────────────────────────────────────────────────
    public String getProductId()   { return productId; }
    public String getProductName() { return productName; }
    public String getCategory()    { return category; }
    public String getShade()       { return shade; }
    public String getBrand()       { return brand; }
    public String getFeatures()    { return features; }
    public String getNetWeight()   { return netWeight; }
    public String getShelfLife()   { return shelfLife; }
    public double getPrice()       { return price; }
    public String getImage()       { return image; }

    // ── Setters ────────────────────────────────────────────────────
    public void setProductId(String productId)     { this.productId = productId; }
    public void setProductName(String productName) { this.productName = productName; }
    public void setCategory(String category)       { this.category = category; }
    public void setShade(String shade)             { this.shade = shade; }
    public void setBrand(String brand)             { this.brand = brand; }
    public void setFeatures(String features)       { this.features = features; }
    public void setNetWeight(String netWeight)     { this.netWeight = netWeight; }
    public void setShelfLife(String shelfLife)     { this.shelfLife = shelfLife; }
    public void setPrice(double price)             { this.price = price; }
    public void setImage(String image)             { this.image = image; }
}
