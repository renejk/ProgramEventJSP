<%-- 
    Document   : UserController
    Created on : 18/11/2024, 2:30:30 a. m.
    Author     : renejk
--%>

<%@page import="java.util.List"%>
<%@page import="java.sql.SQLException"%>
<%@page import="Business.Exceptions.DuplicatedUserException"%>
<%@page import="java.io.IOException"%>
<%@page import=" jakarta.servlet.ServletException"%>
<%@page import=" jakarta.servlet.http.HttpServletRequest"%>
<%@page import=" jakarta.servlet.http.HttpServletResponse"%>
<%@page import=" jakarta.servlet.http.HttpSession"%>
<%@page import="Business.Services.UserService"%>
<%@page import="Domain.Model.User"%>
<%@page import="Business.Exceptions.UserNotFoundException"%>

<%
    UserService userService = new UserService();
    String action = request.getParameter("action");

    if (action == null) {
        action = "list";
    }

    switch (action) {
        case "login":
            handleLogin(request, response);
            break;
        case "authenticate":
            handleAuthenticate(request, response);
            break;
        case "showCreateForm":
            showCreateForm(request, response);
            break;
        case "create":
            handleCreateUser(request, response);
            break;
        case "showFindForm":
            showFindForm(request, response);
            break;
        case "search":
            handleSearch(request, response);
            break;
        case "update":
            handleUpdateUser(request, response);
            break;
        case "delete":
            handleDeleteUser(request, response);
            break;
        case "deletefl":
            handleDeleteUserFromList(request, response);
            break;
        case "listAll":
            handleListAllUsers(request, response);
            break;
        case "logout":
            handleLogout(request, response);
            break;
        default:
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            break;
            
    }
%>

