/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Business.Exceptions;

/**
 *
 * @author renejk
 */
public class DuplicateUserException extends Exception {

    public DuplicateUserException(String message) {
        super(message);
    }
}