import { Eye, EyeOff } from 'lucide-react';
import { useState } from 'react';

export function BalanceCard() {
  const [showBalance, setShowBalance] = useState(true);
  const balance = 15420.50;

  return (
    <div 
      className="rounded-3xl p-6 relative overflow-hidden backdrop-blur-xl border"
      style={{
        background: 'rgba(28, 28, 30, 0.6)',
        borderColor: 'rgba(255, 255, 255, 0.1)',
        boxShadow: '0 8px 32px rgba(0, 0, 0, 0.3), inset 0 1px 0 rgba(255, 255, 255, 0.1)'
      }}
    >
      {/* Decorative gradient overlay */}
      <div 
        className="absolute top-0 right-0 w-40 h-40 rounded-full blur-3xl opacity-30"
        style={{ background: 'radial-gradient(circle, #3DBB8F 0%, transparent 70%)' }}
      />
      
      <div className="relative z-10">
        <div className="flex items-center justify-between mb-2">
          <p className="text-[#8E8E93] text-sm">Balance Total</p>
          <button 
            onClick={() => setShowBalance(!showBalance)}
            className="p-1.5 rounded-lg backdrop-blur-md hover:bg-white/10 transition-all"
            style={{ background: 'rgba(255, 255, 255, 0.05)' }}
          >
            {showBalance ? (
              <Eye className="w-4 h-4 text-[#8E8E93]" />
            ) : (
              <EyeOff className="w-4 h-4 text-[#8E8E93]" />
            )}
          </button>
        </div>
        
        <div className="text-white text-4xl font-bold mb-1">
          {showBalance ? (
            `$${balance.toLocaleString('es-CO', { minimumFractionDigits: 2 })}`
          ) : (
            '••••••'
          )}
        </div>
        
        <p className="text-[#3DBB8F] text-sm font-medium">
          +2.5% vs mes anterior
        </p>
      </div>
    </div>
  );
}