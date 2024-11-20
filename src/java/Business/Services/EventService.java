/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Business.Services;

/**
 *
 * @author renejk
 */

import Domain.Model.Event;
import Infrastructure.Persistence.EventCRUD;
import java.sql.SQLException;
import java.util.List;

public class EventService {

    private final EventCRUD eventCrud;

    public EventService() {
        this.eventCrud = new EventCRUD();
    }

    // Metodo para obtener todos los eventos
    public List<Event> getAllEvents() throws SQLException {
        return eventCrud.getAllEvents();
    }

    // Metodo para agregar un evento
    public void addEvent(Event event) throws SQLException {
        eventCrud.addEvent(event);
    }

    // Metodo para actualizar un evento
    public void updateEvent(Event event) throws SQLException {
        eventCrud.updateEvent(event);
    }

    // Metodo para eliminar un evento
    public void deleteEvent(String id) throws SQLException {
        eventCrud.deleteEvent(id);
    }

    // Metodo para obtener un evento por id
    public Event getEventById(String id) throws SQLException {
        return eventCrud.getEventById(id);
    }

    // Metodo para obtener todos los eventos de un usuario
    public List<Event> getEventsByUserId(String userId) throws SQLException {
        return eventCrud.getEventsByUserId(userId);
    }

}
