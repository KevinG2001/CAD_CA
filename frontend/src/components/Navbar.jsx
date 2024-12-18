import React from "react";
import "../styles/navStyles.css";

function Navbar() {
  return (
    <>
      <nav className="container">
        <div>Booking Site</div>
        <div className="linkWrapper">
          <div className="link">Rooms</div>
          <div className="link">Bookings</div>
          <div className="link">Logout</div>
        </div>
      </nav>
    </>
  );
}

export default Navbar;
