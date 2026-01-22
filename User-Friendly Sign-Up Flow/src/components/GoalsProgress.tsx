import { Target } from 'lucide-react';

export function GoalsProgress() {
  const goals = [
    { name: 'Fondo de emergencia', current: 5200, target: 10000, color: '#3DBB8F' },
    { name: 'Vacaciones', current: 1800, target: 3000, color: '#FFC040' }
  ];

  return (
    <div 
      className="rounded-2xl p-5 backdrop-blur-xl border"
      style={{ 
        background: 'rgba(28, 28, 30, 0.5)',
        borderColor: 'rgba(255, 255, 255, 0.1)',
        boxShadow: '0 4px 24px rgba(0, 0, 0, 0.2), inset 0 1px 0 rgba(255, 255, 255, 0.08)'
      }}
    >
      <div className="flex items-center gap-2 mb-4">
        <div 
          className="w-8 h-8 rounded-full flex items-center justify-center backdrop-blur-md border"
          style={{
            background: 'rgba(61, 187, 143, 0.15)',
            borderColor: 'rgba(61, 187, 143, 0.3)'
          }}
        >
          <Target className="w-4 h-4 text-[#3DBB8F]" />
        </div>
        <h2 className="text-white font-semibold">Cumplimiento de Metas</h2>
      </div>
      
      <div className="space-y-4">
        {goals.map((goal, index) => {
          const progress = (goal.current / goal.target) * 100;
          
          return (
            <div key={index}>
              <div className="flex justify-between items-center mb-2">
                <p className="text-white text-sm">{goal.name}</p>
                <p className="text-[#8E8E93] text-xs font-medium">
                  {progress.toFixed(0)}%
                </p>
              </div>
              
              {/* Progress Bar */}
              <div 
                className="w-full h-2.5 rounded-full overflow-hidden backdrop-blur-sm border"
                style={{
                  background: 'rgba(44, 44, 46, 0.6)',
                  borderColor: 'rgba(255, 255, 255, 0.05)'
                }}
              >
                <div 
                  className="h-full rounded-full transition-all duration-500 relative overflow-hidden"
                  style={{ 
                    width: `${Math.min(progress, 100)}%`,
                    background: `linear-gradient(90deg, ${goal.color} 0%, ${goal.color}dd 100%)`,
                    boxShadow: `0 0 10px ${goal.color}60`
                  }}
                >
                  <div 
                    className="absolute inset-0"
                    style={{
                      background: 'linear-gradient(180deg, rgba(255,255,255,0.3) 0%, transparent 50%, rgba(0,0,0,0.2) 100%)'
                    }}
                  />
                </div>
              </div>
              
              <p className="text-[#8E8E93] text-xs mt-1.5">
                ${goal.current.toLocaleString('es-CO')} de ${goal.target.toLocaleString('es-CO')}
              </p>
            </div>
          );
        })}
      </div>
    </div>
  );
}