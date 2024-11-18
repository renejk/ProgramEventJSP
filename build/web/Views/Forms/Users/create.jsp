<%-- 
    Document   : create
    Created on : 16/11/2024, 11:27:31 p. m.
    Author     : renejk
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Agregar Usuario</title>
    </head>
    <body>
        <h1>Agregar Usuario</h1>

        <%-- Mensaje de error o de éxito --%>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <p style="color:red"><%= request.getAttribute("errorMessage") %></p>
        <% } else if (request.getAttribute("successMessage") != null) { %>
            <p style="color:green"><%= request.getAttribute("successMessage") %></p>
        <% } %>

        <%-- Formulario de creación de usuario --%>
        <form action="<%= request.getContextPath() %>/Controllers/UserController.jsp?action=create" method="post">
            <label for="code">Código:</label>
            <input type="text" name="code" id="code" required>
            <br><br>
            <label for="name">Nombre:</label>
            <input type="text" name="name" id="name" required>
            <br><br>
            <label for="email">Email:</label>
            <input type="text" name="email" id="email" required>
            <br><br>
            <label for="password">Contraseña:</label>
            <input type="password" name="password" id="password" required>
            <br><br>
            <input type="submit" value="Agregar Usuario">
        </form>

        <br>
        <a href="<%= request.getContextPath() %>/index.jsp">Menú Principal</a>
    </body>
</html>
