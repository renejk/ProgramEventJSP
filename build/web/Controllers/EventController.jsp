<%-- 
    Document   : EventController
    Created on : 19/11/2024, 10:50:34 p. m.
    Author     : renejk
--%>

<%@ page import="java.util.List"%>
<%@page import ="Domain.Model.Event"%>
<%@page import ="Domain.Model.User"%>
<%@page import ="java.sql.SQLException"%>
<%@page import="Business.Services.EventService"%>
<%@page import ="java.io.IOException"%> <!-- IMPORTACION DE IOExecption -->
<%@page import ="jakarta.servlet.ServletException"%> <!-- IMPORTACION DE servletException -->
<%@page import ="jakarta.servlet.http.HttpServletRequest"%> <!-- IMPORTACION DE httpServletRequest -->
<%@page import ="jakarta.servlet.http.HttpServletResponse"%> <!-- IMPORTACION DE httpServletResponse -->
<%@page import ="jakarta.servlet.http.HttpSession"%> <!-- IMPORTACION DE httpSession -->

<%
    EventService eventService = new EventService();
    String action = request.getParameter("action");

    if (action == null) {
        action = "list";
    }


    switch (action) {
        case "listAll":
            handleListAllEvents(request, response, session, eventService); // creado
            break;
        case "showCreateForm":
            showCreateEventForm(request, response, session, eventService); //creado
            break;
        case "create":
            handleCreateEvent(request, response, session, eventService); // creado
            break;
        case "showFindForm":
            showFindForm(request, response, session, eventService); // creado
            break;
        case "search":
            handleSearch(request, response, session, eventService); 
            break;
        case "update":
            handleUpdateEvent(request, response, session, eventService);  
            break;
        case "delete":
            handleDeleteEvent(request, response, session, eventService);
            break;
        case "deletefl":
            handleDeleteUserFormList(request, response, session, eventService);
            break;
        default:
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            break;
    }
%>

