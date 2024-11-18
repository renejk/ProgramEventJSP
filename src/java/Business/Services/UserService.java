/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Business.Services;

/**
 *
 * @author renejk
 */

import Domain.Model.User;
import Infrastructure.Persistence.UserCRUD;

import java.util.List;

public class UserService {

    private UserCRUD userCrud;

    public UserService() {
        userCrud = new UserCRUD();
    }

    public List<User> getAllUsers() throws Exception {
        return userCrud.getAllUsers();
    }
}
