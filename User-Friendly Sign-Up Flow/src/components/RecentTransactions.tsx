import { 
  ShoppingBag, 
  Coffee, 
  Briefcase, 
  Home,
  ChevronRight 
} from 'lucide-react';

const transactions = [
  {
    id: 1,
    type: 'expense',
    category: 'Compras',
    description: 'Supermercado',
    amount: 125.50,
    date: 'Hoy, 14:30',
    icon: ShoppingBag,
    color: '#FF5F5F'
  },
  {
    id: 2,
    type: 'expense',
    category: 'Alimentación',
    description: 'Café y desayuno',
    amount: 15.00,
    date: 'Hoy, 09:15',
    icon: Coffee,
    color: '#FFC040'
  },
  {
    id: 3,
    type: 'income',
    category: 'Salario',
    description: 'Pago quincenal',
    amount: 2500.00,
    date: 'Ayer, 08:00',
    icon: Briefcase,
    color: '#3DBB8F'
  },
  {
    id: 4,
    type: 'expense',
    category: 'Servicios',
    description: 'Arriendo',
    amount: 800.00,
    date: '18 Ene',
    icon: Home,
    color: '#FF5F5F'
  }
];

export function RecentTransactions() {
  return (
    <div 
      className="rounded-2xl p-5 mb-4 backdrop-blur-xl border"
      style={{ 
        background: 'rgba(28, 28, 30, 0.5)',
        borderColor: 'rgba(255, 255, 255, 0.1)',
        boxShadow: '0 4px 24px rgba(0, 0, 0, 0.2), inset 0 1px 0 rgba(255, 255, 255, 0.08)'
      }}
    >
      <div className="flex items-center justify-between mb-4">
        <h2 className="text-white font-semibold">Últimos Movimientos</h2>
        <button className="text-[#3DBB8F] text-sm font-medium">Ver todos</button>
      </div>
      
      <div className="space-y-2">
        {transactions.map((transaction) => (
          <div 
            key={transaction.id}
            className="flex items-center gap-3 p-3 rounded-xl transition-all cursor-pointer border"
            style={{
              background: 'rgba(44, 44, 46, 0.3)',
              borderColor: 'rgba(255, 255, 255, 0.05)',
              backdropFilter: 'blur(10px)'
            }}
            onMouseEnter={(e) => {
              e.currentTarget.style.background = 'rgba(44, 44, 46, 0.5)';
              e.currentTarget.style.borderColor = 'rgba(255, 255, 255, 0.1)';
            }}
            onMouseLeave={(e) => {
              e.currentTarget.style.background = 'rgba(44, 44, 46, 0.3)';
              e.currentTarget.style.borderColor = 'rgba(255, 255, 255, 0.05)';
            }}
          >
            {/* Icon */}
            <div 
              className="w-10 h-10 rounded-full flex items-center justify-center backdrop-blur-md border"
              style={{ 
                backgroundColor: `${transaction.color}20`,
                borderColor: `${transaction.color}40`
              }}
            >
              <transaction.icon 
                className="w-5 h-5" 
                style={{ color: transaction.color }}
              />
            </div>
            
            {/* Info */}
            <div className="flex-1">
              <p className="text-white text-sm font-medium">
                {transaction.description}
              </p>
              <p className="text-[#8E8E93] text-xs">
                {transaction.category} • {transaction.date}
              </p>
            </div>
            
            {/* Amount */}
            <div className="text-right">
              <p 
                className="text-sm font-semibold"
                style={{ 
                  color: transaction.type === 'income' ? '#3DBB8F' : '#FF5F5F' 
                }}
              >
                {transaction.type === 'income' ? '+' : '-'}
                ${transaction.amount.toLocaleString('es-CO')}
              </p>
            </div>
            
            {/* Arrow */}
            <ChevronRight className="w-4 h-4 text-[#48484A]" />
          </div>
        ))}
      </div>
    </div>
  );
}