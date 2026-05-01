package model;

public class OrdersModel {

	private String orderId;
	private String userId;
	private String status;
	private String deliveryAddress;
	private String paymentMethod;
	private double totalAmount;

	// Constructors
	public OrdersModel() {
	}

	public OrdersModel(String orderId, String userId, String status,
			String deliveryAddress, String paymentMethod, double totalAmount) {
		this.orderId = orderId;
		this.userId = userId;
		this.status = status;
		this.deliveryAddress = deliveryAddress;
		this.paymentMethod = paymentMethod;
		this.totalAmount = totalAmount;
	}

	// Getters and Setters
	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getDeliveryAddress() {
		return deliveryAddress;
	}

	public void setDeliveryAddress(String deliveryAddress) {
		this.deliveryAddress = deliveryAddress;
	}

	public String getPaymentMethod() {
		return paymentMethod;
	}

	public void setPaymentMethod(String paymentMethod) {
		this.paymentMethod = paymentMethod;
	}

	public double getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(double totalAmount) {
		this.totalAmount = totalAmount;
	}
}
