package model;

public class CartsModel {

	private String userId;
	private String productId;
	private int quantity;

	// Constructors
	public CartsModel() {
	}

	public CartsModel(String userId, String productId, int quantity) {
		this.userId = userId;
		this.productId = productId;
		this.quantity = quantity;
	}

	// Getters and Setters
	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getProductId() {
		return productId;
	}

	public void setProductId(String productId) {
		this.productId = productId;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
}
