<%-- 
    Document   : list_all
    Created on : 19/11/2024, 11:14:09 p. m.
    Author     : renejk
--%>

<%@page import="java.util.List"%>
<%@page import ="Domain.Model.Event"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Lista de Todos los Eventos</title>
    </head>
    <body>
        <h1>Lista de Todos los Eventos</h1>

        <%-- Mensaje de error o de éxito --%>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <p style="color:red"><%= request.getAttribute("errorMessage") %></p>
        <% } else if (request.getAttribute("successMessage") != null) { %>
            <p style="color:green"><%= request.getAttribute("successMessage") %></p>
        <% } %>

        <%-- obtener el id del usuario --%>
        <%
            String userId = (String) request.getAttribute("id");
        %>

        <%-- Tabla para mostrar la lista de eventos --%>
        <table border="1">
            <tr>
                <th>ID</th>
                <th>Nombre</th>
                <th>Asistentes</th>
                <th>Fecha</th>              
                <th>Acciones</th>
            </tr>
            <%
                List<Event> events = (List<Event>) request.getAttribute("events");
                for (Event event : events) {
            %>
            <tr>
                <td><%= event.getId() %></td>
                <td><%= event.getName() %></td>
                <td><%= event.getAttendees() %></td>
                <td><%= event.getEventDate() %></td>                
                <td>
                    <a href="<%= request.getContextPath() %>/Controllers/EventController.jsp?action=showFindForm&id=<%= event.getId() %>">Editar</a>
                    <a href="<%= request.getContextPath() %>/Controllers/EventController.jsp?action=deletefl&id=<%= event.getId() %>">Eliminar</a>
                </td>
            </tr>
            <%
                }
            %>
        </table>

        <br>
        <a href="<%= request.getContextPath() %>/Controllers/EventController.jsp?action=showCreateForm&id=<%= userId %>">Crear nuevo evento</a>
    </body>
</html>
