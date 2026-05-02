package model;

public class InquiryModel {

	private String inquiryId;
	private String userId;
	private String subject;
	private String createdAt;
	private String message;

	// Constructors
	public InquiryModel() {
	}

	public InquiryModel(String inquiryId, String userId, String subject,
			String createdAt, String message) {
		this.inquiryId = inquiryId;
		this.userId = userId;
		this.subject = subject;
		this.createdAt = createdAt;
		this.message = message;
	}

	// Getters and Setters
	public String getInquiryId() {
		return inquiryId;
	}

	public void setInquiryId(String inquiryId) {
		this.inquiryId = inquiryId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getSubject() {
		return subject;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

	public String getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(String createdAt) {
		this.createdAt = createdAt;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}
}
