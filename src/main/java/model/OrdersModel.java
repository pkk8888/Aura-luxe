package model;

public class OrdersModel {

    private String orderId;
    private String userId;
    private String status;
    private String city;
    private String deliveryAddress;
    private String paymentMethod;
    private double totalAmount;

    // Fields populated from JOIN with users table in OrderDAO.getAllOrders()
    private String fullName;
    private String createdAt;

    public OrdersModel() {
    }

    public OrdersModel(String orderId, String userId, double totalAmount,
                       String city, String deliveryAddress, String paymentMethod) {
        this.orderId         = orderId;
        this.userId          = userId;
        this.totalAmount     = totalAmount;
        this.city            = city;
        this.deliveryAddress = deliveryAddress;
        this.paymentMethod   = paymentMethod;
    }

    public String getOrderId() { return orderId; }
    public void setOrderId(String orderId) { this.orderId = orderId; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getDeliveryAddress() { return deliveryAddress; }
    public void setDeliveryAddress(String deliveryAddress) { this.deliveryAddress = deliveryAddress; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}
