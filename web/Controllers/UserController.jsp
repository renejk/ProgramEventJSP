<%-- 
    Document   : UserController
    Created on : 18/11/2024, 2:30:30 a. m.
    Author     : renejk
--%>

<%@ page import="java.util.List"%>
<%@page import="Domain.Model.User"%>
<%@page import ="java.sql.SQLException"%>
<%@page import ="Business.Exceptions.DuplicateUserException"%>
<%@page import ="java.io.IOException"%> <!-- IMPORTACION DE IOExecption -->
<%@page import ="jakarta.servlet.ServletException"%> <!-- IMPORTACION DE servletException -->
<%@page import ="jakarta.servlet.http.HttpServletRequest"%> <!-- IMPORTACION DE httpServletRequest -->
<%@page import ="jakarta.servlet.http.HttpServletResponse"%> <!-- IMPORTACION DE httpServletResponse -->
<%@page import ="jakarta.servlet.http.HttpSession"%> <!-- IMPORTACION DE httpSession -->
<%@page import ="Business.Services.UserService"%>
<%@page import ="Business.Exceptions.UserNotFoundException"%>

<%
    UserService userService = new UserService();
    String action = request.getParameter("action");

    if (action == null) {
        action = "list";
    }

    switch (action) {
        case "login":
            handleLogin(request, response, session);
            break;
        case "authenticate":
            handleAuthenticate(request, response, session, userService);
            break;
        case "showCreateForm":
            showCreateUserForm(request, response);
            break;

        case "create":
            handleCreateUser(request, response, session, userService);
            break;
        
        case "showFindForm":
            showFindForm(request, response, session, userService);
            break;
        case "search":
            handleSearch(request, response, session, userService);
            break;
        case "update":
            handleUpdateUser(request, response, session, userService);
            break;
        case "delete":
            handleDeleteUser(request, response, session, userService);
            break;
        case "deletefl":
            handleDeleteUserFormList(request, response, session, userService);
            break;
        case "listAll":
            handleListAllUsers(request, response, session, userService);
            break;
        case "logout":
            handleLogout(request, response, session);
            break;
        default:
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            break;
    }

