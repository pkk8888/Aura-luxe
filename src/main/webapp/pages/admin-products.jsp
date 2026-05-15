<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.ProductModel" %>
<%
    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    if (!Boolean.TRUE.equals(isAdmin)) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }
    ArrayList<ProductModel> products = (ArrayList<ProductModel>) request.getAttribute("products");
    if (products == null) products = new ArrayList<>();
    ProductModel editProduct = (ProductModel) request.getAttribute("editProduct");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>AuraLuxe Admin | Products</title>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f5f0f2; color: #1a0a10; min-height: 100vh; }

        .adm-page { max-width: 1200px; margin: 36px auto; padding: 0 24px 60px; }

        /* Page header */
        .adm-head { display: flex; align-items: center; justify-content: space-between; margin-bottom: 28px; flex-wrap: wrap; gap: 12px; }
        .adm-head__title { font-size: 1.6rem; font-weight: 800; }
        .adm-head__count { background: #c0394b; color: #fff; border-radius: 50px; padding: 3px 12px; font-size: .8rem; font-weight: 700; margin-left: 10px; }
        .btn-add {
            background: linear-gradient(135deg,#7b1d36,#c0394b);
            color: #fff; border: none; border-radius: 10px;
            padding: 10px 22px; font-size: .9rem; font-weight: 600;
            cursor: pointer; text-decoration: none; transition: opacity .2s;
        }
        .btn-add:hover { opacity: .85; }

        /* Toast */
        .adm-toast { border-radius: 8px; padding: 12px 20px; margin-bottom: 20px; font-size: .9rem; font-weight: 600; }
        .adm-toast--success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .adm-toast--delete  { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

        /* Form card */
        .adm-form-card {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 2px 16px rgba(26,10,16,.08);
            padding: 28px 32px;
            margin-bottom: 32px;
        }
        .adm-form-card__title { font-size: 1.1rem; font-weight: 800; margin-bottom: 22px; padding-bottom: 12px; border-bottom: 1.5px solid #f0e8eb; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-group--full { grid-column: 1 / -1; }
        label { font-size: .82rem; font-weight: 600; color: #5c1a2e; }
        input[type=text], input[type=number], input[type=file], textarea, select {
            border: 1.5px solid #e0cdd2; border-radius: 8px;
            padding: 9px 13px; font-size: .88rem; color: #1a0a10;
            background: #fff; width: 100%; transition: border-color .2s;
            font-family: inherit;
        }
        input:focus, textarea:focus, select:focus { outline: none; border-color: #c0394b; }
        textarea { resize: vertical; min-height: 80px; }

        .form-actions { display: flex; gap: 12px; margin-top: 20px; }
        .btn-submit {
            background: linear-gradient(135deg,#7b1d36,#c0394b);
            color: #fff; border: none; border-radius: 10px;
            padding: 10px 28px; font-size: .9rem; font-weight: 600;
            cursor: pointer; transition: opacity .2s;
        }
        .btn-submit:hover { opacity: .85; }
        .btn-cancel {
            background: #f0e8eb; color: #5c1a2e; border: none;
            border-radius: 10px; padding: 10px 22px;
            font-size: .9rem; font-weight: 600; cursor: pointer;
            text-decoration: none; transition: background .2s;
        }
        .btn-cancel:hover { background: #e0cdd2; }

        /* Table */
        .adm-table-wrap { background: #fff; border-radius: 16px; box-shadow: 0 2px 16px rgba(26,10,16,.08); overflow: hidden; }
        table { width: 100%; border-collapse: collapse; }
        thead { background: linear-gradient(135deg, #2a0d17, #5c1a2e); color: #fff; }
        thead th { padding: 14px 16px; font-size: .82rem; font-weight: 600; text-align: left; letter-spacing: .4px; text-transform: uppercase; }
        tbody tr { border-bottom: 1px solid #f0e8eb; transition: background .15s; }
        tbody tr:last-child { border-bottom: none; }
        tbody tr:hover { background: #fdf6f8; }
        tbody td { padding: 12px 16px; font-size: .87rem; vertical-align: middle; }

        .prod-img {
            width: 52px; height: 52px; border-radius: 10px;
            object-fit: cover; border: 1px solid #f0dce3;
        }
        .prod-name { font-weight: 700; margin-bottom: 2px; }
        .prod-brand { font-size: .78rem; color: #8a5060; }
        .prod-price { font-weight: 700; color: #2a0d17; }

        /* Action buttons */
        .btn-edit {
            background: #fff3cd; color: #856404; border: 1px solid #ffeeba;
            border-radius: 7px; padding: 5px 13px; font-size: .78rem;
            font-weight: 600; cursor: pointer; text-decoration: none;
            transition: background .2s; display: inline-block;
        }
        .btn-edit:hover { background: #ffeeba; }
        .btn-delete {
            background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb;
            border-radius: 7px; padding: 5px 13px; font-size: .78rem;
            font-weight: 600; cursor: pointer; text-decoration: none;
            transition: background .2s; display: inline-block; margin-left: 6px;
        }
        .btn-delete:hover { background: #f5c6cb; }

        /* Empty */
        .adm-empty { text-align: center; padding: 60px 20px; color: #8a5060; }
        .adm-empty__icon { font-size: 3rem; margin-bottom: 12px; }

        @media (max-width: 700px) {
            .form-grid { grid-template-columns: 1fr; }
            .form-group--full { grid-column: 1; }
            thead th:nth-child(4), tbody td:nth-child(4),
            thead th:nth-child(5), tbody td:nth-child(5) { display: none; }
        }
    </style>
</head>
<body>

<jsp:include page="/components/admin-navbar.jsp" />

<div class="adm-page">

    <div class="adm-head">
        <div>
            <span class="adm-head__title">Products</span>
            <span class="adm-head__count"><%= products.size() %></span>
        </div>
        <% if (editProduct == null) { %>
            <a href="#adm-form" class="btn-add">+ Add Product</a>
        <% } %>
    </div>

    <%-- Toast messages --%>
    <% if ("added".equals(msg)) { %>
        <div class="adm-toast adm-toast--success">✅ Product added successfully.</div>
    <% } else if ("updated".equals(msg)) { %>
        <div class="adm-toast adm-toast--success">✅ Product updated successfully.</div>
    <% } else if ("deleted".equals(msg)) { %>
        <div class="adm-toast adm-toast--delete">🗑️ Product deleted successfully.</div>
    <% } %>

    <%-- Add / Edit Form --%>
    <div class="adm-form-card" id="adm-form">
        <div class="adm-form-card__title">
            <%= editProduct != null ? "✏️ Edit Product" : "➕ Add New Product" %>
        </div>

        <form action="<%= request.getContextPath() %>/AdminProductsServlet"
              method="post" enctype="multipart/form-data">

            <input type="hidden" name="action" value="<%= editProduct != null ? "update" : "add" %>"/>
            <% if (editProduct != null) { %>
                <input type="hidden" name="productId" value="<%= editProduct.getProductId() %>"/>
                <input type="hidden" name="existingImage" value="<%= editProduct.getImage() %>"/>
            <% } %>

            <div class="form-grid">

                <div class="form-group">
                    <label>Product Name *</label>
                    <input type="text" name="productName" required
                           value="<%= editProduct != null ? editProduct.getProductName() : "" %>"/>
                </div>

                <div class="form-group">
                    <label>Category *</label>
                    <select name="category" required>
                        <option value="">Select category</option>
                        <% String[] cats = {"Lips", "Eyes", "Face", "Skincare", "Nails", "Tools"};
                           for (String cat : cats) {
                               boolean sel = editProduct != null && cat.equalsIgnoreCase(editProduct.getCategory()); %>
                        <option value="<%= cat %>" <%= sel ? "selected" : "" %>><%= cat %></option>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label>Brand *</label>
                    <input type="text" name="brand" required
                           value="<%= editProduct != null ? editProduct.getBrand() : "" %>"/>
                </div>

                <div class="form-group">
                    <label>Shade</label>
                    <input type="text" name="shade"
                           value="<%= editProduct != null && editProduct.getShade() != null ? editProduct.getShade() : "" %>"/>
                </div>

                <div class="form-group">
                    <label>Price (Rs) *</label>
                    <input type="number" name="price" step="0.01" min="0" required
                           value="<%= editProduct != null ? editProduct.getPrice() : "" %>"/>
                </div>

                <div class="form-group">
                    <label>Net Weight</label>
                    <input type="text" name="netWeight"
                           value="<%= editProduct != null && editProduct.getNetWeight() != null ? editProduct.getNetWeight() : "" %>"/>
                </div>

                <div class="form-group">
                    <label>Shelf Life</label>
                    <input type="text" name="shelfLife"
                           value="<%= editProduct != null && editProduct.getShelfLife() != null ? editProduct.getShelfLife() : "" %>"/>
                </div>

                <div class="form-group">
                    <label>Product Image <%= editProduct != null ? "(leave blank to keep current)" : "*" %></label>
                    <input type="file" name="image" accept="image/*"
                           <%= editProduct == null ? "required" : "" %>/>
                </div>

                <div class="form-group form-group--full">
                    <label>Features / Description</label>
                    <textarea name="features"><%= editProduct != null && editProduct.getFeatures() != null ? editProduct.getFeatures() : "" %></textarea>
                </div>

            </div>

            <div class="form-actions">
                <button type="submit" class="btn-submit">
                    <%= editProduct != null ? "Save Changes" : "Add Product" %>
                </button>
                <% if (editProduct != null) { %>
                    <a href="${pageContext.request.contextPath}/AdminProductsServlet" class="btn-cancel">Cancel</a>
                <% } %>
            </div>

        </form>
    </div>

    <%-- Products Table --%>
    <div class="adm-table-wrap">
    <% if (products.isEmpty()) { %>
        <div class="adm-empty">
            <div class="adm-empty__icon">💄</div>
            <div>No products yet. Add your first product above.</div>
        </div>
    <% } else { %>
        <table>
            <thead>
                <tr>
                    <th>Image</th>
                    <th>Product</th>
                    <th>Category</th>
                    <th>Brand</th>
                    <th>Price</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <% for (ProductModel p : products) { %>
                <tr>
                    <td>
                        <img class="prod-img"
                             src="${pageContext.request.contextPath}/images/<%= p.getImage() %>"
                             alt="<%= p.getProductName() %>"
                             onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg'"/>
                    </td>
                    <td>
                        <div class="prod-name"><%= p.getProductName() %></div>
                        <div class="prod-brand"><%= p.getShade() != null ? p.getShade() : "" %></div>
                    </td>
                    <td><%= p.getCategory() %></td>
                    <td><%= p.getBrand() %></td>
                    <td><span class="prod-price">Rs <%= String.format("%,.0f", p.getPrice()) %></span></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/AdminProductsServlet?action=edit&id=<%= p.getProductId() %>#adm-form"
                           class="btn-edit">✏️ Edit</a>
                        <a href="${pageContext.request.contextPath}/AdminProductsServlet?action=delete&id=<%= p.getProductId() %>"
                           class="btn-delete"
                           onclick="return confirm('Delete <%= p.getProductName().replace("'","") %>? This cannot be undone.')">
                           🗑️ Delete
                        </a>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
    <% } %>
    </div>

</div>
</body>
</html>
