import React, { useState, useEffect } from "react";

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
        room_id: selectedRoom.id, // Pass room_id as a part of the request body
        start_date: startDate,
        end_date: endDate,
      }),
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.message) {
          alert(data.message); // Show success message
          setError(""); // Clear any previous errors
        } else {
          setError(data.error); // Show error message if the booking failed
        }
      })
      .catch((err) => {
        console.error("Error:", err);
        setError("Something went wrong while creating the booking.");
      });
  };

  return (
    <div>
      <h1>Rooms</h1>
      <ul>
        {rooms.map((room) => (
          <li key={room.id} onClick={() => setSelectedRoom(room)}>
            {room.name}
          </li>
        ))}
      </ul>

      {selectedRoom && (
        <div>
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
          {error && <p>{error}</p>}
        </div>
      )}
    </div>
  );
};

export default RoomList;
