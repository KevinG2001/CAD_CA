import React, { useState, useEffect } from "react";
import {
  BrowserRouter as Router,
  Routes,
  Route,
  Navigate,
} from "react-router-dom";
import RoomsList from "./pages/RoomList";
import AuthPage from "./pages/AuthPage";
import Navbar from "./components/Navbar";
import Bookings from "./pages/Bookings"; // Import the Bookings page

function App() {
  const [token, setToken] = useState(null);
  const [isAdmin, setIsAdmin] = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const savedToken = localStorage.getItem("token");
    const savedIsAdmin = localStorage.getItem("isAdmin") === "true";

    if (!savedToken) {
      setToken(null);
    } else {
      setToken(savedToken);
      setIsAdmin(savedIsAdmin);
    }

    setLoading(false);
  }, []);

  const handleLogin = (newToken, adminStatus) => {
    setToken(newToken);
    setIsAdmin(adminStatus);
    localStorage.setItem("token", newToken);
    localStorage.setItem("isAdmin", adminStatus);
  };

  const handleLogout = () => {
    setToken(null);
    setIsAdmin(false);
    localStorage.removeItem("token");
    localStorage.removeItem("isAdmin");
  };

  if (loading) {
    return <div>Loading...</div>;
  }

  return (
    <Router>
      <Navbar onLogout={handleLogout} />
      <Routes>
        <Route
          path="/"
          element={
            !token ? (
              <AuthPage onLogin={handleLogin} />
            ) : (
              <Navigate to="/rooms" />
            )
          }
        />
        <Route
          path="/rooms"
          element={
            token ? (
              <RoomsList isAdmin={isAdmin} onLogout={handleLogout} />
            ) : (
              <Navigate to="/" />
            )
          }
        />
        <Route
          path="/bookings"
          element={token ? <Bookings /> : <Navigate to="/" />}
        />
      </Routes>
    </Router>
  );
}

export default App;
