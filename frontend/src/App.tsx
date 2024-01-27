import { BrowserRouter, Route, Routes } from 'react-router-dom';
import Header from './components/Header';
import Home from './pages/Home';
import AuthProvider from './app/AuthProvider';

function App() {

  return (
    <>
      <BrowserRouter basename=''>
        <Header />
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/login" element={<div>Home</div>} />
          <Route path="/dashboard" element={<div>Dashboard</div>} />
        </Routes>
      </BrowserRouter>
    </>
  );
}

export default App;