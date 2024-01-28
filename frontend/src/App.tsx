import { BrowserRouter, Route, Routes } from 'react-router-dom';
import Header from './components/SideBar';
import Home from './pages/Home';

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