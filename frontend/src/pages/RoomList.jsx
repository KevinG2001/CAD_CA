import React, { useState, useEffect } from "react";
import "../styles/roomStyles.css";

const RoomList = () => {
  const [rooms, setRooms] = useState([]);
  const [selectedRoom, setSelectedRoom] = useState(null);
  const [startDate, setStartDate] = useState("");
  const [endDate, setEndDate] = useState("");
  const [error, setError] = useState("");
  const [newRoomName, setNewRoomName] = useState("");
  const [isAdmin, setIsAdmin] = useState(false); // Track if the user is an admin

  useEffect(() => {
    // Fetch available rooms
    fetch("/api/rooms")
      .then((response) => response.json())
      .then((data) => setRooms(data))
      .catch((error) => console.error("Error fetching rooms:", error));

    // Check if the user is an admin from localStorage
    const storedIsAdmin = localStorage.getItem("is_admin");
    setIsAdmin(storedIsAdmin === "true"); // Convert string to boolean
  }, []);

  const checkAvailability = () => {
    if (!startDate || !endDate) {
      setError("Please select both start and end dates");
      return;
    }

    fetch(`/api/rooms/${selectedRoom.id}/check_availability`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ start_date: startDate, end_date: endDate }),
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.error) {
          setError(data.error);
        } else {
          createBooking(selectedRoom.id, startDate, endDate);
        }
      })
      .catch((err) => {
        console.error("Error:", err);
        setError("Something went wrong. Please try again.");
      });
  };

  const createBooking = async (roomId, startDate, endDate) => {
    const token = localStorage.getItem("token");

    if (!token) {
      console.error("No token found. Please log in.");
      return;
    }

    try {
      const response = await fetch("/api/bookings", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({
          room_id: roomId,
          start_date: startDate,
          end_date: endDate,
        }),
      });

      const data = await response.json();
      if (response.ok) {
        console.log("Booking successful", data);
      } else {
        console.error("Failed to make booking:", data.error || data.message);
      }
    } catch (error) {
      console.error("Error:", error);
    }
  };

  const handleCreateRoom = async () => {
    const token = localStorage.getItem("token");

    if (!newRoomName) {
      setError("Please enter a room name.");
      return;
    }

    try {
      const response = await fetch("/api/rooms", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({ room: { name: newRoomName } }),
      });

      const data = await response.json();
      if (response.ok) {
        setRooms([...rooms, data.room]);
        setNewRoomName("");
        setError("");
      } else {
        setError(data.error || "Failed to create room.");
      }
    } catch (error) {
      console.error("Error creating room:", error);
      setError("Something went wrong. Please try again.");
    }
  };

  const handleDeleteRoom = async (roomId) => {
    const token = localStorage.getItem("token");

    try {
      const response = await fetch(`/api/rooms/${roomId}`, {
        method: "DELETE",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
      });

      if (response.ok) {
        setRooms(rooms.filter((room) => room.id !== roomId));
        console.log("Room deleted successfully");
      } else {
        console.error("Failed to delete room");
      }
    } catch (error) {
      console.error("Error deleting room:", error);
    }
  };

  const handleEditRoom = async (roomId, newName) => {
    const token = localStorage.getItem("token");

    if (!newName) {
      setError("Room name cannot be empty.");
      return;
    }

    try {
      const response = await fetch(`/api/rooms/${roomId}`, {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({ room: { name: newName } }),
      });

      const data = await response.json();
      if (response.ok) {
        setRooms(rooms.map((room) => (room.id === roomId ? data.room : room)));
        console.log("Room updated successfully");
      } else {
        console.error("Failed to update room");
      }
    } catch (error) {
      console.error("Error editing room:", error);
    }
  };

  return (
    <div className="rooms-container">
      <h1>Available Rooms</h1>

      <div className="rooms-grid">
        {rooms.map((room) => (
          <div
            key={room.id}
            className="room-card"
            onClick={() => setSelectedRoom(room)}
          >
            <h3>{room.name}</h3>
            <p>Capacity: {room.capacity}</p>
            <p>Price per Night: ${room.price_per_night}</p>{" "}
            {/* Displaying price per night */}
            <button className="book-button available">Select Room</button>
            {isAdmin && (
              <div className="admin-actions">
                <button
                  className="edit-button"
                  onClick={() => {
                    const newName = prompt("Enter new room name", room.name);
                    if (newName) {
                      handleEditRoom(room.id, newName);
                    }
                  }}
                >
                  Edit
                </button>
                <button
                  className="delete-button"
                  onClick={() => handleDeleteRoom(room.id)}
                >
                  Delete
                </button>
              </div>
            )}
          </div>
        ))}

        {isAdmin && (
          <div className="room-card add-room-card">
            <div className="add-room-content">
              <h3>Create Room</h3>
              <input
                type="text"
                placeholder="Enter room name"
                value={newRoomName}
                onChange={(e) => setNewRoomName(e.target.value)}
              />
              <button onClick={handleCreateRoom} className="create-button">
                +
              </button>
            </div>
          </div>
        )}
      </div>

      {selectedRoom && (
        <div className="booking-form">
          <h2>Book {selectedRoom.name}</h2>
          <label>
            Start Date:
            <input
              type="date"
              value={startDate}
              onChange={(e) => setStartDate(e.target.value)}
            />
          </label>
          <label>
            End Date:
            <input
              type="date"
              value={endDate}
              onChange={(e) => setEndDate(e.target.value)}
            />
          </label>
          <button onClick={checkAvailability}>Check Availability</button>
          {error && <p style={{ color: "red" }}>{error}</p>}
        </div>
      )}
    </div>
  );
};

export default RoomList;
