import { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import {
  Plus,
  Search,
  Edit2,
  Trash2,
  X,
  Calendar,
  MapPin,
  Users,
  Info,
  Image as ImageIcon,
  Save,
  Loader2
} from 'lucide-react';

// Categories from backend enum
// Categories from backend enum with Spanish labels
const CATEGORY_LABELS: Record<string, string> = {
  "Culture": "Cultural",
  "ScientificPhilosophical": "Científico / Filosófico",
  "Sports": "Deportivo",
  "CommunitySupport": "Apoyo a la Comunidad",
  "Health": "Salud",
  "FutureLivingTools": "Herramientas para la Vida Futura"
};

const CATEGORIES = Object.keys(CATEGORY_LABELS);

interface Event {
  _id: string;
  title: string;
  eventCode: string;
  category: string;
  place: string;
  description: string;
  date: string;
  isLimited: boolean;
  maxCapacity: number;
  reservedCount: number;
  imageUrl?: string;
}

const EventsCRUD = () => {
  const [events, setEvents] = useState<Event[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingEvent, setEditingEvent] = useState<Event | null>(null);
  const [eventToDelete, setEventToDelete] = useState<string | null>(null);

  // Form State
  const [formData, setFormData] = useState({
    title: '',
    category: CATEGORIES[0],
    place: '',
    description: '',
    date: '',
    maxCapacity: 100,
    isLimited: true
  });
  const [imageFile, setImageFile] = useState<File | null>(null);

  const API_URL = `${import.meta.env.VITE_API_URL}/events`;
  const BASE_IMAGE_URL = import.meta.env.VITE_API_URL;

  useEffect(() => {
    fetchEvents();
  }, []);

  const fetchEvents = async () => {
    try {
      const response = await fetch(API_URL);
      const data = await response.json();
      setEvents(data);
    } catch (error) {
      console.error('Error fetching events:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleOpenModal = (event?: Event) => {
    if (event) {
      setEditingEvent(event);
      setFormData({
        title: event.title,
        category: event.category,
        place: event.place,
        description: event.description,
        date: new Date(event.date).toISOString().split('T')[0],
        maxCapacity: event.maxCapacity,
        isLimited: event.isLimited
      });
    } else {
      setEditingEvent(null);
      setFormData({
        title: '',
        category: CATEGORIES[0],
        place: '',
        description: '',
        date: '',
        maxCapacity: 100,
        isLimited: true
      });
    }
    setImageFile(null);
    setIsModalOpen(true);
  };

  const handleDelete = async () => {
    if (!eventToDelete) return;

    try {
      const response = await fetch(`${API_URL}/eventCode/${eventToDelete}`, {
        method: 'DELETE',
        headers: {
          'Accept': 'application/json'
        }
      });

      if (response.ok) {
        setEventToDelete(null);
        fetchEvents();
      } else {
        const errorData = await response.json();
        console.error('Server error deleting event:', errorData);
        alert('Error del servidor al eliminar el evento');
      }
    } catch (error) {
      console.error('Network error deleting event:', error);
      alert('Error de red al intentar eliminar el evento');
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    // Validation: prevent past dates
    const selectedDate = new Date(formData.date);
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    if (selectedDate < today) {
      alert('La fecha del evento no puede ser anterior al día de hoy');
      return;
    }

    const submitData = new FormData();
    Object.entries(formData).forEach(([key, value]) => {
      submitData.append(key, String(value));
    });
    if (imageFile) {
      submitData.append('image', imageFile);
    }

    try {
      const url = editingEvent
        ? `${API_URL}/eventCode/${editingEvent.eventCode}`
        : API_URL;
      const method = editingEvent ? 'PATCH' : 'POST';

      const response = await fetch(url, {
        method,
        body: submitData
      });

      if (response.ok) {
        setIsModalOpen(false);
        fetchEvents();
      } else {
        const err = await response.json();
        alert(err.message || 'Error al guardar el evento');
      }
    } catch (error) {
      console.error('Error saving event:', error);
    }
  };

  const filteredEvents = events.filter(e =>
    e.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
    e.eventCode.toLowerCase().includes(searchTerm.toLowerCase()) ||
    e.place.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div style={{ maxWidth: '1200px', margin: '0 auto' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '2rem' }}>
        <div>
          <h1 style={{ fontSize: '2.5rem', margin: 0, background: 'none', webkitTextFillColor: 'white' }}>Gestión de Eventos</h1>
          <p style={{ color: 'var(--text-muted)', marginTop: '0.5rem' }}>Administra los eventos del Carnet Universitario</p>
        </div>
        <button
          onClick={() => handleOpenModal()}
          style={{ display: 'flex', alignItems: 'center', gap: '0.8rem', padding: '0.8rem 1.5rem' }}
        >
          <Plus size={20} />
          Nuevo Evento
        </button>
      </div>

      {/* Search Bar */}
      <div className="glass-card" style={{ padding: '1rem', marginBottom: '2rem', display: 'flex', alignItems: 'center', gap: '1rem' }}>
        <Search size={20} color="var(--text-muted)" />
        <input
          type="text"
          placeholder="Buscar por título, código o lugar..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          style={{ border: 'none', background: 'transparent', width: '100%' }}
        />
      </div>

      {loading ? (
        <div style={{ display: 'flex', justifyContent: 'center', padding: '5rem' }}>
          <Loader2 className="animate-spin" size={48} color="var(--accent)" />
        </div>
      ) : (
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(350px, 1fr))', gap: '1.5rem' }}>
          {filteredEvents.map(event => (
            <motion.div
              key={event._id}
              layout
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              className="glass-card"
              style={{ overflow: 'hidden', display: 'flex', flexDirection: 'column' }}
            >
              {event.imageUrl ? (
                <img src={`${BASE_IMAGE_URL}/${event.imageUrl}`} alt={event.title} style={{ width: '100%', height: '180px', objectFit: 'cover' }} />
              ) : (
                <div style={{ width: '100%', height: '180px', background: 'var(--glass)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                  <ImageIcon size={48} color="var(--text-muted)" />
                </div>
              )}

              <div style={{ padding: '1.5rem', flex: 1 }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: '0.5rem' }}>
                  <span style={{ fontSize: '0.75rem', fontWeight: 700, color: 'var(--accent)', textTransform: 'uppercase', letterSpacing: '0.05em' }}>
                    {CATEGORY_LABELS[event.category] || event.category}
                  </span>
                  <span style={{ fontSize: '0.75rem', background: 'var(--glass)', padding: '2px 8px', borderRadius: '4px', color: 'var(--text-muted)' }}>
                    {event.eventCode}
                  </span>
                </div>
                <h3 style={{ margin: '0 0 1rem 0', fontSize: '1.25rem' }}>{event.title}</h3>

                <div style={{ display: 'flex', flexDirection: 'column', gap: '0.6rem', color: 'var(--text-muted)', fontSize: '0.9rem' }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                    <Calendar size={16} />
                    {new Date(event.date).toLocaleDateString('es-MX', { weekday: 'long', day: 'numeric', month: 'long' })}
                  </div>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                    <MapPin size={16} />
                    {event.place}
                  </div>
                  {event.isLimited && (
                    <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                      <Users size={16} />
                      {event.reservedCount} / {event.maxCapacity} lugares
                    </div>
                  )}
                </div>
              </div>

              <div style={{ padding: '1rem', borderTop: '1px solid var(--glass-border)', display: 'flex', gap: '0.8rem' }}>
                <button
                  onClick={() => handleOpenModal(event)}
                  style={{ flex: 1, background: 'var(--glass)', color: 'white', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '0.5rem' }}
                >
                  <Edit2 size={16} /> Editar
                </button>
                <button
                  onClick={() => setEventToDelete(event.eventCode)}
                  style={{ background: 'rgba(239, 68, 68, 0.1)', color: '#ef4444', padding: '0.8rem' }}
                >
                  <Trash2 size={18} />
                </button>
              </div>
            </motion.div>
          ))}
        </div>
      )}

      {/* Modal Form */}
      <AnimatePresence>
        {isModalOpen && (
          <div style={{
            position: 'fixed', top: 0, left: 0, right: 0, bottom: 0,
            background: 'rgba(0,0,0,0.8)', backdropFilter: 'blur(8px)',
            display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 100,
            padding: '2rem'
          }}>
            <motion.div
              initial={{ scale: 0.9, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0.9, opacity: 0 }}
              className="glass-card"
              style={{ width: '100%', maxWidth: '600px', padding: '2rem', maxHeight: '90vh', overflowY: 'auto' }}
            >
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '2rem' }}>
                <h2>{editingEvent ? 'Editar Evento' : 'Nuevo Evento'}</h2>
                <button onClick={() => setIsModalOpen(false)} style={{ background: 'transparent', padding: '0.5rem' }}>
                  <X size={24} color="var(--text-muted)" />
                </button>
              </div>

              <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '1.5rem' }}>
                <div>
                  <label style={{ display: 'block', marginBottom: '0.5rem', fontSize: '0.9rem', color: 'var(--text-muted)' }}>Título</label>
                  <input
                    type="text" required
                    value={formData.title}
                    onChange={e => setFormData({ ...formData, title: e.target.value })}
                  />
                </div>

                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem' }}>
                  <div>
                    <label style={{ display: 'block', marginBottom: '0.5rem', fontSize: '0.9rem', color: 'var(--text-muted)' }}>Categoría</label>
                    <select
                      value={formData.category}
                      onChange={e => setFormData({ ...formData, category: e.target.value })}
                      style={{ width: '100%', padding: '0.8rem', borderRadius: '8px', background: 'var(--glass)', color: 'white', border: '1px solid var(--glass-border)' }}
                    >
                      {CATEGORIES.map(c => <option key={c} value={c}>{CATEGORY_LABELS[c]}</option>)}
                    </select>
                  </div>
                  <div>
                    <label style={{ display: 'block', marginBottom: '0.5rem', fontSize: '0.9rem', color: 'var(--text-muted)' }}>Fecha</label>
                    <input
                      type="date" required
                      min={new Date().toISOString().split('T')[0]}
                      value={formData.date}
                      onChange={e => setFormData({ ...formData, date: e.target.value })}
                    />
                  </div>
                </div>

                <div>
                  <label style={{ display: 'block', marginBottom: '0.5rem', fontSize: '0.9rem', color: 'var(--text-muted)' }}>Lugar</label>
                  <input
                    type="text" required
                    value={formData.place}
                    onChange={e => setFormData({ ...formData, place: e.target.value })}
                  />
                </div>

                <div>
                  <label style={{ display: 'block', marginBottom: '0.5rem', fontSize: '0.9rem', color: 'var(--text-muted)' }}>Descripción</label>
                  <textarea
                    rows={3}
                    value={formData.description}
                    onChange={e => setFormData({ ...formData, description: e.target.value })}
                    style={{ width: '100%', padding: '0.8rem', borderRadius: '8px', background: 'var(--glass)', color: 'white', border: '1px solid var(--glass-border)', resize: 'none', fontFamily: 'inherit' }}
                  />
                </div>

                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem' }}>
                  <div>
                    <label style={{ display: 'block', marginBottom: '0.5rem', fontSize: '0.9rem', color: 'var(--text-muted)' }}>Capacidad Máxima</label>
                    <input
                      type="number" required min={1}
                      value={formData.maxCapacity}
                      onChange={e => setFormData({ ...formData, maxCapacity: Number(e.target.value) })}
                    />
                  </div>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '1rem', paddingTop: '1.8rem' }}>
                    <input
                      type="checkbox"
                      checked={formData.isLimited}
                      onChange={e => setFormData({ ...formData, isLimited: e.target.checked })}
                      style={{ width: 'auto' }}
                    />
                    <label style={{ fontSize: '0.9rem' }}>Cupo limitado</label>
                  </div>
                </div>

                <div>
                  <label style={{ display: 'block', marginBottom: '0.5rem', fontSize: '0.9rem', color: 'var(--text-muted)' }}>Imagen del Evento</label>
                  <input
                    type="file"
                    accept="image/*"
                    onChange={e => setImageFile(e.target.files?.[0] || null)}
                    style={{ padding: '0.5rem 0' }}
                  />
                </div>

                <button type="submit" style={{ marginTop: '1rem', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '0.8rem' }}>
                  <Save size={20} />
                  {editingEvent ? 'Guardar Cambios' : 'Crear Evento'}
                </button>
              </form>
            </motion.div>
          </div>
        )}
      </AnimatePresence>
      {/* Delete Confirmation Modal */}
      <AnimatePresence>
        {eventToDelete && (
          <div style={{
            position: 'fixed', top: 0, left: 0, right: 0, bottom: 0,
            background: 'rgba(0,0,0,0.85)', backdropFilter: 'blur(8px)',
            display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 110,
            padding: '2rem'
          }}>
            <motion.div
              initial={{ scale: 0.9, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0.9, opacity: 0 }}
              className="glass-card"
              style={{ width: '100%', maxWidth: '400px', padding: '2rem', textAlign: 'center' }}
            >
              <div style={{ background: 'rgba(239, 68, 68, 0.1)', width: '64px', height: '64px', borderRadius: '50%', display: 'flex', alignItems: 'center', justifyContent: 'center', margin: '0 auto 1.5rem' }}>
                <Trash2 size={32} color="#ef4444" />
              </div>
              <h2 style={{ marginBottom: '1rem' }}>¿Eliminar evento?</h2>
              <p style={{ color: 'var(--text-muted)', marginBottom: '2rem' }}>
                Esta acción no se puede deshacer. El evento se borrará permanentemente.
              </p>
              <div style={{ display: 'flex', gap: '1rem' }}>
                <button
                  onClick={() => setEventToDelete(null)}
                  style={{ flex: 1, background: 'var(--glass)', color: 'white' }}
                >
                  Cancelar
                </button>
                <button
                  onClick={handleDelete}
                  style={{ flex: 1, background: '#ef4444' }}
                >
                  Eliminar
                </button>
              </div>
            </motion.div>
          </div>
        )}
      </AnimatePresence>
    </div>
  );
};

export default EventsCRUD;
