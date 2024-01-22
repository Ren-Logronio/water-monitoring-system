import { BrowserRouter, Route, Routes } from 'react-router-dom'
import './App.css'

function App() {

  const Home


  return (
    <>
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<div>Home</div>} />
          <Route path="/login" element={<div>Home</div>} />
          <Route path="/dashboard">
            <Route path="/" element={<div>Dashboard Home</div>} />
          </Route>
        </Routes>
      </BrowserRouter>
    </>
  )
}

export default App