<%!

    //metodo para mostrar todos los eventos
    private void handleListAllEvents(HttpServletRequest request, HttpServletResponse response, HttpSession session, EventService eventService)
            throws ServletException, IOException {
        try {
            // String id = request.getParameter("id");
            User user = (User) session.getAttribute("searchedUser");

            List<Event> events = eventService.getEventsByUserId(user.getId());
            request.setAttribute("events", events); //Guardamos los eventos en la sesion
            request.getRequestDispatcher("/Views/Forms/Event/list_all.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Error de base de datos al listar los eventos.");
            request.getRequestDispatcher("/Views/Forms/Event/list_all.jsp").forward(request, response);
        }
    }

    // Mostrar el formulario de creacion de evento
    private void showCreateEventForm(HttpServletRequest request, HttpServletResponse response, HttpSession session, EventService eventService)
            throws ServletException, IOException {
        String userId = request.getParameter("id");
        response.sendRedirect(request.getContextPath() + "/Views/Forms/Event/create.jsp?id=" + userId);
    }

    //Metodo para crear un evento
    private void handleCreateEvent(HttpServletRequest request, HttpServletResponse response, HttpSession session, EventService eventService)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        int attendees = request.getParameter("attendees").isEmpty() ? 0 : Integer.parseInt(request.getParameter("attendees"));
        String eventDate = request.getParameter("event_date");
        String userId = request.getParameter("id");

        try {
            eventService.addEvent(new Event(name, attendees, eventDate, userId));
            request.setAttribute("successMessage", "Evento creado correctamente");
            request.getRequestDispatcher("/Views/Forms/Event/create.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Error al conectar con la base de datos. Intente nuevamente.");
            request.getRequestDispatcher("/Views/Forms/Event/create.jsp").forward(request, response);
        }
    }

        // Mostrar el formulario para editar un evento
    private void showFindForm(HttpServletRequest request, HttpServletResponse response, HttpSession session, EventService eventService)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/Views/Forms/Event/find_edit_delete.jsp");
    }

    // Metodo para buscar un evento
    private void handleSearch(HttpServletRequest request, HttpServletResponse response, HttpSession session, EventService eventService)
            throws ServletException, IOException {
        String id = request.getParameter("id");

        try {
            Event event = eventService.getEventById(id);
            session.setAttribute("searchedEvent", event); //Guardamos el evento en la sesion
            request.getRequestDispatcher("/Views/Forms/Event/find_edit_delete.jsp").forward(request, response);
        } catch (SQLException e) {
            session.removeAttribute("searchedEvent"); //Limpiamos la sesion si no se encuentra el evento
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/Views/Forms/Event/find_edit_delete.jsp").forward(request, response);
        }
    }

    // Metodo para actualizar los datos de un evento
    private void handleUpdateEvent(HttpServletRequest request, HttpServletResponse response, HttpSession session, EventService eventService)
            throws ServletException, IOException {
        Event searchedEvent = (Event) session.getAttribute("searchedEvent");

        if (searchedEvent == null) {
            request.setAttribute("errorMessage", "Primero debes buscar un evento para editar.");
            request.getRequestDispatcher("/Views/Forms/Event/find_edit_delete.jsp").forward(request, response);
            return;
        }
        String id = searchedEvent.getId(); //Usamos el id del evento buscado
        String name = request.getParameter("name") != null && !request.getParameter("name").isEmpty() ? request.getParameter("name") : searchedEvent.getName();
        int attendees = request.getParameter("attendees") != null && !request.getParameter("attendees").isEmpty() ? Integer.parseInt(request.getParameter("attendees")) : searchedEvent.getAttendees();
        String eventDate = request.getParameter("event_date") != null && !request.getParameter("event_date").isEmpty() ? request.getParameter("event_date") : searchedEvent.getEventDate();
        String userId = request.getParameter("user_id") != null && !request.getParameter("user_id").isEmpty() ? request.getParameter("user_id") : searchedEvent.getUserId();

        try {
            eventService.updateEvent(new Event(name, attendees, eventDate, userId));
            request.setAttribute("successMessage", "Evento actualizados correctamente");
            request.getRequestDispatcher("/Views/Forms/Event/find_edit_delete.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/Views/Forms/Event/find_edit_delete.jsp").forward(request, response);
        }

    }

    // Metodo para eliminar un evento
    private void handleDeleteEvent(HttpServletRequest request, HttpServletResponse response, HttpSession session, EventService eventService)
            throws ServletException, IOException {
        Event searchEvent = (Event) session.getAttribute("searchedEvent");
        if (searchEvent == null) {
            request.setAttribute("errorMessage", "Primero debes buscar un evento para eliminar.");
            request.getRequestDispatcher("/Views/Forms/Event/find_edit_delete.jsp").forward(request, response);
            return;
        }
        String id = searchEvent.getId(); //Usamos el id del evento buscado

        try {
            eventService.deleteEvent(id);
            session.removeAttribute("searchEvent");
            request.setAttribute("successMessage", "Evento eliminado");
            handleListAllEvents(request, response, session, eventService);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", e.getMessage());
            handleListAllEvents(request, response, session, eventService);
        }
    }

    //Metodo para eliminar un evento de la lista
    private void handleDeleteUserFormList(HttpServletRequest request, HttpServletResponse response, HttpSession session, EventService eventService)
            throws ServletException, IOException {
        var id = request.getParameter("id");

        if (id == null || id.trim().isEmpty()) {
            request.setAttribute("errorMessage", "El id es requerido");
            request.getRequestDispatcher("/Views/Forms/Event/list_all.jsp").forward(request, response);
            return;
        }

        try {
            eventService.deleteEvent(id);
            request.setAttribute("successMessage", "Evento eliminado correctamente");
            request.setAttribute("id", id);
            handleListAllEvents(request, response, session, eventService);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", e.getMessage());
            handleListAllEvents(request, response, session, eventService);
        }
    }

%>