%>
<%!
    //metodo para mostrar el formulario de login
    private void handleLogin(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        session.invalidate(); //Cerramos la sesion existente
        response.sendRedirect(request.getContextPath() + "/Views/Forms/Users/login.jsp");
    }

    //metodo para autenticar el usuario
    private void handleAuthenticate(HttpServletRequest request, HttpServletResponse response, HttpSession session, UserService userService)
            throws ServletException, IOException {
                String email = request.getParameter("email");
                String password = request.getParameter("password");
        try {
            User loggedInUser = userService.loginUser(email, password);
            session.setAttribute("loggedInUser", loggedInUser); //Guardamos el usuario en la sesion
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        } catch(UserNotFoundException e){
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/Views/Forms/Users/login.jsp").forward(request, response);
        } catch(SQLException e){
            request.setAttribute("errorMessage", "Error al conectar con la base de datos. Intente nuevamente.");
            request.getRequestDispatcher("/Views/Forms/Users/login.jsp").forward(request, response);
        }   
    }


    //Mostrar el formulario de creaci�n de usuario
    private void showCreateUserForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/Views/Forms/Users/create.jsp");
    }

    //Metodo para crear un nuevo usuario (deslues de enviar el formualio de creaci�n)
    private void handleCreateUser(HttpServletRequest request, HttpServletResponse response, HttpSession session, UserService userService)
            throws ServletException, IOException {
        String nombre = request.getParameter("nombre");
        String last_name = request.getParameter("last_name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String phone = request.getParameter("phone");
        String status = request.getParameter("status");

        try {
            userService.createUser(email, password, nombre, last_name, role, phone, status);
            request.setAttribute("successMessage", "Usuario creado correctamente");
            handleListAllUsers(request, response, session, userService);
        } catch (DuplicateUserException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/Views/Forms/Users/create.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Error al conectar con la base de datos. Intente nuevamente.");
            request.getRequestDispatcher ("/Views/Forms/Users/create.jsp").forward(request, response);
        }
    }


    //Mostrar el formulario para editar un usuario
    private void showFindForm(HttpServletRequest request, HttpServletResponse response, HttpSession session, UserService userService)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/Views/Forms/Users/find_edit_delete.jsp");
    }

    //Metodo para buscar un usuario
    private void handleSearch(HttpServletRequest request, HttpServletResponse response, HttpSession session, UserService userService)
            throws ServletException, IOException {
                String searchCode = request.getParameter("id");   

        try {
            User user = userService.getUserByCode(searchCode);
            session.setAttribute("searchUser", user); //Guardamos el usuario en la sesion
            request.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
        } catch (UserNotFoundException e) {
            session.removeAttribute("searchUser"); //Limpiamos la sesion si no se encuentra el usuario
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Error con la base de datos. Intente nuevamente.");
            request.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
        }
    }

    //Mostrar el formulario para editar un usuario
    private void showeditUserForm(HttpServletRequest request, HttpServletResponse response, HttpSession session, UserService userService)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        try {
            User user = userService.getUserByCode(id);
            session.setAttribute("userToEdit", user); //Guardamos el usuario en la sesion
            request.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
        } catch (UserNotFoundException e) {
            request.setAttribute("errorMessage", "errorMessage");   
            request.getRequestDispatcher("/Views/Forms/Users/list_all.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Error de base de datos. Intente nuevamente.");
            request.getRequestDispatcher("/Views/Forms/Users/list_all.jsp").forward(request, response);
        }       
    }

    //metodo para actualizar los datos de un usuario
    private void handleUpdateUser(HttpServletRequest request, HttpServletResponse response, HttpSession session, UserService userService)
            throws ServletException, IOException {
        User searchUser = (User) session.getAttribute("searchUser");

        if (searchUser == null) {
            request.setAttribute("errorMessage", "Primero debes buscar un usuario para editar.");
            request.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
            return;
        }
        String id =searchUser.getId(); //Usamos el id del usuario buscado
        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        

        try {
            userService.updateUser(id, password, nombre, email );
            request.setAttribute("successMessage", "Usuario actualizados correctamente");
            request.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
        } catch (UserNotFoundException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Error de base de datos.");
            request.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
        }

    }

    private void handleDeleteUserFormList(HttpServletRequest request, HttpServletResponse response, HttpSession session, UserService userService)
            throws ServletException, IOException {
        var id = request.getParameter("id");

        if (id == null ||id.trim().isEmpty()) {
            request.setAttribute("errorMessage", "El id es requerido");
            request.getRequestDispatcher("/Views/Forms/Users/list_all.jsp").forward(request, response);
            return;
        }

        try {   
            userService.deleteUser(id);
            request.setAttribute("successMessage", "Usuario eliminado correctamente");
            handleListAllUsers(request, response, session, userService);
        } catch (UserNotFoundException e) {
            request.setAttribute("errorMessage", e.getMessage());
            handleListAllUsers(request, response,session, userService);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Error en la base de datos.");
            handleListAllUsers(request, response, session, userService);
            
        }
      }

      //Metodo para eliminar un usuario
      private void handleDeleteUser(HttpServletRequest request, HttpServletResponse response, HttpSession session, UserService userService)
            throws ServletException, IOException {
            User searchUser = (User) session.getAttribute("searchUser");
            if (searchUser == null) {
                request.setAttribute("errorMessage", "Primero debes buscar un usuario para eliminar.");
                request.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
                return;
            }
            String id = searchUser.getId(); //Usamos el id del usuario buscado

            try {
                userService.deleteUser(id);
                session.removeAttribute("searchUser");
                request.setAttribute("successMessage", "Usuario eliminado");
                  request.getRequestDispatcher( "/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
                }catch(UserNotFoundException e){
                    request.setAttribute("errorMessage", e.getMessage());
                    request.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
                }catch(SQLException e){
                    request.setAttribute("errorMessage", "Error de base de datos.");
                    request.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
                }

            }
            
            //Metodo para lsitar todos los usuarios
            private void handleListAllUsers(HttpServletRequest request, HttpServletResponse response, HttpSession session, UserService userService)
                    throws ServletException, IOException {
                 try {
                List<User> user = userService.getAllUser();
                    session.setAttribute("users", user); //Guardamos los usuarios en la sesion
                    request.getRequestDispatcher("/Views/Forms/Users/list_all.jsp").forward(request, response);
                } catch (SQLException e) {
                    request.setAttribute("errorMessage", "Error de base de datos al listar los usuarios.");
                    request.getRequestDispatcher("/Views/Forms/Users/list_all.jsp").forward(request, response);
                }
            }

            //Metodo para cerrar sesion
            private void handleLogout(HttpServletRequest request, HttpServletResponse response, HttpSession session)
                    throws ServletException, IOException {
                session.invalidate(); //Cerramos la sesion existente
                response.sendRedirect(request.getContextPath() + "/Views/Forms/Users/login.jsp");
    }
%>     