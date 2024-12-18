import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import LoginForm from "../components/Login";
import SignupForm from "../components/Signup";

const AuthPage = () => {
  const [isSignup, setIsSignup] = useState(false);
  const [token, setToken] = useState("");
  const navigate = useNavigate(); // Initialize useNavigate

  const toggleForm = () => {
    setIsSignup(!isSignup);
  };

  const handleLogin = (token) => {
    setToken(token);
    localStorage.setItem("token", token);
    navigate("/rooms"); // Redirect after successful login
  };

  const handleSignup = (token) => {
    setToken(token);
    localStorage.setItem("token", token);
    navigate("/rooms"); // Redirect after successful signup
  };

  return (
    <div>
      <h1>{isSignup ? "Create an Account" : "Login"}</h1>
      {isSignup ? (
        <SignupForm onSignup={handleSignup} />
      ) : (
        <LoginForm onLogin={handleLogin} />
      )}
      <button onClick={toggleForm}>
        {isSignup
          ? "Already have an account? Login"
          : "Don't have an account? Sign up"}
      </button>
    </div>
  );
};

export default AuthPage;
