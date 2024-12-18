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

function App() {
  const [token, setToken] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const savedToken = localStorage.getItem("token");
    if (savedToken) {
      setToken(savedToken); // Retrieve the saved token on load
    }
    setLoading(false);
  }, []);

  const handleLogin = (newToken) => {
    setToken(newToken);
    localStorage.setItem("token", newToken); // Store token in localStorage
  };

  const handleLogout = () => {
    setToken(null); // Clear token from state
    localStorage.removeItem("token"); // Remove token from localStorage
  };

  if (loading) {
    return <div>Loading...</div>; // Show loading until token is checked
  }

  return (
    <Router>
      <Navbar onLogout={handleLogout} /> {/* Pass logout handler to Navbar */}
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
            token ? <RoomsList onLogout={handleLogout} /> : <Navigate to="/" />
          }
        />
      </Routes>
    </Router>
  );
}

export default App;
