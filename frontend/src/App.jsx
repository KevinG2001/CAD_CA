import React, { useState, useEffect } from "react";
import {
  BrowserRouter as Router,
  Routes,
  Route,
  Navigate,
} from "react-router-dom";
import RoomsList from "./pages/RoomList";
import AuthPage from "./pages/AuthPage";

function App() {
  const [token, setToken] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const savedToken = localStorage.getItem("token");
    console.log("Saved Token:", savedToken);

    if (!savedToken) {
      setToken(null);
    } else {
      setToken(savedToken);
    }

    setLoading(false);
  }, []);

  const handleLogin = (newToken) => {
    setToken(newToken);
    localStorage.setItem("token", newToken);
  };

  const handleLogout = () => {
    setToken(null);
    localStorage.removeItem("token");
  };

  if (loading) {
    return <div>Loading...</div>;
  }

  return (
    <Router>
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
