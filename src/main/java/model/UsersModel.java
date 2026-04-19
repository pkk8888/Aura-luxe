package model;

/**
 * UsersModel
 * Represents one row from the 'users' table.
 * Used to pass user data between DatabaseController and Servlets.
 */
public class UsersModel {

    private String userId;
    private String fullName;
    private String email;
    private String password;
    private String phoneNumber;
    private String role;
    private String address;
    private String imgLink;

    // ── Default constructor ────────────────────────────────────────
    public UsersModel() {}

    // ── Constructor used during registration ───────────────────────
    public UsersModel(String userId, String fullName, String email,
                      String password, String phoneNumber, String role) {
        this.userId      = userId;
        this.fullName    = fullName;
        this.email       = email;
        this.password    = password;
        this.phoneNumber = phoneNumber;
        this.role        = role;
    }

    // ── Getters and Setters ────────────────────────────────────────

    public String getUserId()             { return userId; }
    public void   setUserId(String v)     { this.userId = v; }

    public String getFullName()           { return fullName; }
    public void   setFullName(String v)   { this.fullName = v; }

    public String getEmail()              { return email; }
    public void   setEmail(String v)      { this.email = v; }

    public String getPassword()           { return password; }
    public void   setPassword(String v)   { this.password = v; }

    public String getPhoneNumber()        { return phoneNumber; }
    public void   setPhoneNumber(String v){ this.phoneNumber = v; }

    public String getRole()               { return role; }
    public void   setRole(String v)       { this.role = v; }

    public String getAddress()            { return address; }
    public void   setAddress(String v)    { this.address = v; }

    public String getImgLink()            { return imgLink; }
    public void   setImgLink(String v)    { this.imgLink = v; }
}
