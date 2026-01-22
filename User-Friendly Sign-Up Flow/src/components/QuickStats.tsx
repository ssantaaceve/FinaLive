import { TrendingUp, TrendingDown } from 'lucide-react';

export function QuickStats() {
  const income = 8500.00;
  const expenses = 4200.30;

  return (
    <div className="grid grid-cols-2 gap-3">
      {/* Income Card */}
      <div 
        className="rounded-2xl p-4 backdrop-blur-xl border"
        style={{ 
          background: 'rgba(28, 28, 30, 0.5)',
          borderColor: 'rgba(61, 187, 143, 0.2)',
          boxShadow: '0 4px 24px rgba(0, 0, 0, 0.2), inset 0 1px 0 rgba(255, 255, 255, 0.08)'
        }}
      >
        <div className="flex items-center gap-2 mb-3">
          <div 
            className="w-9 h-9 rounded-full flex items-center justify-center backdrop-blur-md border"
            style={{
              background: 'rgba(61, 187, 143, 0.15)',
              borderColor: 'rgba(61, 187, 143, 0.3)'
            }}
          >
            <TrendingUp className="w-4 h-4 text-[#3DBB8F]" />
          </div>
          <p className="text-[#8E8E93] text-xs">Ingresos</p>
        </div>
        <p className="text-white text-xl font-semibold">
          ${income.toLocaleString('es-CO')}
        </p>
        <p className="text-[#3DBB8F] text-xs mt-1">Este mes</p>
      </div>
      
      {/* Expenses Card */}
      <div 
        className="rounded-2xl p-4 backdrop-blur-xl border"
        style={{ 
          background: 'rgba(28, 28, 30, 0.5)',
          borderColor: 'rgba(255, 95, 95, 0.2)',
          boxShadow: '0 4px 24px rgba(0, 0, 0, 0.2), inset 0 1px 0 rgba(255, 255, 255, 0.08)'
        }}
      >
        <div className="flex items-center gap-2 mb-3">
          <div 
            className="w-9 h-9 rounded-full flex items-center justify-center backdrop-blur-md border"
            style={{
              background: 'rgba(255, 95, 95, 0.15)',
              borderColor: 'rgba(255, 95, 95, 0.3)'
            }}
          >
            <TrendingDown className="w-4 h-4 text-[#FF5F5F]" />
          </div>
          <p className="text-[#8E8E93] text-xs">Gastos</p>
        </div>
        <p className="text-white text-xl font-semibold">
          ${expenses.toLocaleString('es-CO')}
        </p>
        <p className="text-[#FF5F5F] text-xs mt-1">Este mes</p>
      </div>
    </div>
  );
}