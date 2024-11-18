<%-- 
    Document   : list_all
    Created on : 18/11/2024, 1:30:05 a. m.
    Author     : renejk
--%>

<%@page import= "java.util.List"%>
<%@page import="Domain.Model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Lisa de usuarios</title>
    </head>
    <body>
        <h1>Lista de usuarios</h1>

        <%-- Mensaje de error o exito --%>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <p style="color:red"><%= request.getAttribute("errorMessage") %></p>
        <% } else if (request.getAttribute("successMessage") != null) { %>
            <p style="color:green"><%= request.getAttribute("successMessage") %></p>
        <% } %>

        <%-- Tabla para mostrar la lista de usuarios --%>
        <table border="1">
            <thead>
                <tr>

                    <th>Codigo</th>
                    <th>Apellido</th>                 
                    <th>Email</th>
                    <th>Acciones</th>
                </tr>
             </thead>
            <tbody>
                <% List<User> users = (List<User>) request.getAttribute("users"); %>
                <% if (users != null && !users.isEmpty()) { %>
                    <% for (User user : users) { %>
                        <tr>
                            <td><%= user.getId() %></td>
                            <td><%= user.getName() %></td>
                            <td>
                                <%-- Enlace mailto: para el cliente --%>
                                <a href="mailto:?cc=<%= user.getEmail() %>&subject=Solicitud de cliente&body=Hola, quiero pedir un cliente para mi empresa">
                                    <%= user.getEmail() %>
                                </a>
                            </td>
                            <td>
                                <a href="UserController.jsp?action=search&code=<%= user.getId() %>">Buscar</a>
                                <a href="UserController.jsp?action=delete&code=<%= user.getId() %>" onclick="return confirm('¿Está seguro de que desea eliminar este usuario?')">Eliminar</a>
                            </td>
                        </tr>
                    <% } %>
                <% } else { %>
                    <tr>
                        <td colspan="4">No hay usuarios registrados.</td>
                    </tr>
                <% } %>
                
            </tbody>
        </table>

        <br>

        <a href="<%= request.getContextPath() %>/Controllers/UserController.jsp?action=create">Crear nuevo usuario</a>

    </body>
</html>
