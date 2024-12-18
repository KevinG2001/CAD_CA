import React, { useState, useEffect } from "react";
import "../styles/bookingStyles.css"; // Assuming you have your styles here

const Bookings = () => {
  const [bookings, setBookings] = useState([]);
  const [error, setError] = useState("");

  useEffect(() => {
    // Fetch bookings from the API
    const fetchBookings = async () => {
      console.log("Bearer Token:", localStorage.getItem("token"));
      try {
        const response = await fetch("http://localhost:3000/api/bookings", {
          headers: {
            Authorization: `Bearer ${localStorage.getItem("token")}`,
          },
        });

        const data = await response.json();

        if (response.ok) {
          setBookings(data);
        } else {
          setError(data.error || "Failed to fetch bookings");
        }
      } catch (error) {
        console.error(error); // Log error for debugging
        setError("Something went wrong while fetching the bookings.");
      }
    };

    fetchBookings();
  }, []);

  // Function to format dates manually
  const formatDate = (dateString) => {
    const date = new Date(dateString);
    const day = date.getDate();
    const month = date.getMonth() + 1; // Months are 0-based, so add 1
    const year = date.getFullYear();

    // Format date as MM/DD/YYYY
    return `${month < 10 ? "0" + month : month}/${
      day < 10 ? "0" + day : day
    }/${year}`;
  };

  return (
    <div className="bookings-container">
      <h1>Your Bookings</h1>
      {error && <p className="error">{error}</p>}
      {bookings.length === 0 ? (
        <p>No bookings found</p>
      ) : (
        <div className="bookings-table">
          <div className="bookings-table-header">
            <div className="table-cell">Room</div>
            <div className="table-cell">Start Date</div>
            <div className="table-cell">End Date</div>
            <div className="table-cell">Status</div>
          </div>
          {bookings.map((booking) => (
            <div key={booking.id} className="bookings-table-row">
              <div className="table-cell">{booking.room?.name || "N/A"}</div>
              <div className="table-cell">{formatDate(booking.start_date)}</div>
              <div className="table-cell">{formatDate(booking.end_date)}</div>
              <div className="table-cell">{booking.status || "Pending"}</div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};

export default Bookings;
