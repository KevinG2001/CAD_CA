import React from "react";
import "../styles/navStyles.css";
import { useNavigate } from "react-router-dom";

function Navbar({ onLogout }) {
  const navigate = useNavigate();

  const handleLogoutClick = () => {
    onLogout();
    navigate("/");
  };

  return (
    <>
      <nav className="container">
        <div>Booking Site</div>
        <div className="linkWrapper">
          <div className="link" onClick={() => navigate("/rooms")}>
            Rooms
          </div>
          <div className="link" onClick={() => navigate("/bookings")}>
            Bookings
          </div>
          <div className="link" onClick={handleLogoutClick}>
            Logout
          </div>
        </div>
      </nav>
    </>
  );
}

export default Navbar;
