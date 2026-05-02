package model;

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

	// Constructors
	public ProductModel() {
	}

	public ProductModel(String productId, String productName, String category,
			String shade, String brand, String features,
			String netWeight, String shelfLife, double price, String image) {
		this.productId = productId;
		this.productName = productName;
		this.category = category;
		this.shade = shade;
		this.brand = brand;
		this.features = features;
		this.netWeight = netWeight;
		this.shelfLife = shelfLife;
		this.price = price;
		this.image = image;
	}

	// Getters and Setters
	public String getProductId() {
		return productId;
	}

	public void setProductId(String productId) {
		this.productId = productId;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getShade() {
		return shade;
	}

	public void setShade(String shade) {
		this.shade = shade;
	}

	public String getBrand() {
		return brand;
	}

	public void setBrand(String brand) {
		this.brand = brand;
	}

	public String getFeatures() {
		return features;
	}

	public void setFeatures(String features) {
		this.features = features;
	}

	public String getNetWeight() {
		return netWeight;
	}

	public void setNetWeight(String netWeight) {
		this.netWeight = netWeight;
	}

	public String getShelfLife() {
		return shelfLife;
	}

	public void setShelfLife(String shelfLife) {
		this.shelfLife = shelfLife;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}
}
