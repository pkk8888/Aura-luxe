package model;

public class OrderProductsModel {

    private String orderId;
    private String productId;
    private int    quantity;
    private double unitPrice;

    // Fields populated from JOIN with products table in OrderDAO.getOrderItems()
    private String productName;
    private String image;

    public OrderProductsModel() {
    }

    public OrderProductsModel(String orderId, String productId, int quantity, double unitPrice) {
        this.orderId   = orderId;
        this.productId = productId;
        this.quantity  = quantity;
        this.unitPrice = unitPrice;
    }

    public String getOrderId() { return orderId; }
    public void setOrderId(String orderId) { this.orderId = orderId; }

    public String getProductId() { return productId; }
    public void setProductId(String productId) { this.productId = productId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(double unitPrice) { this.unitPrice = unitPrice; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    // Line total for this item
    public double getLineTotal() {
        return unitPrice * quantity;
    }
}
