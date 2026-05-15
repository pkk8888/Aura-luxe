package controller.servlet;

import dao.ProductDao;
import model.ProductModel;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.UUID;

@MultipartConfig(
    maxFileSize    = 5242880,   // 5MB max file size
    maxRequestSize = 10485760,  // 10MB max request size
    fileSizeThreshold = 1048576 // 1MB threshold before writing to disk
)
public class AdminProductsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final ProductDao productDAO = new ProductDao();

    // ── GET: list all products / handle edit & delete ─────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (!isAdmin(session)) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        // Load a single product into the form for editing
        if ("edit".equals(action)) {
            String productId     = request.getParameter("id");
            ProductModel product = productDAO.getProductById(productId);
            request.setAttribute("editProduct", product);
        }

        // Delete product and redirect
        if ("delete".equals(action)) {
            String productId = request.getParameter("id");
            productDAO.deleteProduct(productId);
            response.sendRedirect(request.getContextPath() + "/AdminProductsServlet?msg=deleted");
            return;
        }

        ArrayList<ProductModel> products = productDAO.getAllProducts();
        request.setAttribute("products", products);
        request.getRequestDispatcher("/pages/admin-products.jsp").forward(request, response);
    }

    // ── POST: add or update product ───────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (!isAdmin(session)) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        String action      = request.getParameter("action");
        String productId   = request.getParameter("productId");
        String productName = request.getParameter("productName");
        String category    = request.getParameter("category");
        String shade       = request.getParameter("shade");
        String brand       = request.getParameter("brand");
        String features    = request.getParameter("features");
        String netWeight   = request.getParameter("netWeight");
        String shelfLife   = request.getParameter("shelfLife");
        String priceStr    = request.getParameter("price");

        double price = 0;
        try { price = Double.parseDouble(priceStr); } catch (Exception e) {}

        // ── Handle image upload ───────────────────────────────────
        String imageName = request.getParameter("existingImage"); // keep old image by default

        Part imagePart = request.getPart("image");
        if (imagePart != null && imagePart.getSize() > 0
                && imagePart.getSubmittedFileName() != null
                && !imagePart.getSubmittedFileName().trim().isEmpty()) {

            String originalName = imagePart.getSubmittedFileName();
            String ext = originalName.substring(originalName.lastIndexOf('.'));
            imageName  = UUID.randomUUID().toString().replace("-", "").substring(0, 8) + ext;

            // Save to webapp/images/
            String uploadPath = getServletContext().getRealPath("/images/");
            File   uploadDir  = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            try (InputStream is = imagePart.getInputStream()) {
                Files.copy(is, new File(uploadDir, imageName).toPath(),
                           StandardCopyOption.REPLACE_EXISTING);
            }
        }

        // ── Build ProductModel ────────────────────────────────────
        ProductModel product = new ProductModel();
        product.setProductName(productName);
        product.setCategory(category);
        product.setShade(shade);
        product.setBrand(brand);
        product.setFeatures(features);
        product.setNetWeight(netWeight);
        product.setShelfLife(shelfLife);
        product.setPrice(price);
        product.setImage(imageName);

        if ("add".equals(action)) {
            // Generate unique product ID
            String newId = "PRD-" + UUID.randomUUID().toString()
                                        .replace("-", "")
                                        .substring(0, 8)
                                        .toUpperCase();
            product.setProductId(newId);
            productDAO.insertProduct(product);
            response.sendRedirect(request.getContextPath() + "/AdminProductsServlet?msg=added");

        } else if ("update".equals(action)) {
            product.setProductId(productId);
            productDAO.updateProduct(product);
            response.sendRedirect(request.getContextPath() + "/AdminProductsServlet?msg=updated");

        } else {
            response.sendRedirect(request.getContextPath() + "/AdminProductsServlet");
        }
    }

    private boolean isAdmin(HttpSession session) {
        if (session == null) return false;
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        return Boolean.TRUE.equals(isAdmin);
    }
}
