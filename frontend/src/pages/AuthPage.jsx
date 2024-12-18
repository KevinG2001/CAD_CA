import React, { useState } from "react";
import LoginForm from "../components/Login";
import SignupForm from "../components/Signup";

const AuthPage = () => {
  const [isSignup, setIsSignup] = useState(false);
  const [token, setToken] = useState("");

  const toggleForm = () => {
    setIsSignup(!isSignup);
  };

  const handleLogin = (token) => {
    setToken(token);
    localStorage.setItem("token", token);
  };

  const handleSignup = (token) => {
    setToken(token);
    localStorage.setItem("token", token);
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
