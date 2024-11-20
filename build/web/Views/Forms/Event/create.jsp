<%-- 
    Document   : create
    Created on : 19/11/2024, 11:13:41 p. m.
    Author     : renejk
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Agregar Evento</title>
    </head>
    <body>
        <h1>Agregar Evento</h1>

        <%-- Mensaje de error o de éxito --%>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <p style="color:red"><%= request.getAttribute("errorMessage") %></p>
        <% } else if (request.getAttribute("successMessage") != null) { %>
            <p style="color:green"><%= request.getAttribute("successMessage") %></p>
        <% } %>

        <%-- Formulario de creación de evento --%>
        <form action="<%= request.getContextPath() %>/Controllers/EventController.jsp?action=create" method="post">
            <label for="name">Nombre:</label>
            <input type="text" name="name" id="name" required>
            <br><br>
            <label for="attendees">Asistentes:</label>
            <input type="number" name="attendees" id="attendees" required>
            <br><br>
            <label for="event_date">Fecha:</label>
            <input type="date" name="event_date" id="event_date" required>
            <br><br>
            <label for="user_id">Usuario:</label>
            <input type="text" name="user_id" id="user_id" required>
            <br><br>
            <input type="submit" value="Agregar Evento">
        </form>

        <br>
        <a href="<%= request.getContextPath() %>/index.jsp">Menú Principal</a>
    </body>
</html>