<%!
    // Metodo para mostrar el formulario de login
    private void handleLogin(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws ServletException, IOException {
        session.invalidate();
        response.sendRedirect(request.getContextPath() + "/Views/Forms/Users/login.jsp");
    }

    // Metodo para autenticar el usuario
    private void handleAuthenticate(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            User loggedInUser = userService.loginUser(email, password);
            session.setAttribute("loggedInUser", loggedInUser);
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }catch (UserNotFoundException e) {
            request.setAttribute("errorMessage", e.getMessage());
            response.getRequestDispatcher("/Views/Forms/Users/login.jsp").forward(request, response);
        }catch (SqlException e) {
            request.setAttribute("errorMessage", "Error de conexión con la base de datos Intentelo de nuevo más tarde.");
            response.getRequestDispatcher("/Views/Forms/Users/login.jsp").forward(request, response);
        }
           
    }

    // Metodo para mostrar el formulario de creación de usuario
    private void showCreateUserForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/Views/Forms/Users/create.jsp");
    }

    // Metodo para crear un nuevo usuario (despues de enviar el formulario)
    private void handleCreateUser(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");        

        try {          
            userService.createUser(name, email, password);
            session.setAttribute("successMessage", "Usuario creado exitosamente.");
            handleListAllUsers(request, response, userService);
            
        } catch (DuplicatedUserException e) {
            request.setAttribute("errorMessage", e.getMessage());
            response.getRequestDispatcher("/Views/Forms/Users/create.jsp").forward(request, response);
        } catch (SqlException e) {
            request.setAttribute("errorMessage", "Error de conexión con la base de datos Intentelo de nuevo más tarde.");
            response.getRequestDispatcher("/Views/Forms/Users/create.jsp").forward(request, response);
        }
    }

    // Metodo para mostrar el formulario para editar un usuario
    private void showFindForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
    }

    // Metodo para buscar un usuario
    private void handleSearch(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws ServletException, IOException {
        String code = request.getParameter("code");
       
       try {
           User user = userService.getUserByCode(code);
           session.setAttribute("searchedUser", user);
           response.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
       } catch (UserNotFoundException e) {
           request.setAttribute("errorMessage", e.getMessage());
           response.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
       } catch (SqlException e) {
           request.setAttribute("errorMessage", "Error de conexión con la base de datos Intentelo de nuevo más tarde.");
           response.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
       }
    }

    // Mostrar el formulario para editar un usuario
    private void showEditUserForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String code = request.getParameter("code");

         try {
           User user = userService.getUserByCode(code);
           session.setAttribute("userToEdit", user);
           response.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
       } catch (UserNotFoundException e) {
           request.setAttribute("errorMessage", e.getMessage());
           response.getRequestDispatcher("/Views/Forms/Users/list_all.jsp").forward(request, response);
       } catch (SqlException e) {
           request.setAttribute("errorMessage", "Error de conexión con la base de datos Intentelo de nuevo más tarde.");
           response.getRequestDispatcher("/Views/Forms/Users/list_all.jsp").forward(request, response);
       }

    }

    // Metodo para actualizar un usuario
    private void handleUpdateUser(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws ServletException, IOException {
        User searchedUser = (User) session.getAttribute("searchedUser");

        if (searchedUser == null) {
            request.setAttribute("errorMessage", "Primero debes buscar un usuario para editarlo.");
            response.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
            return;
        }

        String code = searchedUser.getId();
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            userService.updateUser(code, name, email, password);
            session.setAttribute("successMessage", "Usuario actualizado exitosamente.");
            handleListAllUsers(request, response, userService);
        } catch (UserNotFoundException e) {
            request.setAttribute("errorMessage", e.getMessage());
            response.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
        } catch (SqlException e) {
            request.setAttribute("errorMessage", "Error de conexión con la base de datos Intentelo de nuevo más tarde.");
            response.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
        }
    }

    // Metodo para eliminar un usuario desde la lista de usuarios
    private void handleDeleteUserFromList(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws ServletException, IOException {
        String code = request.getParameter("code");

        if (code == null || code.trim().isEmpty()) {
            request.setAttribute("errorMessage", "EL Código del usuario no puede estar vacío.");
            response.getRequestDispatcher("/Views/Forms/Users/list_all.jsp").forward(request, response);
            return;
        }

        try {
            userService.deleteUser(code);
            session.removeAttribute("searchedUser");
            session.setAttribute("successMessage", "Usuario eliminado exitosamente.");
            handleListAllUsers(request, response, userService);
        } catch (UserNotFoundException e) {
            request.setAttribute("errorMessage", e.getMessage());
            handleListAllUsers(request, response, userService);
        } catch (SqlException e) {
            request.setAttribute("errorMessage", "Error de conexión con la base de datos Intentelo de nuevo más tarde.");
            handleListAllUsers(request, response, userService);
        }
    }

    // Metodo para eliminar un usuario
    private void handleDeleteUser(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws ServletException, IOException {
        User searchedUser = (User) session.getAttribute("searchedUser");

        if (searchedUser == null) {
            request.setAttribute("errorMessage", "Primero debes buscar un usuario para eliminarlo.");
            response.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
            return;
        }

        String code = searchedUser.getId();

        try {
            userService.deleteUser(code);
            session.removeAttribute("searchedUser");
            session.setAttribute("successMessage", "Usuario eliminado exitosamente.");
            request.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
        } catch (UserNotFoundException e) {
            request.setAttribute("errorMessage", e.getMessage());
            response.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
        } catch (SqlException e) {
            request.setAttribute("errorMessage", "Error de conexión con la base de datos Intentelo de nuevo más tarde.");
            response.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
        }
    }

    // Metodo para listar todos los usuarios
    private void handleListAllUsers(HttpServletRequest request, HttpServletResponse response, UserService userService) throws ServletException, IOException {
       try {
           List<User> users = userService.getAllUsers();
           session.setAttribute("users", users);
           response.getRequestDispatcher("/Views/Forms/Users/list_all.jsp").forward(request, response);
       } catch (SqlException e) {
           request.setAttribute("errorMessage", "Error de conexión con la base de datos Intentelo de nuevo más tarde.");
           response.getRequestDispatcher("/Views/Forms/Users/list_all.jsp").forward(request, response);
       }    
    }

    // Metodo para cerrar la sesión
    private void handleLogout(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws ServletException, IOException {
        session.invalidate();
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }