import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import EventsCRUD from './pages/Events';
import Layout from './components/Layout';

function App() {
  return (
    <Router>
      <Layout>
        <Routes>
          <Route path="/" element={<Navigate to="/events" replace />} />
          <Route path="/events" element={<EventsCRUD />} />
          {/* Catch all */}
          <Route path="*" element={<Navigate to="/events" replace />} />
        </Routes>
      </Layout>
    </Router>
  );
}

export default App;
