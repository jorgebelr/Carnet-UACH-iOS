import { ReactNode } from 'react';
import { motion } from 'framer-motion';
import { ShieldCheck, User } from 'lucide-react';

interface LayoutProps {
  children: ReactNode;
}

const Layout = ({ children }: LayoutProps) => {
  return (
    <div style={{ width: '100vw', minHeight: '100vh', background: 'var(--bg-dark)' }}>
      {/* Simple Header */}
      <header style={{ 
        height: '80px', 
        padding: '0 5%', 
        display: 'flex', 
        alignItems: 'center', 
        justifyContent: 'space-between',
        borderBottom: '1px solid var(--glass-border)',
        background: 'rgba(15, 23, 42, 0.8)',
        backdropFilter: 'blur(10px)',
        position: 'sticky',
        top: 0,
        zIndex: 50
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
          <div style={{ background: 'var(--primary)', width: '40px', height: '40px', borderRadius: '10px', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
             <ShieldCheck size={24} color="white" />
          </div>
          <h1 style={{ fontSize: '1.4rem', margin: 0, background: 'none', webkitTextFillColor: 'white' }}>UACH Admin</h1>
        </div>

        <div style={{ display: 'flex', alignItems: 'center', gap: '1.5rem' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '0.8rem' }}>
            <div style={{ textAlign: 'right', display: { xs: 'none', sm: 'block' } }}>
              <p style={{ margin: 0, fontSize: '0.9rem', fontWeight: 600 }}>Administrador</p>
              <p style={{ margin: 0, fontSize: '0.75rem', color: 'var(--text-muted)' }}>Sesión Activa</p>
            </div>
            <div style={{ 
              width: '40px', 
              height: '40px', 
              borderRadius: '50%', 
              background: 'linear-gradient(45deg, #003366, #38bdf8)',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center'
            }}>
              <User size={20} color="white" />
            </div>
          </div>
        </div>
      </header>

      {/* Page Content */}
      <main style={{ padding: '3rem 5%', minHeight: 'calc(100vh - 80px)' }}>
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.4 }}
        >
          {children}
        </motion.div>
      </main>
    </div>
  );
};

export default Layout;
