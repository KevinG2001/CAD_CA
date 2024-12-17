import React, { useState, useEffect } from "react";
import "../styles/roomStyles.css";

function RoomsList() {
  const [rooms, setRooms] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);

  const fetchRooms = async () => {
    try {
      const response = await fetch("http://localhost:3000/api/rooms");

      console.log("Response status:", response.status);
      console.log("Response headers:", response.headers);

      if (!response.ok) {
        const errorText = await response.text();
        throw new Error(
          `HTTP error! status: ${response.status}, body: ${errorText}`
        );
      }

      const contentType = response.headers.get("content-type");
      if (!contentType || !contentType.includes("application/json")) {
        const text = await response.text();
        throw new Error(`Expected JSON, got: ${text}`);
      }

      const data = await response.json();
      setRooms(data);
      setIsLoading(false);
    } catch (error) {
      console.error("Detailed error fetching rooms:", error);
      setError(error);
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchRooms();
  }, []);

  return (
    <div className="rooms-container">
      <h1>Our Rooms</h1>
      <div className="rooms-grid">
        {rooms.map((room) => (
          <div key={room.id} className="room-card">
            <h2>{room.name}</h2>
            <p>Price per night: ${room.price_per_night}</p>
            <p>Status: {room.booked ? "Booked" : "Available"}</p>
            <button
              className={`book-button ${
                room.booked ? "disabled" : "available"
              }`}
              disabled={room.booked}
            >
              {room.booked ? "Booked" : "Book Now"}
            </button>
          </div>
        ))}
      </div>
    </div>
  );
}

export default RoomsList;
