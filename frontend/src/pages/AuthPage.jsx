import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import LoginForm from "../components/Login";
import SignupForm from "../components/Signup";
import "../styles/AuthPage.css";

const AuthPage = () => {
  const [isSignup, setIsSignup] = useState(false);
  const [token, setToken] = useState("");
  const navigate = useNavigate();

  const toggleForm = () => {
    setIsSignup(!isSignup);
  };

  const handleLogin = (token) => {
    setToken(token);
    localStorage.setItem("token", token);
    navigate("/rooms");
  };

  const handleSignup = (token) => {
    setToken(token);
    localStorage.setItem("token", token);
    navigate("/rooms");
  };

  return (
    <div className="auth-container">
      <div className="auth-wrapper">
        <h1>{isSignup ? "Create an Account" : "Login"}</h1>
        {isSignup ? (
          <SignupForm onSignup={handleSignup} />
        ) : (
          <LoginForm onLogin={handleLogin} />
        )}
        <button className="toggle-btn" onClick={toggleForm}>
          {isSignup
            ? "Already have an account? Login"
            : "Don't have an account? Sign up"}
        </button>
      </div>
    </div>
  );
};

export default AuthPage;
