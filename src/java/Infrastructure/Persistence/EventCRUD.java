/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Infrastructure.Persistence;

/**
 *
 * @author renejk
 */

import Domain.Model.Event;
import Infrastructure.Database.ConnectionDbMySql;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EventCRUD {

    public List<Event> getAllEvents() {
        List<Event> events = new ArrayList<>();
        String query = "SELECT * FROM event";

        try {
            Connection conn = ConnectionDbMySql.getConnection();

            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(query);

            while (rs.next()) {
                events.add(new Event(rs.getString("id"),
                        rs.getString("name"), rs.getInt("attendees"),
                        rs.getString("event_date"), rs.getString("user_id")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return events;
    }

    public void addEvent(Event event) throws SQLException {
        String query = "INSERT INTO event ( name, attendees, event_date, user_id) VALUES (?, ?, ?, ?)";
        try (Connection conn = ConnectionDbMySql.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, event.getName());
            stmt.setInt(2, event.getAttendees());
            stmt.setString(3, event.getEventDate());
            stmt.setString(4, event.getUserId());
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateEvent(Event event) throws SQLException {
        String query = "UPDATE event SET name = ?, attendees = ?, event_date = ?, user_id = ? WHERE id = ?";
        try (Connection conn = ConnectionDbMySql.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, event.getName());
            stmt.setInt(2, event.getAttendees());
            stmt.setString(3, event.getEventDate());
            stmt.setString(4, event.getUserId());
            stmt.setString(5, event.getId());
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("Event not found with id: " + event.getId());
            }
        } catch (SQLException e) {
            throw e;
        }
    }

    public void deleteEvent(String id) throws SQLException {
        String query = "DELETE FROM event WHERE id = ?";
        try (Connection conn = ConnectionDbMySql.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, id);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("Event not found with id: " + id);
            }
        } catch (SQLException e) {
            throw e;
        }
    }

    public Event getEventById(String id) throws SQLException {
        String query = "SELECT * FROM event WHERE id = ?";
        Event event = null;
        try (Connection conn = ConnectionDbMySql.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                event = new Event(rs.getString("id"),
                        rs.getString("name"), rs.getInt("attendees"),
                        rs.getString("event_date"), rs.getString("user_id"));
            } else {
                throw new SQLException("Event not found with id: " + id);
            }
        } catch (SQLException e) {
            throw e;
        }
        return event;
    }

    public List<Event> getEventsByUserId(String userId) throws SQLException {
        List<Event> events = new ArrayList<>();
        String query = "SELECT * FROM event WHERE user_id = ?";
        try (Connection conn = ConnectionDbMySql.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                events.add(new Event(rs.getString("id"),
                        rs.getString("name"), rs.getInt("attendees"),
                        rs.getString("event_date"), rs.getString("user_id")));
            }
        } catch (SQLException e) {
            throw e;
        }
        return events;
    }

}
