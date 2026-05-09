package model;

public class CartsModel {

    private String userId;
    private String productId;
    private int    quantity;

    // Fields populated from JOIN with products table in CartDAO.getCartItems()
    private String productName;
    private double price;
    private String image;

    public CartsModel() {
    }

    public CartsModel(String userId, String productId, int quantity) {
        this.userId    = userId;
        this.productId = productId;
        this.quantity  = quantity;
    }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getProductId() { return productId; }
    public void setProductId(String productId) { this.productId = productId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    // Line total — use this in JSP instead of calculating manually
    public double getLineTotal() {
        return price * quantity;
    }
}
