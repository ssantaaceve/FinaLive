import { useState, useRef, useEffect } from 'react';
import { Home, PieChart, TrendingUp, User, Plus } from 'lucide-react';

interface BottomNavigationProps {
  onSwipe: (type: 'income' | 'expense') => void;
}

export function BottomNavigation({ onSwipe }: BottomNavigationProps) {
  const [activeTab, setActiveTab] = useState('home');
  const [isDragging, setIsDragging] = useState(false);
  const [dragY, setDragY] = useState(0);
  const [startY, setStartY] = useState(0);
  const buttonRef = useRef<HTMLButtonElement>(null);

  const handleTouchStart = (e: React.TouchEvent) => {
    setIsDragging(true);
    setStartY(e.touches[0].clientY);
  };

  const handleTouchMove = (e: React.TouchEvent) => {
    if (!isDragging) return;
    
    const currentY = e.touches[0].clientY;
    const delta = startY - currentY;
    
    // Limit drag to prevent excessive movement
    const limitedDelta = Math.max(-60, Math.min(60, delta));
    setDragY(limitedDelta);
  };

  const handleTouchEnd = () => {
    setIsDragging(false);
    
    // Trigger action based on drag direction
    if (dragY > 30) {
      // Swipe up - Register expense
      onSwipe('expense');
    } else if (dragY < -30) {
      // Swipe down - Register income
      onSwipe('income');
    }
    
    setDragY(0);
  };

  const tabs = [
    { id: 'home', icon: Home, label: 'Inicio' },
    { id: 'analytics', icon: PieChart, label: 'Análisis' },
    { id: 'add', icon: Plus, label: '', isCenter: true },
    { id: 'investments', icon: TrendingUp, label: 'Inversiones' },
    { id: 'profile', icon: User, label: 'Perfil' }
  ];

  return (
    <div className="fixed bottom-0 left-0 right-0 z-50">
      {/* Drag Hint */}
      {isDragging && (
        <div className="absolute bottom-24 left-0 right-0 flex flex-col items-center gap-1 animate-pulse">
          <div 
            className="px-4 py-2 rounded-full text-xs font-medium"
            style={{
              background: dragY > 0 ? '#FF5F5F' : '#3DBB8F',
              color: 'white'
            }}
          >
            {dragY > 0 ? '↑ Registrar Gasto' : '↓ Registrar Ingreso'}
          </div>
        </div>
      )}
      
      {/* Navigation Bar */}
      <div 
        className="relative px-2 pt-2 pb-4 safe-area-bottom backdrop-blur-2xl border-t"
        style={{
          background: 'rgba(0, 0, 8, 0.8)',
          borderTopColor: 'rgba(255, 255, 255, 0.1)',
          boxShadow: '0 -4px 24px rgba(0, 0, 0, 0.3), inset 0 1px 0 rgba(255, 255, 255, 0.05)'
        }}
      >
        <div className="flex items-center justify-between max-w-md mx-auto relative px-2">
          {tabs.map((tab) => {
            if (tab.isCenter) {
              return (
                <button
                  key={tab.id}
                  ref={buttonRef}
                  onTouchStart={handleTouchStart}
                  onTouchMove={handleTouchMove}
                  onTouchEnd={handleTouchEnd}
                  className="relative -mt-6 touch-none flex-shrink-0"
                  style={{
                    transform: `translateY(${-dragY}px)`,
                    transition: isDragging ? 'none' : 'transform 0.3s ease-out'
                  }}
                >
                  <div 
                    className="w-14 h-14 rounded-full flex items-center justify-center relative"
                    style={{
                      background: 'linear-gradient(135deg, #3DBB8F 0%, #2EA37A 100%)',
                      boxShadow: '0 8px 24px rgba(61, 187, 143, 0.5), inset 0 1px 0 rgba(255, 255, 255, 0.2)'
                    }}
                  >
                    <Plus className="w-6 h-6 text-white" />
                    
                    {/* Animated ring on drag */}
                    {isDragging && (
                      <div 
                        className="absolute inset-0 rounded-full border-2 animate-ping"
                        style={{
                          borderColor: dragY > 0 ? '#FF5F5F' : '#3DBB8F'
                        }}
                      />
                    )}
                  </div>
                  
                  {/* Swipe indicators */}
                  <div className="absolute -top-1.5 left-1/2 transform -translate-x-1/2 flex flex-col items-center gap-0.5">
                    <div 
                      className="w-1 h-1 rounded-full transition-all"
                      style={{
                        background: dragY < 0 ? '#3DBB8F' : '#48484A',
                        opacity: dragY < 0 ? 1 : 0.3
                      }}
                    />
                  </div>
                  <div className="absolute -bottom-1.5 left-1/2 transform -translate-x-1/2 flex flex-col items-center gap-0.5">
                    <div 
                      className="w-1 h-1 rounded-full transition-all"
                      style={{
                        background: dragY > 0 ? '#FF5F5F' : '#48484A',
                        opacity: dragY > 0 ? 1 : 0.3
                      }}
                    />
                  </div>
                </button>
              );
            }

            const isActive = activeTab === tab.id;
            const Icon = tab.icon;

            return (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id)}
                className="flex flex-col items-center gap-0.5 py-2 px-2 rounded-xl transition-all flex-shrink-0 min-w-0"
              >
                <Icon 
                  className="w-5 h-5 flex-shrink-0"
                  style={{ 
                    color: isActive ? '#3DBB8F' : '#8E8E93'
                  }}
                />
                <span 
                  className="text-[10px] leading-tight whitespace-nowrap"
                  style={{ 
                    color: isActive ? '#3DBB8F' : '#8E8E93'
                  }}
                >
                  {tab.label}
                </span>
              </button>
            );
          })}
        </div>
      </div>
    </div>
  );
}