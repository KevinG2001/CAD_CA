import React, { useState, useEffect } from "react";
import "../styles/roomStyles.css";

const RoomList = () => {
  const [rooms, setRooms] = useState([]);
  const [selectedRoom, setSelectedRoom] = useState(null);
  const [startDate, setStartDate] = useState("");
  const [endDate, setEndDate] = useState("");
  const [error, setError] = useState("");

  useEffect(() => {
    // Fetch available rooms
    fetch("http://localhost:3000/api/rooms")
      .then((response) => response.json())
      .then((data) => setRooms(data))
      .catch((error) => console.error("Error fetching rooms:", error));
  }, []);

  const checkAvailability = () => {
    if (!startDate || !endDate) {
      setError("Please select both start and end dates");
      return;
    }

    fetch(
      `http://localhost:3000/api/rooms/${selectedRoom.id}/check_availability`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ start_date: startDate, end_date: endDate }),
      }
    )
      .then((response) => response.json())
      .then((data) => {
        if (data.error) {
          setError(data.error);
        } else {
          // Availability check passed, now create the booking
          createBooking();
        }
      })
      .catch((err) => {
        console.error("Error:", err);
        setError("Something went wrong. Please try again.");
      });
  };

  const createBooking = () => {
    fetch("http://localhost:3000/api/bookings", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        room_id: selectedRoom.id,
        start_date: startDate,
        end_date: endDate,
      }),
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.message) {
          alert(data.message);
          setError("");
        } else {
          setError(data.error);
        }
      })
      .catch((err) => {
        console.error("Error:", err);
        setError("Something went wrong while creating the booking.");
      });
  };

  return (
    <div className="rooms-container">
      {rooms.map((room) => (
        <div
          key={room.id}
          className="room-card"
          onClick={() => setSelectedRoom(room)}
        >
          <h3>{room.name}</h3>
          <p>Capacity: {room.capacity}</p>
          <button className="book-button available">Select Room</button>
        </div>
      ))}

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
