import { X, TrendingUp, TrendingDown } from 'lucide-react';
import { useState } from 'react';

interface TransactionModalProps {
  type: 'income' | 'expense';
  onClose: () => void;
}

export function TransactionModal({ type, onClose }: TransactionModalProps) {
  const [amount, setAmount] = useState('');
  const [description, setDescription] = useState('');
  const [category, setCategory] = useState('');

  const isIncome = type === 'income';
  const color = isIncome ? '#3DBB8F' : '#FF5F5F';
  const Icon = isIncome ? TrendingUp : TrendingDown;

  const categories = isIncome
    ? ['Salario', 'Freelance', 'Inversiones', 'Otro']
    : ['Alimentación', 'Transporte', 'Servicios', 'Compras', 'Entretenimiento', 'Otro'];

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    console.log({ type, amount, description, category });
    alert(`${isIncome ? 'Ingreso' : 'Gasto'} registrado: $${amount}`);
    onClose();
  };

  return (
    <div className="fixed inset-0 z-50 flex items-end">
      {/* Backdrop */}
      <div 
        className="absolute inset-0 backdrop-blur-md"
        style={{ background: 'rgba(0, 0, 0, 0.6)' }}
        onClick={onClose}
      />
      
      {/* Modal */}
      <div 
        className="relative w-full rounded-t-3xl p-6 animate-slide-up backdrop-blur-2xl border-t border-x"
        style={{
          background: 'rgba(28, 28, 30, 0.95)',
          borderColor: 'rgba(255, 255, 255, 0.1)',
          maxHeight: '80vh',
          boxShadow: '0 -8px 32px rgba(0, 0, 0, 0.4), inset 0 1px 0 rgba(255, 255, 255, 0.1)'
        }}
      >
        {/* Header */}
        <div className="flex items-center justify-between mb-6">
          <div className="flex items-center gap-3">
            <div 
              className="w-12 h-12 rounded-full flex items-center justify-center"
              style={{ backgroundColor: `${color}20` }}
            >
              <Icon className="w-6 h-6" style={{ color }} />
            </div>
            <div>
              <h2 className="text-white text-xl font-semibold">
                {isIncome ? 'Registrar Ingreso' : 'Registrar Gasto'}
              </h2>
              <p className="text-[#8E8E93] text-sm">
                Completa los detalles
              </p>
            </div>
          </div>
          <button
            onClick={onClose}
            className="w-10 h-10 rounded-full bg-[#2C2C2E] flex items-center justify-center"
          >
            <X className="w-5 h-5 text-white" />
          </button>
        </div>

        {/* Form */}
        <form onSubmit={handleSubmit} className="space-y-4">
          {/* Amount */}
          <div>
            <label className="text-[#8E8E93] text-sm mb-2 block">Monto</label>
            <div className="relative">
              <span 
                className="absolute left-4 top-1/2 transform -translate-y-1/2 text-2xl"
                style={{ color }}
              >
                $
              </span>
              <input
                type="number"
                value={amount}
                onChange={(e) => setAmount(e.target.value)}
                placeholder="0.00"
                className="w-full text-white text-2xl font-semibold rounded-2xl pl-10 pr-4 py-4 focus:outline-none focus:ring-2 transition-all backdrop-blur-xl border"
                style={{ 
                  background: 'rgba(44, 44, 46, 0.6)',
                  borderColor: 'rgba(255, 255, 255, 0.1)',
                  '--tw-ring-color': color 
                } as React.CSSProperties}
                required
              />
            </div>
          </div>

          {/* Description */}
          <div>
            <label className="text-[#8E8E93] text-sm mb-2 block">Descripción</label>
            <input
              type="text"
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              placeholder="Ej: Compras del supermercado"
              className="w-full text-white rounded-2xl px-4 py-3 focus:outline-none focus:ring-2 transition-all backdrop-blur-xl border"
              style={{ 
                background: 'rgba(44, 44, 46, 0.6)',
                borderColor: 'rgba(255, 255, 255, 0.1)',
                '--tw-ring-color': color 
              } as React.CSSProperties}
              required
            />
          </div>

          {/* Category */}
          <div>
            <label className="text-[#8E8E93] text-sm mb-2 block">Categoría</label>
            <div className="grid grid-cols-3 gap-2">
              {categories.map((cat) => (
                <button
                  key={cat}
                  type="button"
                  onClick={() => setCategory(cat)}
                  className="px-4 py-3 rounded-xl text-sm font-medium transition-all backdrop-blur-xl border"
                  style={{
                    background: category === cat ? color : 'rgba(44, 44, 46, 0.6)',
                    borderColor: category === cat ? color : 'rgba(255, 255, 255, 0.1)',
                    color: category === cat ? 'white' : '#8E8E93',
                    boxShadow: category === cat ? `0 4px 12px ${color}40` : 'none'
                  }}
                >
                  {cat}
                </button>
              ))}
            </div>
          </div>

          {/* Submit Button */}
          <button
            type="submit"
            className="w-full py-4 rounded-2xl text-white font-semibold mt-6 transition-all active:scale-95 border"
            style={{ 
              background: `linear-gradient(135deg, ${color} 0%, ${color}dd 100%)`,
              borderColor: 'rgba(255, 255, 255, 0.2)',
              boxShadow: `0 8px 24px ${color}40, inset 0 1px 0 rgba(255, 255, 255, 0.2)`
            }}
          >
            Guardar {isIncome ? 'Ingreso' : 'Gasto'}
          </button>
        </form>
      </div>

      <style>{`
        @keyframes slide-up {
          from {
            transform: translateY(100%);
          }
          to {
            transform: translateY(0);
          }
        }
        
        .animate-slide-up {
          animation: slide-up 0.3s ease-out;
        }
      `}</style>
    </div>
  );
}